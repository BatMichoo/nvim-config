return {
  'nvim-neotest/neotest',
  config = function()
    require('neotest').setup {
      adapters = require('testing').get(),
      consumers = {
        -- The client only starts discovering on the first run/summary call,
        -- so status signs never show up before then. Start it right away.
        autostart = function(client)
          require('nio').run(function()
            client:get_adapters()
          end)
          return {}
        end,
        -- easy-dotnet's test runner draws its own signs in .cs files, and with a one-slot
        -- signcolumn neotest's would hide them. Run the stock status consumer for every
        -- other adapter only.
        status_except_dotnet = function(client)
          local listeners = setmetatable({}, {
            __newindex = function(_, event, fn)
              client.listeners[event] = function(adapter_id, ...)
                if not vim.startswith(adapter_id, 'easy-dotnet') then
                  return fn(adapter_id, ...)
                end
              end
            end,
          })
          local filtered = setmetatable({ listeners = listeners }, {
            __index = function(_, key)
              local value = client[key]
              if type(value) ~= 'function' then
                return value
              end
              return function(_, ...)
                return value(client, ...)
              end
            end,
          })
          return require 'neotest.consumers.status'(filtered)
        end,
      },
      -- Replaced by status_except_dotnet above
      status = { enabled = false },
    }
  end,
  -- Filetypes covered by the adapters in lua/testing
  ft = { 'cs', 'go', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'fredrikaverpil/neotest-golang',
    'GustavEikaas/easy-dotnet.nvim',
    'marilari88/neotest-vitest',
    'nvim-neotest/neotest-jest',
  },
  keys = {
    -- Run all tests in the current file
    {
      '<leader>tf',
      "<Cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
      silent = true,
      desc = 'Run: Current File',
    },
    -- Run the full suite (all tests)
    {
      '<leader>ta',
      "<Cmd>lua require('neotest').run.run({suite = true})<CR>",
      silent = true,
      desc = 'Run: All Tests',
    },
    -- Run the nearest test
    {
      '<leader>tn',
      "<Cmd>lua require('neotest').run.run()<CR>",
      silent = true,
      desc = 'Run: Nearest Test',
    },
    {
      '<leader>ts',
      "<Cmd>lua require('neotest').summary.toggle()<CR>",
      silent = true,
      desc = 'Summary: Toggle',
    },
    {
      '<leader>tp',
      "<Cmd>lua require('neotest').output_panel.toggle()<CR>",
      silent = true,
      desc = 'Output Panel: Toggle',
    },
  },
}
