return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat Document',
    },
  },
  opts = {
    log_level = vim.log.levels.DEBUG,
    formatters_by_ft = require('lsp.formatters').get_by_filetype(),

    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
