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

    -- Configure lazygit for dotfiles bare repo if we are inside $HOME and NOT in another git repo
    local isLinux = require('utils').is_linux
    if isLinux then
      local cwd = vim.fn.getcwd()
      local home = vim.fn.expand '$HOME'
      if string.find(cwd, home, 1, true) == 1 then
        vim.fn.system 'git rev-parse --is-inside-work-tree 2>/dev/null'
        if vim.v.shell_error ~= 0 then
          vim.fn.setenv('GIT_DIR', home .. '/.dotfiles')
          vim.fn.setenv('GIT_WORK_TREE', home)
        end
      end
    end
  end,
  keys = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },
}
