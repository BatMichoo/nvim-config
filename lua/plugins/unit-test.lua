return {
  'nvim-neotest/neotest',
  commit = '52fca6717ef972113ddd6ca223e30ad0abb2800c',
  requires = {
    {
      'Issafalcon/neotest-dotnet',
    },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-dotnet',
      },
    }
  end,
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
}
