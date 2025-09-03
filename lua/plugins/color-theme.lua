-- return {
--   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
--   'folke/tokyonight.nvim',
--   priority = 1000, -- Make sure to load this before all the other start plugins.
--   config = function()
--     ---@diagnostic disable-next-line: missing-fields
--     require('tokyonight').setup {
--       styles = {
--         comments = { italic = true }, -- Disable italics in comments
--       },
--     }
--
--     -- Like many other themes, this one has different styles, and you could load
--     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--     vim.cmd.colorscheme 'tokyonight-storm'
--   end,
-- }

return {
  'gmr458/vscode_modern_theme.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('vscode_modern').setup {
      cursorline = true,
      transparent_background = true,
      nvim_tree_darker = true,
    }
    vim.cmd.colorscheme 'vscode_modern'
    vim.api.nvim_set_hl(0, '@lsp.type.class.cs', { fg = '#4EC9B0' })
    vim.api.nvim_set_hl(0, '@lsp.type.static.cs', { link = '@lsp.type.class.cs' })
    vim.api.nvim_set_hl(0, '@lsp.type.property.cs', { fg = '#DCDCDC' })
    vim.api.nvim_set_hl(0, '@lsp.type.variable.cs', { fg = '#9CDCFE' })
    vim.api.nvim_set_hl(0, '@lsp.type.parameter.cs', { link = '@lsp.type.variable.cs' })
    vim.api.nvim_set_hl(0, '@lsp.type.namespace.cs', { link = '@lsp.type.property.cs' })
    vim.api.nvim_set_hl(0, '@lsp.type.enumMember.cs', { link = '@lsp.type.property.cs' })
    vim.api.nvim_set_hl(0, '@lsp.typemod.constant.static.cs', { link = '@lsp.type.property.cs' })
    vim.api.nvim_set_hl(0, '@lsp.type.interface.cs', { fg = '#B8D7A3' })
    vim.api.nvim_set_hl(0, '@lsp.type.enum.cs', { link = '@lsp.type.interface.cs' })
    vim.api.nvim_set_hl(0, '@lsp.type.method.cs', { fg = '#DCDCAA' })
    vim.api.nvim_set_hl(0, '@lsp.type.extensionMethod.cs', { link = '@lsp.type.method' })
  end,
}
