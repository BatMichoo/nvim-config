local function open_DBUI_in_a_new_tab()
  local current = vim.api.nvim_get_current_tabpage()
  if vim.t[current].dbui_tab then
    if #vim.api.nvim_list_tabpages() > 1 then
      vim.cmd.tabclose()
    end
    return
  end

  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    if vim.t[tab].dbui_tab then
      vim.api.nvim_set_current_tabpage(tab)
      return
    end
  end

  vim.cmd 'tabnew'
  vim.t.dbui_tab = true
  vim.cmd 'DBUI'
end

local function build_url(def, host)
  local opts = {}
  for k, v in pairs(def.auth or {}) do
    table.insert(opts, k .. '=' .. v)
  end
  local query = #opts > 0 and ('?' .. table.concat(opts, '&')) or ''
  return ('%s://%s:%d/%s%s'):format(def.scheme or 'sqlserver', host, def.port or 1433, def.db, query)
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

return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1

    vim.keymap.set('n', '<leader>db', open_DBUI_in_a_new_tab, { desc = 'DBUI' })

    local ok, databases = pcall(require, DB_FILE_NAME)
    if ok and type(databases) == 'table' then
      vim.g.dbs = build_connections(databases)
    end
  end,
}
