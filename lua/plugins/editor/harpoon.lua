return {
  'ThePrimeagen/harpoon',
  -- event = "VeryLazy",
  keys = {
    {
      '<leader>a',
      function()
        require('harpoon.mark').add_file()
      end,
      desc = '[A]dd mark',
    },
    {
      '<leader>hh',
      function()
        require('harpoon.ui').toggle_quick_menu()
      end,
      desc = 'Toggle quick menu',
    },
    {
      '<leader>1',
      function()
        require('harpoon.ui').nav_file(1)
      end,
      desc = 'To 1st mark',
    },
    {
      '<leader>2',
      function()
        require('harpoon.ui').nav_file(2)
      end,
      desc = 'To 2nd mark',
    },
    {
      '<leader>3',
      function()
        require('harpoon.ui').nav_file(3)
      end,
      desc = 'To 3rd mark',
    },
    {
      '<leader>4',
      function()
        require('harpoon.ui').nav_file(4)
      end,
      desc = 'To 4th mark',
    },
    {
      '<leader>5',
      function()
        require('harpoon.ui').nav_file(5)
      end,
      desc = 'To 5th mark',
    },
    {
      '<leader>6',
      function()
        require('harpoon.ui').nav_file(6)
      end,
      desc = 'To 6th mark',
    },
    {
      '<leader>7',
      function()
        require('harpoon.ui').nav_file(7)
      end,
      desc = 'To 7th mark',
    },
  },
  opts = {
    global_settings = {
      enter_on_sendcmd = true,
    },
  },
}
