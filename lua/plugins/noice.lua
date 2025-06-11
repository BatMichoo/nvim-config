return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  opts = {
    presets = {
      -- Have borders around hover and signature help.
      lsp_doc_border = true,
      long_message_to_split = true,
      command_palette = {
        views = {
          cmdline_popup = {
            position = {
              row = '50%',
              col = '50%',
            },
            size = {
              min_width = 70,
              width = 'auto',
              height = 'auto',
            },
          },
          cmdline_popupmenu = {
            position = {
              row = '67%', -- This would position the completion menu below the cmdline popup
              col = '50%',
            },
          },
        },
      },
    },
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      signature = {
        auto_open = { enabled = false },
      },
    },
    status = {
      -- Statusline component for LSP progress notifications.
      lsp_progress = { event = 'lsp', kind = 'progress' },
    },
    routes = {
      -- Ignore the typical vim change messages.
      {
        filter = {
          event = 'msg_show',
          any = {
            { find = '%d+L, %d+B' },
            { find = '; after #%d+' },
            { find = '; before #%d+' },
            { find = '%d fewer lines' },
            { find = '%d more lines' },
          },
        },
        opts = { skip = true },
      },
      -- Don't show these in the default view.
      {
        filter = {
          event = 'lsp',
          kind = 'progress',
        },
        opts = { skip = true },
      },
    },
  },
}
