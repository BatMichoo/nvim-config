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

--- Whether the debugging/<mod_name>.lua config is enabled on this OS
--- (i.e. loader.scan didn't filter it out via its `os` field).
---@param mod_name string
function M.is_enabled(mod_name)
  local found = false
  loader.scan('debugging', function(name)
    if name == mod_name then
      found = true
    end
  end)
  return found
end

return M
