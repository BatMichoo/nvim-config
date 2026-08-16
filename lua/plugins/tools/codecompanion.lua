local gemini_acp_config = function()
  return require('codecompanion.adapters').extend('gemini_cli', {})
end

local gemini_http_config = function()
  local creds_file = vim.fn.expand '~/.gemini/oauth_creds.json'
  local token = nil
  if vim.fn.filereadable(creds_file) == 1 then
    local content = vim.fn.readfile(creds_file)
    local ok, creds = pcall(vim.fn.json_decode, table.concat(content, ''))
    if ok and creds and creds.access_token then
      token = creds.access_token
    end
  end

  return require('codecompanion.adapters').extend('gemini', {
    schema = {
      model = {
        default = 'gemini-3-flash',
      },
    },
  })
end

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    { 'folke/edgy.nvim', optional = true },
  },
  keys = {
    -- Inline prompting command
    { '<leader>ci', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion Inline Prompt', silent = true },
    -- Quick action palette (refactor, explain, etc.)
    { '<leader>ca', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion Actions', silent = true },
    -- Dedicated chat buffer
    { '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion Chat', silent = true },
    -- Agentic Workflow
    -- { '<leader>cg', '<cmd>CodeCompanion /Agent<cr>', mode = 'n', desc = 'CodeCompanion Agent Workflow', silent = true },
    -- CLI interaction
    { '<leader>ct', '<cmd>CodeCompanionCLI agent=claude_code<cr>', mode = 'n', desc = 'CodeCompanion CLI', silent = true },
    -- CLI prompt diagnostics
    { '<leader>cpde', '<cmd>CodeCompanionCLI! Explain #{diagnostics}<cr>', mode = 'n', desc = 'CodeCompanion Prompt Diagnostics (Explain)', silent = true },
    { '<leader>cpdf', '<cmd>CodeCompanionCLI! Fix #{diagnostics}<cr>', mode = 'n', desc = 'CodeCompanion Prompt Diagnostics (Fix)', silent = true },
    -- CLI prompt diff
    { '<leader>cprv', '<cmd>CodeCompanionCLI! Review #{diff}<cr>', mode = 'n', desc = 'CodeCompanion Prompt Diff (Review)', silent = true },
    { '<leader>cppr', '<cmd>CodeCompanionCLI! Create a PR for #{diff} using the gh CLI<cr>', mode = 'n', desc = 'CodeCompanion Prompt Diff (Create PR)', silent = true },
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
      inline = {
        adapter = 'gemini',
      },
      chat = {
        adapter = 'claude_code',
      },
      agent = {
        adapter = 'gemini_cli',
      },
      cli = {
        agent = 'gemini_cli',
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
          reload = true,
        },
      },
      -- cli = {
      --   agent = 'gemini_cli',
      --   agents = {
      --     gemini_cli = {
      --       cmd = 'gemini',
      --       args = {},
      --       description = 'Gemini CLI',
      --       provider = 'terminal',
      --     },
      --   },
      --   opts = {
      --     auto_insert = true,
      --     reload = true,
      --   },
      -- },
    },
    rules = {
      default = {
        description = 'Strict AI behavior rules based on user instructions and project guidelines',
        files = {
          '~/.config/nvim/ai_rules.md',
          {
            path = vim.fn.getcwd(),
            files = {
              'AGENT.md',
              'AGENTS.md',
              '.rules',
              '.cursorrules',
              '.clinerules',
              '.windsurfrules',
            },
          },
        },
        is_preset = true,
      },
      opts = {
        chat = {
          autoload = 'default',
          enabled = true,
        },
        inline = {
          autoload = 'default',
          enabled = true,
        },
        cli = {
          autoload = 'default',
          enabled = true,
        },
        agent = {
          autoload = 'default',
          enabled = true,
        },
      },
    },
    display = {
      chat = {
        show_settings = false,
        render_headers = false,
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
