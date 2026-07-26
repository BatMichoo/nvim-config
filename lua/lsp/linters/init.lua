local M = {}
local loader = require 'utils.loader'

function M.get()
  local installed = {}
  loader.scan('lsp/linters', function(_, config)
    local name = config.mason or config.linter
    if name and not vim.tbl_contains(installed, name) then
      table.insert(installed, name)
    end
  end)
  return installed
end

function M.get_by_filetype()
  local by_ft = {}
  loader.scan('lsp/linters', function(_, config)
    for _, ft in ipairs(config.filetypes or {}) do
      by_ft[ft] = by_ft[ft] or {}
      if not vim.tbl_contains(by_ft[ft], config.linter) then
        table.insert(by_ft[ft], config.linter)
      end
    end
  end)
  return by_ft
end

M.load = M.get

return M
