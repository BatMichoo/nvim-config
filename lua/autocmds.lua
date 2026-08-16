-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Indentation and Filetype Settings
local indent_group = vim.api.nvim_create_augroup('indent', { clear = true })

-- 2-space indentation for web/config formats
vim.api.nvim_create_autocmd('FileType', {
  group = indent_group,
  pattern = {
    'lua',
    'javascript',
    'typescript',
    'javascriptreact',
    'typescriptreact',
    'css',
    'html',
    'json',
    'jsonc',
    'yaml',
  },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Special handling for Go (no expandtab)
vim.api.nvim_create_autocmd('FileType', {
  group = indent_group,
  pattern = 'go',
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

-- Enable wrap for specific filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = indent_group,
  pattern = { 'lua', 'cs' },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

-- Treesitter start
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    -- Enable treesitter highlighting and disable regex syntax
    pcall(vim.treesitter.start)
    -- -- Enable treesitter-based indentation
    -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- LSP Attach Autocommand
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Keymaps
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', function()
      -- Some servers (e.g. tsc) only return whole-file source actions like
      -- organize/sort/remove-unused-imports and fixAll when explicitly asked
      -- via context.only. Only opt into that filter on buffers where a server
      -- actually advertises 'source' kinds, so every other filetype keeps
      -- today's fully unfiltered request (which also surfaces actions with
      -- no `kind` at all). Note: tsc double-emits source.* actions if '' is
      -- included in `only`, so leave that out here.
      local has_source_kind = false
      for _, c in ipairs(vim.lsp.get_clients { bufnr = event.buf }) do
        local kinds = vim.tbl_get(c.server_capabilities, 'codeActionProvider', 'codeActionKinds') or {}
        for _, k in ipairs(kinds) do
          if k == 'source' or vim.startswith(k, 'source.') then
            has_source_kind = true
            break
          end
        end
        if has_source_kind then
          break
        end
      end

      if has_source_kind then
        vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
      else
        vim.lsp.buf.code_action()
      end
    end, 'Code [A]ction', { 'n', 'x' })
    map('grl', vim.lsp.codelens.run, 'Run Code [L]ens')
    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]edefinition')
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
    map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
    map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

    -- Document Highlight
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
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
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = false }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = highlight_augroup, buffer = event2.buf }
        end,
      })
    end

    -- Inlay Hints
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end

    -- Code Lens
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
      vim.lsp.codelens.enable(true, { bufnr = event.buf })
      map('<leader>tl', function()
        vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled { bufnr = event.buf }, { bufnr = event.buf })
      end, '[T]oggle Code [L]ens')

      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
        buffer = event.buf,
        callback = function()
          vim.lsp.codelens.enable(true, { bufnr = event.buf })
        end,
      })
    end
  end,
})
