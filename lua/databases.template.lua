local M = {}

local servers = {
  -- local_dev = 'localhost',
}

local definitions = {
  -- {
  --   name = '',
  --   scheme = '', -- sql/postgres ...
  --   port = 5433,
  --   servers = { 'local_dev' },
  --   auth = {
  --     user = '',
  --     password = '',
  --     sslmode = 'disable',
  --   },
  --   db = '',
  -- },
}

M.servers = servers
M.definitions = definitions

return M
