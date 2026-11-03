local M = {}

-- Lualine's solid section separators. Drawn in the section's colour over the
-- bar, they cut a > and < notch into the bar's ends.
local LEFT_SEP = ''
local RIGHT_SEP = ''

local FILL_FG = 0xE5E5E5
local FILL_BG = 0x007ACC
-- Length of the bar's fade in/out. Colours blend from the statusline background.
local FADE_MS = 100
-- Length of newly filled cells fading in. Kept under the ~50ms between LSP
-- progress reports, or each report cuts the last fade short and the fill steps.
local GROW_MS = 25
-- ~120 fps; steps are timed, so slow frames don't stretch the fade.
local FRAME_MS = 8
-- Servers often end one task and start the next right away; wait this long
-- with nothing running before fading out, so the bar doesn't blink between them.
local HIDE_DELAY_MS = 500

-- 0 = hidden, 1 = fully shown.
local alpha = 0
local fade_target = 0
-- Cells filled by the latest update fade in from `settled` (percent already
-- fully shown) up to `target`; `grow` runs 0 to 1.
local settled = 0
local target = 0
local grow = 1
local anim_timer
local hide_timer
-- What the bar last drew, kept so the fade-out has something to show after
-- the task is gone.
local shown
-- The task on the bar. It stays until it ends, so short tasks starting
-- alongside it don't make the fill jump back and forth.
local current_id

-- Cells the bar took in the last render, so it can be left out when measuring
-- the rest of the statusline.
local last_width = 0

---@class utils.progress.Item
---@field title? string
---@field message? string
---@field percent? integer
---@field client_id? integer

---@type table<string, utils.progress.Item>
local items = {}
-- Insertion order, so the bar can move on to the newest task.
---@type string[]
local order = {}

-- Lualine draws a cached string, so a plain redrawstatus would show stale text.
local function refresh()
  pcall(require('lualine').refresh, { place = { 'statusline' } })
end

local update_highlights
local last_step

local function step()
  local now = vim.uv.hrtime()
  local elapsed = (now - last_step) / 1e6
  last_step = now
  local delta = elapsed / FADE_MS
  if fade_target > alpha then
    alpha = math.min(alpha + delta, fade_target)
  else
    alpha = math.max(alpha - delta, fade_target)
  end
  grow = math.min(grow + elapsed / GROW_MS, 1)
  if alpha == 0 then
    -- Fully faded out: let lualine drop the bar.
    grow = 1
    refresh()
  else
    -- Only the colours change mid-animation, and setting them redraws on its
    -- own, which is far cheaper than re-rendering all of lualine.
    update_highlights()
  end
  if alpha == fade_target and grow == 1 then
    anim_timer:stop()
  end
end

local function animate()
  anim_timer = anim_timer or vim.uv.new_timer()
  if not anim_timer:is_active() then
    last_step = vim.uv.hrtime()
    anim_timer:start(0, FRAME_MS, vim.schedule_wrap(step))
  end
end

local function fade(to)
  fade_target = to
  animate()
end

local function set(id, item)
  if hide_timer then
    hide_timer:stop()
  end
  if fade_target == 0 then
    fade(1)
  end
  if not items[id] then
    table.insert(order, id)
  end
  items[id] = item
  refresh()
end

local function remove(id)
  if not items[id] then
    return
  end
  items[id] = nil
  for i, v in ipairs(order) do
    if v == id then
      table.remove(order, i)
      break
    end
  end
  if #order == 0 then
    hide_timer = hide_timer or vim.uv.new_timer()
    hide_timer:start(
      HIDE_DELAY_MS,
      0,
      vim.schedule_wrap(function()
        fade(0)
      end)
    )
  end
  refresh()
end

local function escape(str)
  return (str:gsub('%%', '%%%%'))
end

--- Width left over for the bar: the screen minus everything else lualine drew
--- last time. Lags lualine's refresh by one tick when other sections change.
local function available_width()
  local stl = vim.wo.statusline ~= '' and vim.wo.statusline or vim.go.statusline
  local bar_width = stl:find('ProgressBarText', 1, true) and last_width or 0
  -- Without the fill items the string measures its real content.
  stl = stl:gsub('%%=', '')
  local used = vim.api.nvim_eval_statusline(stl, { maxwidth = 10000 }).width - bar_width
  return vim.o.columns - used
end

local function section_hl()
  return require('lualine.highlight').format_highlight('c', true)
end

local function blend(from, to, t)
  local out = 0
  for shift = 0, 16, 8 do
    local a = bit.band(bit.rshift(from, shift), 0xFF)
    local b = bit.band(bit.rshift(to, shift), 0xFF)
    out = out + bit.lshift(math.floor(a + (b - a) * t + 0.5), shift)
  end
  return out
end

-- Setting a highlight forces a full redraw, so only do it when the colours change.
local function set_hl(name, spec)
  local current = vim.api.nvim_get_hl(0, { name = name })
  if current.fg ~= spec.fg or current.bg ~= spec.bg then
    vim.api.nvim_set_hl(0, name, spec)
  end
end

--- Bar colours at the current fade, blended from lualine_c's.
function update_highlights()
  local section = vim.api.nvim_get_hl(0, { name = section_hl():match '%%#(.-)#', link = false })
  local bg = section.bg or 0
  local fill_fg, fill_bg = blend(bg, FILL_FG, alpha), blend(bg, FILL_BG, alpha)
  local text_fg = blend(bg, section.fg or 0xFFFFFF, alpha)
  local grow_bg = blend(bg, fill_bg, grow)
  set_hl('ProgressBarFill', { fg = fill_fg, bg = fill_bg, bold = true })
  set_hl('ProgressBarGrow', { fg = blend(text_fg, fill_fg, grow), bg = grow_bg, bold = true })
  set_hl('ProgressBarText', { fg = text_fg, bg = bg })
  -- Notch in lualine_c's background cut into the filled bar, like lualine's
  -- own section separators.
  set_hl('ProgressBarFillSep', { fg = bg, bg = fill_bg })
  set_hl('ProgressBarGrowSep', { fg = bg, bg = grow_bg })
  -- The fill's leading edge, pointing into the empty part.
  set_hl('ProgressBarFillTip', { fg = fill_bg, bg = bg })
  set_hl('ProgressBarGrowTip', { fg = grow_bg, bg = bg })
end

--- Separator notch on a filled end; an empty end is just blank.
---@param group? string
local function separator(glyph, group)
  if not group then
    return section_hl() .. ' '
  end
  return '%#' .. group .. 'Sep#' .. glyph
end

function M.setup()
  local group = vim.api.nvim_create_augroup('utils-progress', { clear = true })

  -- LSP $/progress (Roslyn solution loading, lua_ls workspace indexing, ...)
  vim.api.nvim_create_autocmd('LspProgress', {
    group = group,
    callback = function(ev)
      local params = ev.data.params
      local value = params.value
      if type(value) ~= 'table' then
        return
      end
      local id = 'lsp.' .. ev.data.client_id .. '.' .. tostring(params.token)
      if value.kind == 'end' then
        return remove(id)
      end

      local prev = items[id] or {}
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      set(id, {
        -- Only `begin` carries a title; `report` updates keep the previous one.
        title = value.title or prev.title or (client and client.name),
        message = value.message or prev.message,
        percent = value.percentage or prev.percent,
        client_id = ev.data.client_id,
      })
    end,
  })

  -- Servers that crash mid-task never send `end`.
  vim.api.nvim_create_autocmd('LspDetach', {
    group = group,
    callback = function(ev)
      for id, item in pairs(items) do
        if item.client_id == ev.data.client_id then
          remove(id)
        end
      end
    end,
  })

  -- Native progress messages (vim.pack, checkhealth, anything using nvim_echo kind='progress')
  vim.api.nvim_create_autocmd('Progress', {
    group = group,
    callback = function(ev)
      local data = ev.data
      if not data or not data.id then
        return
      end
      local id = 'native.' .. tostring(data.id)
      if data.status ~= 'running' then
        return remove(id)
      end
      -- `text` is the echoed chunks' text: { 'part', ... }
      local message = data.text
      if type(message) == 'table' then
        message = table.concat(message)
      end
      set(id, { title = data.title or data.source, message = message, percent = data.percent })
    end,
  })
end

--- Lualine component: a running task's text inside a bar that fills
--- the free middle of the statusline, its background filling with the
--- percentage. Empty when idle.
function M.status()
  if not items[current_id] then
    current_id = order[#order]
  end
  if current_id then
    if not shown then
      -- The bar's own fade-in covers its starting fill.
      local pct = items[current_id].percent or 0
      settled, target = pct, pct
    end
    shown = { item = items[current_id], count = #order }
  elseif alpha == 0 then
    shown, settled, target, grow = nil, 0, 0, 1
  end
  if not shown then
    return ''
  end
  local item = shown.item

  local text = item.title or ''
  if item.message and item.message ~= '' then
    text = text ~= '' and (text .. ': ' .. item.message) or item.message
  end
  if item.percent then
    text = string.format('%d%%  %s', item.percent, text)
  end
  if shown.count > 1 then
    text = string.format('%s (+%d)', text, shown.count - 1)
  end

  -- The two separators take a cell each, and the fill's arrow tip another.
  local width = math.max(available_width() - 2, 2)
  local label_width = width - 1
  if vim.fn.strchars(text) > label_width then
    text = vim.fn.strcharpart(text, 0, label_width - 1) .. '…'
  end
  local pad = math.max(label_width - vim.fn.strchars(text), 0)
  local label = string.rep(' ', math.floor(pad / 2)) .. text .. string.rep(' ', math.ceil(pad / 2))

  local percent = item.percent or 0
  if percent ~= target then
    if percent > target then
      -- Whatever was still fading in counts as shown; the new cells fade in.
      settled, grow = target, 0
      animate()
    else
      settled, grow = percent, 1
    end
    target = percent
  end
  update_highlights()

  local function cells(pct)
    return math.floor(pct / 100 * label_width + 0.5)
  end
  local function edge(pct)
    return settled >= pct and 'ProgressBarFill' or 'ProgressBarGrow'
  end
  local solid, filled = cells(settled), cells(percent)

  -- The fill ends in a right-facing separator. It gets its own cell, so it
  -- never covers the text; a full bar fills that cell instead, and an empty
  -- one leaves it blank.
  local tip
  if percent >= 100 then
    tip = '%#' .. edge(100) .. '# '
  elseif percent > 0 then
    tip = '%#' .. (solid < filled and 'ProgressBarGrow' or 'ProgressBarFill') .. 'Tip#' .. LEFT_SEP
  else
    tip = '%#ProgressBarText# '
  end

  -- The empty part is lualine's own background, so only the fill shows.
  last_width = width + 2
  return separator(LEFT_SEP, percent > 0 and edge(1) or nil)
    .. '%#ProgressBarFill#'
    .. escape(vim.fn.strcharpart(label, 0, solid))
    .. '%#ProgressBarGrow#'
    .. escape(vim.fn.strcharpart(label, solid, filled - solid))
    .. tip
    .. '%#ProgressBarText#'
    .. escape(vim.fn.strcharpart(label, filled))
    .. separator(RIGHT_SEP, percent >= 100 and edge(100) or nil)
    .. section_hl()
end

return M
