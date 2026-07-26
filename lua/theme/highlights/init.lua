local M = {}
local loader = require 'utils.loader'

function M.apply()
  local palette = require 'theme.palette'
  loader.scan('theme/highlights', function(_, setup_fn)
    if type(setup_fn) == 'function' then
      setup_fn(palette)
    end
  end)
end

return M
