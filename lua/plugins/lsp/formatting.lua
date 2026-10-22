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
    formatters = require('lsp.formatters').get_definitions(),

    format_on_save = function(bufnr)
      -- dotnet format needs ~1s to spin up
      local timeout_ms = vim.bo[bufnr].filetype == 'cs' and 3000 or 500
      return { timeout_ms = timeout_ms, lsp_fallback = true }
    end,
  },
}
