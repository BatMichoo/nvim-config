return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  -- tag = 'v2.3.0',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    -- Mason must be loaded before its dependents so we need to set it up here.
    -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
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

    -- Useful status updates for LSP.
    {
      'j-hui/fidget.nvim',
      opts = {},
    },

    -- Allows extra capabilities provided by blink.cmp
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

        -- Refresh code lens
        map('grl', '<cmd> lua vim.lsp.codelens.refresh()<CR>', 'Refresh Code lens')

        -- Find references for the word under your cursor.
        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

        -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
          return client:supports_method(method, bufnr)
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- 1. Define Linters (High Priority Sources)
    local linters = {
      'hadolint', -- Dockerfile linter
      'eslint_d', -- JS/TS linter
      'markdownlint', -- Markdown linter
    }

    -- 2. Define Formatters
    local formatters = {
      'stylua', -- Lua formatter
      'prettier', -- JS/TS/CSS/HTML formatter
      'markdownlint', -- Markdown formatter
    }

    if vim.fn.has 'win32' == 0 then
      -- Linters
      table.insert(linters, 'golangci-lint')
      -- Formatters
      table.insert(formatters, 'goimports')
    end

    -- Trusted sources that should override native LSP diagnostics
    local high_priority_sources = {
      ['eslint'] = true,
      ['hadolint'] = true,
      ['markdownlint'] = true,
      ['golangci-lint'] = true,
    }

    -- 3. Diagnostic Config using the high_priority whitelist
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚',
          [vim.diagnostic.severity.WARN] = '󰀪',
          [vim.diagnostic.severity.INFO] = '󰋽',
          [vim.diagnostic.severity.HINT] = '󰌶',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        overflow = 'scroll',
        format = function(diagnostic)
          -- Fetch other diagnostics on the same line
          local diagnostics_on_line = vim.diagnostic.get(diagnostic.bufnr, { lnum = diagnostic.lnum })

          for _, d in ipairs(diagnostics_on_line) do
            if d.message == diagnostic.message and d.source ~= diagnostic.source then
              local current_is_high = high_priority_sources[diagnostic.source]
              local other_is_high = high_priority_sources[d.source]

              -- Logic: If the other diagnostic is from a high-priority linter
              -- and the current one is NOT, hide the current one.
              if other_is_high and not current_is_high then
                return nil
              end

              -- Tie-breaker: If both are high or both are low, stick to alphabetical
              if current_is_high == other_is_high and diagnostic.source > d.source then
                return nil
              end
            end
          end

          return diagnostic.message
        end,
      },
    }

    -- 4. Server Capabilities & Setup
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.filetype.add {
      extension = { xaml = 'xml' },
    }

    -- Define your LSP servers
    local servers = {
      cssls = {},
      html = {},
      lemminx = {}, --XML/XAML
      ts_ls = {
        javascript = { semanticTokens = { enable = 'all' } },
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

    if vim.fn.has 'win32' == 0 then
      local linux_servers = {
        htmx = { filetypes = { 'html' } },
        dockerls = {},
        docker_compose_language_service = { filetypes = { 'yaml.docker-compose' } },
        gopls = {},
        sqls = {},
      }
      -- Merge linux_servers into servers
      for k, v in pairs(linux_servers) do
        servers[k] = v
      end
    end

    -- 5. Merge lists for installation tools (e.g., Mason)
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, linters)
    vim.list_extend(ensure_installed, formatters)
    table.insert(ensure_installed, 'roslyn')

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    for server_name, config in pairs(servers) do
      config.capabilities = capabilities
      vim.lsp.config[server_name] = config
      vim.lsp.enable(server_name)
    end
  end,
}
