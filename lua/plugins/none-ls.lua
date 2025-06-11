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

        require("none-ls.diagnostics.eslint_d"),
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.golangci_lint,
      },

      vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, {}),
    }
  end,
}
