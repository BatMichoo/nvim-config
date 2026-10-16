local function toggle_grip_tab()
  local current = vim.api.nvim_get_current_tabpage()
  if vim.t[current].grip_tab then
    if #vim.api.nvim_list_tabpages() > 1 then
      vim.cmd.tabclose()
    end
    return
  end

  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    if vim.t[tab].grip_tab then
      vim.api.nvim_set_current_tabpage(tab)
      return
    end
  end

  vim.cmd 'tabnew'
  vim.t.grip_tab = true
  -- Reconnects to the last used connection, or opens the picker when there is none
  vim.cmd 'GripToggle'
end

local DEFAULT_SCHEME = 'sqlserver'
local DEFAULT_PORT = 1433
local function build_url(def, host)
  -- Sorted so the URL is stable across sessions: grip dedupes connections by URL
  local keys = vim.tbl_keys(def.auth or {})
  table.sort(keys)
  local opts = {}
  for _, k in ipairs(keys) do
    table.insert(opts, k .. '=' .. def.auth[k])
  end
  local query = #opts > 0 and ('?' .. table.concat(opts, '&')) or ''
  return ('%s://%s:%d/%s%s'):format(def.scheme or DEFAULT_SCHEME, host, def.port or DEFAULT_PORT, def.db, query)
end

local function build_connections(data)
  local dbs = {}
  for _, def in ipairs(data.definitions or {}) do
    for _, key in ipairs(def.servers or {}) do
      local host = (data.servers or {})[key]
      if host or def.url then
        table.insert(dbs, {
          name = ('%s - %s'):format(key, def.name),
          url = def.url or build_url(def, host),
        })
      end
    end
  end
  table.sort(dbs, function(a, b)
    return a.name > b.name
  end)
  return dbs
end

local DB_FILE_NAME = 'databases'

-- Statement under the cursor: the block of non-blank lines around it
local function sql_under_cursor()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local last = vim.api.nvim_buf_line_count(0)
  local function blank(lnum)
    return vim.fn.getline(lnum):match '^%s*$' ~= nil
  end
  if blank(row) then
    return nil
  end
  local first, final = row, row
  while first > 1 and not blank(first - 1) do
    first = first - 1
  end
  while final < last and not blank(final + 1) do
    final = final + 1
  end
  return table.concat(vim.api.nvim_buf_get_lines(0, first - 1, final, false), '\n')
end

local function run_sql(sql)
  if sql and sql ~= '' then
    require('dadbod-grip').open(sql)
  end
end

-- Buffer-local <F5> in SQL files wins over the global debugger <F5>.
-- The grip query pad (grip://) binds its own <F5> via opts.keymaps.qpad_execute.
local function map_sql_execute(args)
  if vim.api.nvim_buf_get_name(args.buf):match '^grip://' then
    return
  end
  vim.keymap.set('n', '<F5>', function()
    run_sql(sql_under_cursor())
  end, { buffer = args.buf, desc = 'Grip: run SQL under cursor' })
  vim.keymap.set('x', '<F5>', function()
    local lines = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = vim.fn.mode() })
    vim.api.nvim_feedkeys(vim.keycode '<Esc>', 'nx', false)
    run_sql(table.concat(lines, '\n'))
  end, { buffer = args.buf, desc = 'Grip: run selected SQL' })
end

return {
  'joryeugene/dadbod-grip.nvim',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  opts = {
    -- Use nvim-cmp (with vim-dadbod-completion) instead of grip's own popup
    completion = false,
    keymaps = {
      qpad_execute = '<F5>',
    },
  },
  config = function(_, opts)
    require('dadbod-grip').setup(opts)
    -- Table/column names for nvim-cmp ({ name = 'dadbod_grip' } in lsp/completion.lua)
    require('dadbod-grip.completion').register_cmp_source()
  end,
  keys = {
    { '<leader>Db', toggle_grip_tab, desc = 'Toggle [b]rowser tab' },
    { '<leader>Dc', '<cmd>GripConnect<cr>', desc = '[c]onnections' },
    { '<leader>Dq', '<cmd>GripQuery<cr>', desc = '[q]uery pad' },
    { '<leader>Dt', '<cmd>GripTables<cr>', desc = '[t]ables' },
    { '<leader>Ds', '<cmd>GripSchema<cr>', desc = '[s]chema browser' },
    { '<leader>Dh', '<cmd>GripHistory<cr>', desc = 'Query [h]istory' },
    { '<leader>Dl', '<cmd>GripLoad<cr>', desc = '[l]oad saved query' },
  },
  init = function()
    -- dadbod-grip reads g:dbs (DBUI-compatible) alongside .grip/connections.json
    local ok, databases = pcall(require, DB_FILE_NAME)
    if ok and type(databases) == 'table' then
      vim.g.dbs = build_connections(databases)
    end

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Run SQL with dadbod-grip on <F5>',
      group = vim.api.nvim_create_augroup('grip-sql-execute', { clear = true }),
      pattern = { 'sql', 'mysql', 'plsql' },
      callback = map_sql_execute,
    })
  end,
}
