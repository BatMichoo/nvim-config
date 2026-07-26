return {
  'mason-org/mason.nvim',
  opts = {
    registries = {
      'github:mason-org/mason-registry',
      'github:Crashdummyy/mason-registry',
    },
  },
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function(_, opts)
    require('mason').setup(opts)
    require('utils.installer').setup()
  end,
}
