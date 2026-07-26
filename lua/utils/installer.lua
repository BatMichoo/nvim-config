local M = {}

--- Collects all tool requirements across LSPs, linters, formatters, and debugging tools,
--- and initializes mason-tool-installer.
function M.setup()
  local servers = require('lsp.servers').get()
  local linters = require('lsp.linters').get()
  local formatters = require('lsp.formatters').get()
  local debuggers = require('debugging').get()

  local ensure_installed = vim.tbl_keys(servers)
  vim.list_extend(ensure_installed, linters)
  vim.list_extend(ensure_installed, formatters)
  vim.list_extend(ensure_installed, debuggers)
  table.insert(ensure_installed, 'roslyn')

  require('mason-tool-installer').setup { ensure_installed = ensure_installed }
end

return M
