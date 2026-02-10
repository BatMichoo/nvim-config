-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    'leoluz/nvim-dap-go', -- GO
    'BatMichoo/nvim-dap-cs', -- C#
    -- 'mxsdev/nvim-dap-vscode-js',
    -- {
    --   'microsoft/vscode-js-debug',
    --   build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
    -- },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dap.listeners.before.attach.dapui_config = function()
      vim.cmd 'Neotree close'
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      vim.cmd 'Neotree close'
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      vim.cmd 'Neotree toggle'
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      vim.cmd 'Neotree toggle'
      dapui.close()
    end

    if vim.fn.has 'win32' == 0 then
      require('dap-go').setup {}
    end
    require('dap-cs').setup {}

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = '127.0.0.1',
      port = '${port}', -- Neovim will find an available port
      executable = {
        command = 'node',
        args = {
          -- Use the absolute path you verified
          [[C:\Users\curti\AppData\Local\nvim-data\lazy\vscode-js-debug\dist\src\vsDebugServer.js]],
          '${port}', -- This tells the JS server which port to listen on
        },
      },
    }
    dap.adapters['pwa-chrome'] = {
      type = 'server',
      host = '127.0.0.1',
      port = '${port}', -- Neovim will find an available port
      executable = {
        command = 'node',
        args = {
          -- Use the absolute path you verified
          [[C:\Users\curti\AppData\Local\nvim-data\lazy\vscode-js-debug\dist\src\vsDebugServer.js]],
          '${port}', -- This tells the JS server which port to listen on
        },
      },
    }

    -- Configure for different JS/TS scenarios
    for _, language in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' } do
      dap.configurations[language] = {
        -- Debug single Node.js file
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
          args = {
            -- Use double brackets [[ ]] to handle Windows backslashes correctly in Lua
            [[C:\Users\curti\AppData\Local\nvim-data\lazy\vscode-js-debug\dist\src\vsDebugServer.js]],
            '${port}',
          },
        },

        -- Debug Node.js process
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
          args = {
            -- Use double brackets [[ ]] to handle Windows backslashes correctly in Lua
            [[C:\Users\curti\AppData\Local\nvim-data\lazy\vscode-js-debug\dist\src\vsDebugServer.js]],
            '${port}',
          },
        },

        -- Debug Jest tests
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Jest Tests',
          runtimeExecutable = 'node',
          runtimeArgs = {
            './node_modules/jest/bin/jest.js',
            '--runInBand',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          args = {
            -- Use double brackets [[ ]] to handle Windows backslashes correctly in Lua
            [[C:\Users\curti\AppData\Local\nvim-data\lazy\vscode-js-debug\dist\src\vsDebugServer.js]],
            '${port}',
          },
        },

        -- Debug Vite/React app
        {
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Launch Chrome (Vite)',
          url = 'http://localhost:5173',
          webRoot = '${workspaceFolder}',
          sourceMaps = true,
          protocol = 'inspector',
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },

        -- Debug Next.js
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Next.js: debug server-side',
          runtimeExecutable = 'npm',
          runtimeArgs = { 'run', 'dev' },
          skipFiles = { '<node_internals>/**' },
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach Main (Electron)',
          port = 5858,
          cwd = '${workspaceFolder}',
          args = {
            -- Use double brackets [[ ]] to handle Windows backslashes correctly in Lua
            [[C:\Users\curti\AppData\Local\nvim-data\lazy\vscode-js-debug\dist\src\vsDebugServer.js]],
            '${port}',
          },
        },
        {
          type = 'pwa-chrome',
          request = 'attach',
          name = 'Attach Renderer (Vite)',
          port = 9223,
          webRoot = '${workspaceFolder}',
          -- This is critical for Vite aliases (@irdashies) to map correctly in the debugger
          sourceMapPathOverrides = {
            ['vfs://*'] = '*',
            ['webpack:///./~/*'] = '${workspaceFolder}/node_modules/*',
            ['@irdashies/*'] = '${workspaceFolder}/src/*',
          },
          -- args = {
          --   -- Use double brackets [[ ]] to handle Windows backslashes correctly in Lua
          --   [[C:\Users\curti\AppData\Local\nvim-data\lazy\vscode-js-debug\dist\src\vsDebugServer.js]],
          --   '${port}',
          -- },
        },
      }
    end

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      expand_lines = true,
      controls = {
        enabled = false,
        icons = {
          pause = '⏸️',
          play = '▶️',
          step_into = '⬇️',
          step_over = '⤵️',
          step_out = '⤴️',
          step_back = '◀️',
          run_last = '🔂',
          terminate = '⏹️',
          disconnect = '⏏️',
        },
      }, -- no extra play/step buttons
      floating = { border = 'rounded' },
      -- Set dapui window
      render = {
        max_type_length = 60,
        max_value_lines = 200,
      },
      -- Only one layout: just the "scopes" (variables) list at the bottom
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.7 }, -- 100% of this panel is scopes
            { id = 'repl', size = 0.3 },
          },
          size = 10, -- height in lines (adjust to taste)
          position = 'bottom', -- "left", "right", "top", "bottom"
        },
      },
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end
  end,
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<F4>',
      function()
        require('dapui').eval()
      end,
      desc = 'Debug: Close Windows',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint condition',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
    {
      '<leader>dt',
      "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
      noremap = true,
      silent = true,
      desc = 'Debug: Nearest Unit Test',
    },
    {
      '<leader>da',
      "<Cmd>lua require('neotest').run.run({strategy = 'dap', suite = true})<CR>",
      noremap = true,
      silent = true,
      desc = 'Debug: All Unit Tests',
    },
  },
}
