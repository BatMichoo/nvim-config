return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  init = function()
    local ensure_installed = {
      'bash',
      'c',
      'c_sharp',
      'go',
      'diff',
      'html',
      'javascript',
      'typescript',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'yaml',
      'json',
      'json5',
    }

    local alreadyInstalled = require('nvim-treesitter.config').get_installed()
    local parsersToInstall = vim
      .iter(ensure_installed)
      :filter(function(parser)
        return not vim.tbl_contains(alreadyInstalled, parser)
      end)
      :totable()
    require('nvim-treesitter').install(parsersToInstall)

    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        -- Enable treesitter highlighting and disable regex syntax
        pcall(vim.treesitter.start)
        -- -- Enable treesitter-based indentation
        -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
