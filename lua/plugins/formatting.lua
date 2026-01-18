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
    formatters_by_ft = {
      lua = { 'stylua' },

      -- C# Support added
      cs = { 'csharpier' },

      -- Go Support (Linux Only)
      go = function(bufnr)
        if vim.fn.has 'win32' == 0 then
          return { 'goimports' }
        end
        return {}
      end,

      -- Web Stack
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      css = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },

      markdown = { 'prettier' },
    },

    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
