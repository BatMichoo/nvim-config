local M = {}
local loader = require 'utils.loader'

function M.get()
  local installed = {}
  loader.scan('debugging', function(_, config)
    local name = type(config) == 'table' and (config.mason or config.debugger) or config
    if name and not vim.tbl_contains(installed, name) then
      table.insert(installed, name)
    end
  end)
  return installed
end

return M
