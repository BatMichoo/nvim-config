local M = {}
local loader = require 'utils.loader'

function M.get()
  local servers = {}
  loader.scan('lsp/servers', function(mod_name, config)
    local cfg = vim.deepcopy(config)
    local name = cfg.name or mod_name
    cfg.name = nil
    cfg.os = nil
    servers[name] = cfg
  end)
  return servers
end

M.load = M.get

return M
