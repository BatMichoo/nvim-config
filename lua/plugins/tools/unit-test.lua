return {
  'nvim-neotest/neotest',
  -- commit = '52fca6717ef972113ddd6ca223e30ad0abb2800c',
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-dotnet' {},
        require 'neotest-golang' {},
      },
    }
  end,
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'fredrikaverpil/neotest-golang',
    'Issafalcon/neotest-dotnet',
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
