return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    local cmp_lsp = require 'cmp_nvim_lsp'

    -- 1. Diagnostics Config
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'always' }, -- Show source to identify duplicate producers
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚',
          [vim.diagnostic.severity.WARN] = '󰀪',
          [vim.diagnostic.severity.INFO] = '󰋽',
          [vim.diagnostic.severity.HINT] = '󰌶',
        },
      } or {},
      virtual_text = false, -- Disable default virtual text to avoid duplication with tiny-inline-diagnostic
    }

    -- 2. Capabilities & Servers
    local capabilities = vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
    local servers = require('lsp.servers').get()

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          vim.lsp.config[server_name] = server
          vim.lsp.enable(server_name)
        end,
      },
    }
  end,
}
