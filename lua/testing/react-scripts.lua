-- Create React App's `react-scripts test` wraps Jest but doesn't declare a
-- literal `jest` dependency, so neotest-jest's default detection misses it.
-- This checks for `react-scripts` instead, so it only claims real CRA
-- projects and doesn't overlap with the plain Jest adapter.
local function has_dependency(file_path, name)
  local lib = require 'neotest.lib'
  local root = lib.files.match_root_pattern 'package.json' (file_path)
  if not root then
    return false
  end

  local ok, content = pcall(lib.files.read, root .. '/package.json')
  if not ok then
    return false
  end

  local decode_ok, pkg = pcall(vim.json.decode, content)
  if not decode_ok then
    return false
  end

  return (pkg.dependencies and pkg.dependencies[name] ~= nil) or (pkg.devDependencies and pkg.devDependencies[name] ~= nil)
end

return {
  adapter = function()
    return require 'neotest-jest' {
      jestCommand = 'npm test --',
      env = { CI = true },
      cwd = function()
        return vim.fn.getcwd()
      end,
      isTestFile = function(file_path)
        if not file_path then
          return false
        end
        local matches_name = file_path:match '%.test%.[jt]sx?$' or file_path:match '%.spec%.[jt]sx?$'
        return matches_name ~= nil and has_dependency(file_path, 'react-scripts')
      end,
    }
  end,
}
