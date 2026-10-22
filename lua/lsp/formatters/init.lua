local M = {}
local loader = require 'utils.loader'

function M.get()
  local installed = {}
  loader.scan('lsp/formatters', function(_, config)
    -- mason = false: tool ships outside Mason (e.g. with an SDK)
    local name = config.mason ~= false and (config.mason or config.formatter)
    if name and not vim.tbl_contains(installed, name) then
      table.insert(installed, name)
    end
  end)
  return installed
end

function M.get_by_filetype()
  local by_ft = {}
  loader.scan('lsp/formatters', function(_, config)
    for _, ft in ipairs(config.filetypes or {}) do
      by_ft[ft] = by_ft[ft] or {}
      if not vim.tbl_contains(by_ft[ft], config.formatter) then
        table.insert(by_ft[ft], config.formatter)
      end
    end
  end)
  return by_ft
end

function M.get_definitions()
  local defs = {}
  loader.scan('lsp/formatters', function(_, config)
    if config.definition then
      defs[config.formatter] = config.definition
    end
  end)
  return defs
end

M.load = M.get

return M
