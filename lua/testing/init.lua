local M = {}
local loader = require 'utils.loader'

function M.get()
  local adapters = {}
  loader.scan('testing', function(_, config)
    if type(config) == 'function' then
      table.insert(adapters, config())
    elseif type(config) == 'table' then
      table.insert(adapters, config)
    end
  end)
  return adapters
end

return M
