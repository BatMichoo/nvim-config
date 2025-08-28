return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim', --  WARN: Required for eslint_d
  },
  config = function()
    local null_ls = require 'null-ls'

    null_ls.setup {
      debug = true,
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.markdownlint,

        require 'none-ls.diagnostics.eslint_d',
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.golangci_lint,
      },
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('LspFormatting' .. bufnr, { clear = true }),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { bufnr = bufnr, async = false }
            end,
          })
        end
      end,

      vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = '[F]ormat Document' }),
    }
  end,
}
