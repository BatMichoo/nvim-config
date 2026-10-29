-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<leader>Nt', ':Neotree toggle<CR>', desc = 'NeoTree toggle', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        always_show_by_pattern = {
          '.env*',
        },
      },
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer
        leave_dirs_open = false, -- Close folders that aren't part of the path
      },
      window = {
        mappings = {
          ['A'] = 'easy_dotnet_new',
        },
      },
      commands = {
        -- Pick a C# item (class, interface, record, enum) to create in the node's directory.
        easy_dotnet_new = function(state)
          local node = state.tree:get_node()
          local path = node.type == 'directory' and node.path or vim.fs.dirname(node.path)
          require('easy-dotnet').create_item(path)
        end,
      },
    },
  },
}
