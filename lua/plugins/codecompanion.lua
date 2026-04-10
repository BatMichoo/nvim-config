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
    { '<leader>cg', '<cmd>CodeCompanion /Agent<cr>', mode = 'n', desc = 'CodeCompanion Agent Workflow', silent = true },
    -- CLI interaction
    { '<leader>ct', '<cmd>CodeCompanionCLI agent=gemini_cli<cr>', mode = 'n', desc = 'CodeCompanion CLI', silent = true },
  },
  opts = {
    adapters = {
      gemini_cli = function()
        return require('codecompanion.adapters').extend('gemini_cli', {
          env = {
            oauth_credentials_path = vim.fn.expand '~/.gemini/oauth_creds.json',
          },
        })
      end,
    },
    interactions = {
      chat = {
        adapter = 'gemini_cli',
      },
      inline = {
        adapter = 'gemini_cli',
      },
      agent = {
        adapter = 'gemini_cli',
      },
      cli = {
        agent = 'gemini_cli',
        agents = {
          gemini_cli = {
            cmd = 'gemini',
            args = {},
            description = 'Gemini CLI',
            provider = 'terminal',
          },
        },
        opts = {
          auto_insert = true,
          reload = true,
        },
      },
    },
    prompt_library = {
      ['Agent'] = {
        strategy = 'chat',
        description = 'Agentic workflow with access to tools',
        opts = {
          is_slash_cmd = true,
          short_name = 'agent',
          auto_submit = true,
          stop_context_insertion = true,
          user_prompt = false,
        },
        prompts = {
          {
            role = 'system',
            content = 'You are an expert AI agent with access to various tools. Help the user with their task by using the available tools effectively.',
            opts = {
              visible = false,
            },
          },
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
          width = 0.45,
        },
      },
    },
  },
}
