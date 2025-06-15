return {
  'git@github.com:brenoprata10/nvim-highlight-colors',
  -- You can add dependencies if needed, e.g., on a specific treesitter parser
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    vim.opt.termguicolors = true

    require('nvim-highlight-colors').setup {
      render = 'virtual',
      virtual_symbol = '●',
      enable_rgb = true, -- Highlight rgb() colors
      enable_hex = true, -- Highlight #RRGGBB colors
      enable_var = true, -- Highlight CSS variables (e.g., var(--my-color))
      enable_alpha = true, -- Handle alpha values
      custom_file_types = { -- Filetypes where the plugin should be active
        'css',
        'scss',
        'html',
        'jsx',
        'tsx',
        'vue',
        'go',
        'lua',
      },
    }
  end,
}
