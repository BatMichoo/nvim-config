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

return {
  -- Fork of joryeugene/dadbod-grip.nvim: adds sqlserver authentication= (Entra ID / az login)
  'BatMichoo/dadbod-grip.nvim',
  branch = 'grip-lite',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  opts = function()
    -- Connections and their picker folders: { servers = { KEY = host }, definitions = { ... } }
    local ok, databases = pcall(require, 'databases')
    return {
      databases = ok and type(databases) == 'table' and databases or nil,
      keymaps = {
        -- gT/gt are Vim's tab switching; table picker moves to <C-t>
        table_picker = '<C-t>',
        table_picker_alt = false,
      },
    }
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
}
