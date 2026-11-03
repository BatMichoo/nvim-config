local filetype_names = {
  javascriptreact = 'React JS',
  typescriptreact = 'React TS',
  codecompanion_cli = 'AI CLI',
}

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = function()
    local custom_auto = require 'lualine.themes.auto'

    custom_auto.normal.a.bg = '#007ACC'
    custom_auto.normal.a.fg = '#E5E5E5'
    custom_auto.normal.b.fg = '#007ACC'

    local devicons = require 'nvim-web-devicons'
    devicons.set_icon { codecompanion_cli = { icon = '󰚩', color = '#D97757', name = 'AiCli' } }
    devicons.set_icon_by_filetype { codecompanion_cli = 'codecompanion_cli' }

    local job_indicator = { require('easy-dotnet.ui-modules.jobs').lualine }

    local progress = require 'utils.progress'
    progress.setup()

    return {
      options = {
        theme = custom_auto,
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'mode', job_indicator },
        -- The progress bar sizes itself to the free middle and draws its own separators
        lualine_c = { { 'filename', separator = '' }, { progress.status, padding = 0 } },
        lualine_x = {
          {
            'filetype',
            fmt = function(str)
              return filetype_names[str] or str
            end,
          },
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
