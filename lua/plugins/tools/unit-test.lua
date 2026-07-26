return {
  'nvim-neotest/neotest',
  config = function()
    require('neotest').setup {
      adapters = require('testing').get(),
    }
  end,
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'fredrikaverpil/neotest-golang',
    'Issafalcon/neotest-dotnet',
    'marilari88/neotest-vitest',
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
