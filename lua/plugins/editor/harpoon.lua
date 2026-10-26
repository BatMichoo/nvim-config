local ordinals = { '1st', '2nd', '3rd', '4th', '5th', '6th', '7th' }

local keys = {
  {
    '<leader>a',
    function()
      require('harpoon'):list():add()
    end,
    desc = '[A]dd mark',
  },
  {
    '<leader>hh',
    function()
      local harpoon = require 'harpoon'
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end,
    desc = 'Toggle quick menu',
  },
}

for i, ordinal in ipairs(ordinals) do
  table.insert(keys, {
    '<leader>' .. i,
    function()
      require('harpoon'):list():select(i)
    end,
    desc = 'To ' .. ordinal .. ' mark',
  })
end

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = keys,
  config = function()
    require('harpoon'):setup {
      settings = {
        save_on_toggle = true,
      },
    }
  end,
}
