return {
  name = 'tsc',
  cmd = function(dispatchers, config)
    -- Prefer the mason-installed native-preview binary: a project's local
    -- node_modules/.bin/tsc is usually the classic compiler, which doesn't
    -- support --lsp/--stdio and exits 1 immediately if used here.
    local mason_bin = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'bin', 'tsc')
    local cmd = vim.fn.executable(mason_bin) == 1 and mason_bin or 'tsc'
    return vim.lsp.rpc.start({ cmd, '--lsp', '--stdio' }, dispatchers)
  end,
  settings = {
    ['js/ts'] = {
      implicitProjectConfig = {
        checkJs = true,
      },
    },
    javascript = {
      implicitProjectConfig = {
        checkJs = true,
      },
    },
    typescript = {
      implicitProjectConfig = {
        checkJs = true,
      },
    },
  },
}
