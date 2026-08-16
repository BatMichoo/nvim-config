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
      float = { border = 'rounded', source = true }, -- Show source to identify duplicate producers
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

    -- mason-lspconfig 2.x dropped the `handlers` setup option in favor of
    -- `automatic_enable`, which calls vim.lsp.enable() directly for every
    -- mason-installed server and never runs a handler callback. So our
    -- per-server overrides must be applied to vim.lsp.config ourselves,
    -- before mason-lspconfig's automatic_enable resolves configs.
    local lspconfig_to_package = require('mason-lspconfig.mappings').get_mason_map().lspconfig_to_package

    for name, server in pairs(servers) do
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      vim.lsp.config[name] = server

      -- automatic_enable already enables every server mapped to a mason
      -- package (installed now, or later via its install-success listener).
      -- Only step in ourselves for servers with no mason mapping at all,
      -- since automatic_enable will never touch those.
      if not lspconfig_to_package[name] then
        vim.lsp.enable(name)
      end
    end

    require('mason-lspconfig').setup {}
  end,
}
