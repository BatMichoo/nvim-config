return {
  'kdheepak/lazygit.nvim',
  lazy = false,
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- optional for floating window border decoration
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('telescope').load_extension 'lazygit'

    -- Check if Neovim was opened in the home directory, and configure lazygit for dotfiles bare repo
    if vim.fn.getcwd() == vim.fn.expand("$HOME") then
      vim.fn.setenv("GIT_DIR", vim.fn.expand("$HOME/.dotfiles"))
      vim.fn.setenv("GIT_WORK_TREE", vim.fn.expand("$HOME"))
    end
  end,
  keys = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },
}
