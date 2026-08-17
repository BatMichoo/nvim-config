local M = {}
local loader = require 'utils.loader'

function M.get()
  local adapters = {}
  loader.scan('testing', function(_, config)
    local adapter = config.adapter
    if type(adapter) == 'function' then
      table.insert(adapters, adapter())
    elseif type(adapter) == 'table' then
      table.insert(adapters, adapter)
    end
  end)
  return adapters
end

return M
