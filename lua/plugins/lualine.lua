return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = function()
    local custom_auto = require 'lualine.themes.auto'

    custom_auto.normal.a.bg = '#007ACC'
    custom_auto.normal.b.fg = '#007ACC'
    custom_auto.normal.a.fg = '#E5E5E5'

    local job_indicator = { require('easy-dotnet.ui-modules.jobs').lualine }

    return {
      options = {
        theme = custom_auto,
        globalstatus = true,
        sections = {
          lualine_a = { 'mode', job_indicator },
        },
      },
      -- If you have custom sections, ensure your a and z sections are indeed the outermost
      -- For example, if you overrode sections:
      -- sections = {
      --   lualine_a = { 'mode' },
      --   lualine_b = { 'branch', 'diff', 'diagnostics' },
      --   lualine_c = { 'filename' },
      --   lualine_x = { 'encoding', 'fileformat', 'filetype' },
      --   lualine_y = { 'progress' },
      --   lualine_z = { 'location' },
      -- },
    }
  end,
}
