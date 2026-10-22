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
    -- formatter may be a list, run in order
    local names = type(config.formatter) == 'table' and config.formatter or { config.formatter }
    for _, ft in ipairs(config.filetypes or {}) do
      by_ft[ft] = by_ft[ft] or {}
      for _, name in ipairs(names) do
        if not vim.tbl_contains(by_ft[ft], name) then
          table.insert(by_ft[ft], name)
        end
      end
    end
  end)
  return by_ft
end

function M.get_definitions()
  local defs = {}
  loader.scan('lsp/formatters', function(_, config)
    for name, def in pairs(config.definitions or {}) do
      defs[name] = def
    end
  end)
  return defs
end

M.load = M.get

return M
