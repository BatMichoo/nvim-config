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

return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1

    vim.keymap.set('n', '<leader>db', open_DBUI_in_a_new_tab, { desc = 'DBUI' })
  end,
}
