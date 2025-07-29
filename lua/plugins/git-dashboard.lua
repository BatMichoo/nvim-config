return {
  'juansalvatore/git-dashboard-nvim',
  -- url = 'git@github.com:juansalvatore/git-dashboard-nvim.git',
  dependencies = {
    'nvim-telescope/telescope.nvim', -- For searching/opening repos (recommended)
  },
  opts = {
    centered = true,
    title = 'owner_with_repo_name',
    filled_squares = { '', '', '', '', '', '' },
    empty_square = '',
  },
}
