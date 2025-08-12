return {
  'uga-rosa/ccc.nvim',
  cmd = { 'CccPick', 'CccConvert', 'CccHighlighterEnable', 'CccHighlighterDisable' },

  keys = {
    { '<leader>cp', '<cmd>CccPick<cr>', desc = 'Color Picker' },
  },

  -- Configuration for ccc.nvim
  config = function()
    require('ccc').setup {
      picker = {
        floating_window = true, -- Default: true. Set to false if you prefer it in a split.
        border = 'rounded', -- Default: 'single'. Can be 'double', 'rounded', or 'none'.
        padding = { 2, 4, 2, 4 }, -- top, right, bottom, left
      },
      win_opts = {
        row = 13,
        border = 'rounded',
      },
      -- Optional: Choose which color formats you want to see/use
      -- The first format in the list is usually the default for output.
      formats = {
        'rgb',
        'hsl',
        'hex',
        'name',
        -- 'cmyk', 'hwb', 'lab', 'lch', 'srgb', 'oklab', 'oklch',
      },
      -- Optional: Custom names for colors (e.g., your theme's named colors)
      -- custom_names = {
      --   'Normal', 'Statement', 'Comment',
      --   -- You could add your vscode_modern theme's specific named colors here
      -- },
    }
  end,
}
