local M = {}
local utils = require 'utils'

--- Scans a lua directory, requires each module, evaluates OS constraints, and invokes a handler.
---@param dir string Directory path relative to lua/ (e.g. 'lsp/servers', 'theme/highlights')
---@param handler fun(mod_name: string, content: any) Callback for each enabled module
function M.scan(dir, handler)
  local pattern = string.format('lua/%s/*.lua', dir)
  local prefix = dir:gsub('/', '.') .. '.'
  local files = vim.api.nvim_get_runtime_file(pattern, true)

  for _, file in ipairs(files) do
    local mod_name = file:match '([^/\\]+)%.lua$'
    if mod_name and mod_name ~= 'init' then
      local ok, res = pcall(require, prefix .. mod_name)
      if ok then
        -- Handle OS constraints
        local is_enabled = true
        if type(res) == 'table' and res.os then
          local os_target = res.os
          if os_target == 'all' then
            is_enabled = true
          elseif os_target == 'linux' and not utils.is_linux then
            is_enabled = false
          elseif os_target == 'windows' and not utils.is_windows then
            is_enabled = false
          elseif type(os_target) == 'function' and not os_target() then
            is_enabled = false
          end
        end

        if is_enabled then
          handler(mod_name, res)
        end
      end
    end
  end
end

return M
