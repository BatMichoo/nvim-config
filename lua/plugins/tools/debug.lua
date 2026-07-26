-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    'leoluz/nvim-dap-go', -- GO
    'BatMichoo/nvim-dap-cs', -- C#
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local isLinux = require('utils').is_linux

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

    if isLinux then
      require('dap-go').setup {}
    end
    require('dap-cs').setup {}

    local is_windows = require('utils').is_windows
    local mason_path = vim.fn.stdpath 'data' .. '/mason/bin/'
    local js_debug_cmd = is_windows and (mason_path .. 'js-debug-adapter.cmd') or (mason_path .. 'js-debug-adapter')

    -- Setup pwa-node & pwa-chrome DAP adapters
    for _, adapter in ipairs { 'pwa-node', 'pwa-chrome' } do
      dap.adapters[adapter] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = js_debug_cmd,
          args = { '${port}' },
        },
      }
    end

    local js_languages = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }
    for _, language in ipairs(js_languages) do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file (Node.js)',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to Node Process',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Launch Chrome (Vite / React)',
          url = function()
            local url = vim.fn.input('URL to debug: ', 'http://localhost:5173')
            return url ~= '' and url or 'http://localhost:5173'
          end,
          webRoot = '${workspaceFolder}',
          userDataDir = false,
        },
        {
          type = 'pwa-chrome',
          request = 'attach',
          name = 'Attach Chrome (Port 9222)',
          port = 9222,
          webRoot = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Electron (Main Process)',
          runtimeExecutable = is_windows and '${workspaceFolder}/node_modules/.bin/electron.cmd' or '${workspaceFolder}/node_modules/.bin/electron',
          runtimeArgs = { '.', '--remote-debugging-port=9222' },
          cwd = '${workspaceFolder}',
          protocol = 'inspector',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Electron Forge (Main Process - Vite)',
          runtimeExecutable = is_windows and '${workspaceFolder}/node_modules/.bin/electron-forge.cmd' or '${workspaceFolder}/node_modules/.bin/electron-forge',
          runtimeArgs = { 'start', '--', '--inspect-brk=9229', '--remote-debugging-port=9222' },
          cwd = '${workspaceFolder}',
          protocol = 'inspector',
          sourceMaps = true,
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/**',
          },
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach Electron (Main Process - Port 9229)',
          port = 9229,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/**',
          },
        },
        {
          type = 'pwa-chrome',
          request = 'attach',
          name = 'Attach Electron (Renderer Process - Port 9222)',
          port = 9222,
          webRoot = '${workspaceFolder}',
          timeout = 30000,
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
    -- {
    --   '<leader>da',
    --   "<Cmd>lua require('neotest').run.run({strategy = 'dap', suite = true})<CR>",
    --   noremap = true,
    --   silent = true,
    --   desc = 'Debug: All Unit Tests',
    -- },
  },
}
