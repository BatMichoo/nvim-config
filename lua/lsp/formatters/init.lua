local M = {}

local function load_all()
  local utils = require 'utils'
  local modules = {}

  local files = vim.api.nvim_get_runtime_file('lua/lsp/formatters/*.lua', true)
  for _, file in ipairs(files) do
    local mod_name = file:match '([^/]+)%.lua$'
    if mod_name and mod_name ~= 'init' then
      local ok, config = pcall(require, 'lsp.formatters.' .. mod_name)
      if ok and type(config) == 'table' then
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
          table.insert(modules, config)
        end
      end
    end
  end

  return modules
end

function M.get()
  local installed = {}
  for _, item in ipairs(load_all()) do
    local name = item.mason or item.formatter
    if name and not vim.tbl_contains(installed, name) then
      table.insert(installed, name)
    end
  end
  return installed
end

function M.get_by_filetype()
  local by_ft = {}
  for _, item in ipairs(load_all()) do
    for _, ft in ipairs(item.filetypes or {}) do
      by_ft[ft] = by_ft[ft] or {}
      if not vim.tbl_contains(by_ft[ft], item.formatter) then
        table.insert(by_ft[ft], item.formatter)
      end
    end
  end
  return by_ft
end

M.load = M.get

return M
