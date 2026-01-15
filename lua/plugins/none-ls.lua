return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim', --  WARN: Required for eslint_d
  },
  config = function()
    local null_ls = require 'null-ls'

    -- Helper function to prioritize null-ls
    local function format_filter(client)
      local null_ls_sources = require 'null-ls.sources'
      local ft = vim.bo.filetype
      local has_null_ls_formatter = #null_ls_sources.get_available(ft, 'formatting') > 0

      if has_null_ls_formatter then
        return client.name == 'null-ls'
      end

      return true
    end

    null_ls.setup {
      debug = true,
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.markdownlint,
        -- null_ls.builtins.formatting.csharpier,
        require('none-ls.code_actions.eslint_d').with {
          condition = function(utils)
            return utils.root_has_file 'eslint.config.mjs'
          end,
        },

        require('none-ls.diagnostics.eslint_d').with {
          condition = function(utils)
            return utils.root_has_file {
              'eslint.config.js',
              'eslint.config.mjs',
              'eslint.config.cjs',
              '.eslintrc.js',
              '.eslintrc.cjs',
              '.eslintrc.json',
              '.eslintrc',
            }
          end,
        },
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.golangci_lint,
      },
      on_attach = function(client, bufnr)
        if client:supports_method 'textDocument/formatting' then
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('LspFormatting' .. bufnr, { clear = true }),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format {
                bufnr = bufnr,
                async = false,
                filter = format_filter,
              }
            end,
          })
        end
      end,

      vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = '[F]ormat Document' }),
    }
  end,
}
