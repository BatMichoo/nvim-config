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

    local type_color = '#4EC9B0'
    local interface_color = '#B8D7A3'
    local variable_color = '#9CDCFE'
    local method_color = '#DCDCAA'
    local property_color = '#DCDCDC'
    local keyword_color = '#569CD6'
    local control_keyword_color = '#D8A0DF'

    -- Set base highlight groups with colors
    vim.api.nvim_set_hl(0, '@type.c_sharp', { fg = type_color })
    vim.api.nvim_set_hl(0, '@variable.c_sharp', { fg = variable_color })
    vim.api.nvim_set_hl(0, '@variable.field.c_sharp', { fg = property_color })
    vim.api.nvim_set_hl(0, '@variable.member.c_sharp', { fg = property_color })
    vim.api.nvim_set_hl(0, '@function.c_sharp', { fg = method_color })
    vim.api.nvim_set_hl(0, '@keyword.c_sharp', { fg = keyword_color })
    vim.api.nvim_set_hl(0, '@keyword.import.c_sharp', { fg = keyword_color })
    vim.api.nvim_set_hl(0, '@keyword.control.c_sharp', { fg = control_keyword_color })
    vim.api.nvim_set_hl(0, '@constant.builtin.c_sharp', { fg = keyword_color })

    -- Link specific highlight groups to their base groups
    vim.api.nvim_set_hl(0, '@variable.parameter.c_sharp', { link = '@variable.c_sharp' })
    vim.api.nvim_set_hl(0, '@constant.c_sharp', { link = '@variable.c_sharp' })
    vim.api.nvim_set_hl(0, '@method.c_sharp', { link = '@function.c_sharp' })
    vim.api.nvim_set_hl(0, '@type.enum.c_sharp', { link = '@type.c_sharp' })
    vim.api.nvim_set_hl(0, '@type.struct.c_sharp', { link = '@type.c_sharp' })
    vim.api.nvim_set_hl(0, '@keyword.import.c_sharp', { link = '@keyword.c_sharp' })

    -- LSP specific highlight groups
    vim.api.nvim_set_hl(0, '@lsp.type.keyword.cs', { link = '@keyword.c_sharp' })
    vim.api.nvim_set_hl(0, '@lsp.type.controlKeyword.cs', { link = '@keyword.control.c_sharp' })
    vim.api.nvim_set_hl(0, '@lsp.type.class.cs', { link = '@type.c_sharp' })
    vim.api.nvim_set_hl(0, '@lsp.type.static.cs', { link = '@type.c_sharp' })
    vim.api.nvim_set_hl(0, '@lsp.type.field.cs', { link = '@variable.field.c_sharp' })
    vim.api.nvim_set_hl(0, '@lsp.type.property.cs', { link = '@variable.member.c_sharp' })
    vim.api.nvim_set_hl(0, '@lsp.type.variable.cs', { link = '@variable.c_sharp' })
    vim.api.nvim_set_hl(0, '@lsp.type.parameter.cs', { link = '@variable.c_sharp' })
    vim.api.nvim_set_hl(0, '@lsp.type.namespace.cs', { link = '@variable.member.c_sharp' })
    vim.api.nvim_set_hl(0, '@lsp.type.enumMember.cs', { link = '@variable.member.c_sharp' })
    vim.api.nvim_set_hl(0, '@lsp.typemod.constant.static.cs', { link = '@variable.member.c_sharp' })
    vim.api.nvim_set_hl(0, '@lsp.type.interface.cs', { fg = interface_color })
    vim.api.nvim_set_hl(0, '@lsp.type.enum.cs', { link = '@lsp.type.interface.cs' })
    vim.api.nvim_set_hl(0, '@lsp.type.method.cs', { link = '@function.c_sharp' })
    vim.api.nvim_set_hl(0, '@lsp.type.extensionMethod.cs', { link = '@function.c_sharp' })
  end,
}
