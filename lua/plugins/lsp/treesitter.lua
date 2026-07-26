return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  lazy = false,
  config = function()
    local install = require 'nvim-treesitter.install'
    install.install {
      'bash',
      'c',
      'c_sharp',
      'go',
      'diff',
      'html',
      'css',
      'javascript',
      'jsx',
      'typescript',
      'tsx',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'yaml',
      'xml',
      'json',
      'json5',
    }
  end,
}
