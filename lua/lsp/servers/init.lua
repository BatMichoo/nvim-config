local M = {}

function M.get()
  local utils = require 'utils'
  local servers = {}

  -- Discover all .lua files in lua/lsp/servers/
  local files = vim.api.nvim_get_runtime_file('lua/lsp/servers/*.lua', true)

  for _, file in ipairs(files) do
    local mod_name = file:match '([^/]+)%.lua$'
    if mod_name and mod_name ~= 'init' then
      local ok, config_fn = pcall(require, 'lsp.servers.' .. mod_name)
      if ok and type(config_fn) == 'table' then
        local config = vim.deepcopy(config_fn)

        -- Evaluate OS constraint
        local os_target = config.os or 'all'
        local is_enabled = false

        if os_target == 'all' then
          is_enabled = true
        elseif os_target == 'linux' and utils.is_linux then
          is_enabled = true
        elseif os_target == 'windows' and utils.is_windows then
          is_enabled = true
        elseif type(os_target) == 'function' then
          is_enabled = os_target()
        end

        if is_enabled then
          local server_name = config.name or mod_name
          config.name = nil
          config.os = nil
          servers[server_name] = config
        end
      end
    end
  end

  return servers
end

M.load = M.get

return M
