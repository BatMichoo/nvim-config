return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'VeryLazy',
  priority = 1000,
  config = function()
    require('tiny-inline-diagnostic').setup {
      preset = 'minimal',
      transparent_bg = vim.fn.has 'win32' == 0,
      options = {
        show_source = {
          enabled = true,
          if_many = true,
        },
        use_icons_from_diagnostic = true,
      },
    }
    vim.diagnostic.config { virtual_text = false } -- Disable default virtual text
  end,
}
