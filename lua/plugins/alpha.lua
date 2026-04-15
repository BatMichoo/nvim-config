return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'juansalvatore/git-dashboard-nvim',
  },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'
    local git_dashboard = require('git-dashboard-nvim').setup {}

    local git_heatmap_content = {}
    local first_content_line = 1
    local last_content_line = #git_dashboard

    -- Find the first non-empty line
    for i = 1, #git_dashboard do
      if #git_dashboard[i]:gsub('%s', '') > 0 then -- Check if line contains non-whitespace chars
        first_content_line = i
        break
      end
    end

    -- Find the last non-empty line
    for i = #git_dashboard, 1, -1 do
      if #git_dashboard[i]:gsub('%s', '') > 0 then
        last_content_line = i
        break
      end
    end

    -- Populate git_heatmap_content with only the relevant lines
    for i = first_content_line, last_content_line do
      table.insert(git_heatmap_content, git_dashboard[i])
    end

    dashboard.section.header.val = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button('s', '🛠️  Settings', ":lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath 'config' })<CR>"),
      dashboard.button('c', '🤖  CodeCompanion', ':CodeCompanionCLI<CR>'),
      dashboard.button('b', '📁  DB', ':DBUI<CR>'),
      dashboard.button('v', '🎮  VimBeGood', ':VimBeGood<CR>'),
      dashboard.button('g', '   LazyGit', ':LazyGit<CR>'),
      dashboard.button('L', '💤  Lazy', ':Lazy<CR>'),
      dashboard.button('M', '📦  Mason', ':Mason<CR>'),
      dashboard.button('q', '🛑  Quit', ':q<CR>'),
    }

    dashboard.section.git = {
      type = 'text',
      val = git_heatmap_content,
      opts = {
        margin = 1,
        title = 'Git',
        position = 'center',
        hl = 'Type',
      },
    }

    dashboard.opts.layout = {
      dashboard.section.header, -- Your custom ASCII art
      { type = 'padding', val = 2 },
      dashboard.section.buttons, -- Your buttons
      { type = 'padding', val = 2 },
      dashboard.section.git, -- The Git heatmap
      { type = 'padding', val = 2 },
      dashboard.section.footer, -- The default footer (or define your own)
    }
    alpha.setup(dashboard.opts)
  end,
}
