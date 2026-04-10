local M = {}

M.is_windows = vim.fn.has 'win32' == 1
M.is_linux = not M.is_windows

return M
