return {
  'seblyng/roslyn.nvim',
  ft = { 'cs', 'cshtml', 'csproj', 'sln' },
  opts = {
    silent = true,
    -- We override only the necessary parts of the internal config
    config = {
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
          buffer = bufnr,
          callback = function()
            vim.schedule(function()
              local ok, diag = pcall(require, 'roslyn.lsp.diagnostics')
              if ok and diag.refresh then
                diag.refresh(client)
              end
            end)
          end,
        })
      end,
      root_dir = function(bufnr, cb)
        local root = vim.fs.root(bufnr, { '.sln', '.csproj' }) or vim.fn.getcwd()
        if cb then
          cb(root)
        end
        return root
      end,
    },
  },
}
