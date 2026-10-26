-- Gemini CLI over ACP. Needs `gemini` on PATH; signs in with the Google account
-- from `gemini` itself (oauth-personal), so no API key is required here.
local gemini_acp_config = function()
  return require('codecompanion.adapters').extend('gemini_cli', {
    defaults = {
      auth_method = 'oauth-personal',
    },
  })
end

-- Gemini HTTP (Interactions API). Authenticates with GEMINI_API_KEY only; the
-- Gemini CLI's OAuth token cannot be used against this endpoint.
local gemini_http_config = function()
  return require('codecompanion.adapters').extend('gemini', {
    env = {
      api_key = 'GEMINI_API_KEY',
    },
    schema = {
      model = {
        default = 'gemini-3.5-flash',
      },
    },
  })
end

-- Toggle focus between the last CLI split and the previous window
local jump_to_cli = function()
  local cli = require('codecompanion.interactions.cli').last_cli()
  if not cli then
    return vim.notify('No CodeCompanion CLI is running', vim.log.levels.WARN)
  end
  if vim.api.nvim_get_current_buf() == cli.bufnr then
    return vim.cmd.wincmd 'p'
  end
  cli.ui:open()
  cli:focus()
end

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    { 'folke/edgy.nvim', optional = true },
  },
  -- Lets commands (e.g. from the Alpha dashboard) load the plugin, not just keymaps
  cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions', 'CodeCompanionCLI', 'CodeCompanionCmd' },
  init = function()
    -- Needs the Claude Code hooks from `:CodeCompanionCLI Install`
    vim.api.nvim_create_autocmd('User', {
      pattern = 'CodeCompanionCLIApprovalRequested',
      group = vim.api.nvim_create_augroup('codecompanion-cli-approval', { clear = true }),
      callback = function(args)
        local message = (args.data and args.data.message) or 'Waiting for you'
        vim.notify(message .. ' (<leader>cj to answer)', vim.log.levels.WARN, { title = 'Claude Code' })
      end,
    })
    -- Jump back out of the CLI without leaving terminal mode first
    vim.api.nvim_create_autocmd('User', {
      pattern = 'CodeCompanionCLICreated',
      group = vim.api.nvim_create_augroup('codecompanion-cli-keymaps', { clear = true }),
      callback = function(args)
        vim.keymap.set('t', '<C-q>', '<C-\\><C-n><C-w>p', { buffer = args.data.bufnr, desc = 'Back to previous window' })
      end,
    })
  end,
  keys = {
    -- Inline prompting command
    { '<leader>ci', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion Inline Prompt', silent = true },
    -- Quick action palette (refactor, explain, etc.)
    { '<leader>ca', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion Actions', silent = true },
    -- Dedicated chat buffer
    { '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion Chat', silent = true },
    -- Resume a saved chat session
    {
      '<leader>cs',
      function()
        require('codecompanion').sessions()
      end,
      mode = 'n',
      desc = 'CodeCompanion Sessions',
      silent = true,
    },
    -- Agentic Workflow
    -- { '<leader>cg', '<cmd>CodeCompanion /Agent<cr>', mode = 'n', desc = 'CodeCompanion Agent Workflow', silent = true },
    -- CLI interaction
    { '<leader>ct', '<cmd>CodeCompanionCLI agent=claude_code<cr>', mode = 'n', desc = 'CodeCompanion CLI', silent = true },
    { '<leader>cj', jump_to_cli, mode = 'n', desc = 'CodeCompanion CLI (Jump)', silent = true },
    -- CLI prompt diagnostics
    { '<leader>cpde', '<cmd>CodeCompanionCLI! Explain #{diagnostics}<cr>', mode = 'n', desc = 'CodeCompanion Prompt Diagnostics (Explain)', silent = true },
    { '<leader>cpdf', '<cmd>CodeCompanionCLI! Fix #{diagnostics}<cr>', mode = 'n', desc = 'CodeCompanion Prompt Diagnostics (Fix)', silent = true },
    -- CLI prompt diff
    { '<leader>cprv', '<cmd>CodeCompanionCLI! Review #{diff}<cr>', mode = 'n', desc = 'CodeCompanion Prompt Diff (Review)', silent = true },
    {
      '<leader>cppr',
      '<cmd>CodeCompanionCLI! Create a PR for #{diff} using the gh CLI<cr>',
      mode = 'n',
      desc = 'CodeCompanion Prompt Diff (Create PR)',
      silent = true,
    },
    -- CLI prompt buffer
    { '<leader>cpbe', '<cmd>CodeCompanionCLI! Explain #{buffer}<cr>', mode = 'n', desc = 'CodeCompanion Prompt Buffer (Explain)', silent = true },
    { '<leader>cpbt', '<cmd>CodeCompanionCLI! Write tests for #{buffer}<cr>', mode = 'n', desc = 'CodeCompanion Prompt Buffer (Test)', silent = true },
  },
  opts = {
    adapters = {
      http = {
        gemini = gemini_http_config,
      },
      acp = {
        gemini_cli = gemini_acp_config,
      },
    },
    interactions = {
      opts = {
        -- Reload buffers when an agent modifies files on disk
        watcher = {
          enabled = true,
        },
      },
      chat = {
        adapter = 'gemini',
        sessions = {
          enabled = true,
          autosave = true,
        },
        tools = {
          ['run_command'] = {
            opts = {
              judge = true,
            },
          },
          opts = {
            -- Auto mode: the background judge only asks when a tool call looks unsafe
            approval_mode = 'auto',
          },
        },
      },
      inline = {
        adapter = 'gemini',
      },
      cmd = {
        adapter = 'gemini',
      },
      -- Chat titles and the tool judge run on a cheaper model than chat
      background = {
        adapter = {
          name = 'gemini',
          model = 'gemini-3.1-flash-lite-preview',
        },
        chat = {
          opts = {
            enabled = true,
          },
        },
      },
      cli = {
        agent = 'claude_code',
        agents = {
          gemini_cli = {
            cmd = 'agy',
            args = {},
            description = 'Antigravity CLI',
            provider = 'terminal',
          },
          claude_code = {
            cmd = 'claude',
            args = {},
            description = 'Claude Code CLI',
            provider = 'terminal',
          },
        },
        opts = {
          auto_insert = true,
        },
      },
    },
    rules = {
      -- The built-in `default` preset covers AGENTS.md, CLAUDE.md, .cursorrules etc.
      -- relative to the current cwd; this adds the personal rules on top.
      personal = {
        description = 'Strict AI behavior rules based on user instructions',
        files = {
          '~/.config/nvim/ai_rules.md',
        },
      },
      opts = {
        chat = {
          autoload = { 'default', 'personal' },
          enabled = true,
        },
        inline = {
          autoload = { 'default', 'personal' },
        },
      },
    },
    prompt_library = {
      markdown = {
        dirs = {
          vim.fn.stdpath 'config' .. '/prompts',
        },
      },
    },
    display = {
      chat = {
        show_settings = false,
      },
      cli = {
        window = {
          layout = 'vertical',
          width = 0.35,
        },
      },
    },
  },
}
