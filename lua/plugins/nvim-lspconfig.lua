return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    {
      'mason-org/mason.nvim',
      opts = {
        registries = {
          'github:mason-org/mason-registry',
          'github:Crashdummyy/mason-registry',
        },
      },
    },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    local utils = require 'utils'
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

    local servers = {
      cssls = {},
      html = {},
      lemminx = {}, -- XML/XAML
      ts_ls = {
        init_options = {
          preferences = {
            disableSuggestions = true,
            includeCompletionsForModuleExports = true,
            includeCompletionsWithInsertText = true,
            importModuleSpecifierPreference = 'relative',
          },
        },
        settings = {
          javascript = {
            semanticTokens = { enable = 'all' },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true, showOnAllFunctions = true },
          },
          typescript = {
            semanticTokens = { enable = 'all' },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true, showOnAllFunctions = true },
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
          },
        },
      },
      jsonls = {},
      eslint = {},
    }

    if utils.is_linux then
      servers.htmx = { filetypes = { 'html' } }
      servers.dockerls = {}
      servers.docker_compose_language_service = { filetypes = { 'yaml.docker-compose' } }
      servers.gopls = {}
      servers.sqls = {}
    end

    -- 3. Mason Setup
    local linters = { 'hadolint', 'markdownlint' }
    local formatters = { 'stylua', 'prettier' }

    if utils.is_linux then
      table.insert(linters, 'golangci-lint')
      table.insert(formatters, 'goimports')
    end

    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, linters)
    vim.list_extend(ensure_installed, formatters)
    table.insert(ensure_installed, 'roslyn')

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

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
