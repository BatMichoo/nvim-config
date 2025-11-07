return {
  'GustavEikaas/easy-dotnet.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    require('easy-dotnet').setup {
      debugger = {
        mappings = {},
        bin_path = 'netcoredbg',
        auto_register_dap = false,
      },
      lsp = {
        enabled = false,
      },
      test_runner = {
        enable_buffer_test_execution = false,
      },
    }
  end,
  keys = {
    -- Running & Building
    { '<leader>nt',  '<cmd>:Dotnet test default<CR>',            desc = 'Run Default Test' },
    { '<leader>nT',  '<cmd>:Dotnet test solution<CR>',           desc = 'Run Solution Tests' },
    { '<leader>nb',  '<cmd>:Dotnet build default<CR>',           desc = 'Build Default Project' },
    { '<leader>nB',  '<cmd>:Dotnet build solution<CR>',          desc = 'Build Solution' },
    { '<leader>nq',  '<cmd>:Dotnet build default quickfix<CR>',  desc = 'Build Default to Quickfix' },
    { '<leader>nQ',  '<cmd>:Dotnet build solution quickfix<CR>', desc = 'Build Solution to Quickfix' },
    { '<leader>nr',  '<cmd>:Dotnet run default<CR>',             desc = 'Run Default Project' },
    { '<leader>nw',  '<cmd>:Dotnet watch default<CR>',           desc = 'Watch Default Project' },

    -- Project & Diagnostics
    { '<leader>nd',  '<cmd>:Dotnet diagnostic<CR>',              desc = 'View Diagnostics' },
    { '<leader>ne',  '<cmd>:Dotnet diagnostic errors<CR>',       desc = 'View Errors' },
    { '<leader>nO',  '<cmd>:Dotnet outdated<CR>',                desc = 'Check Outdated Packages' },
    { '<leader>ns',  '<cmd>:Dotnet solution select<CR>',         desc = 'Select/Change Solution' },
    { '<leader>nn',  '<cmd>:Dotnet new<CR>',                     desc = 'New Project/Item' },
    { '<leader>nc',  '<cmd>:Dotnet createfile<CR>',              desc = 'Create File Picker' },

    -- Package Management
    { '<leader>npa', '<cmd>:Dotnet add package<CR>',             desc = 'Add NuGet Package' },
    { '<leader>npr', '<cmd>:Dotnet remove package<CR>',          desc = 'Remove NuGet Package' },
    { '<leader>nv',  '<cmd>:Dotnet project view<CR>',            desc = 'View Project' },

    -- EF Core
    { '<leader>mu',  '<cmd>:Dotnet ef database update pick<CR>', desc = 'EF DB Update (Pick Target)' },
    { '<leader>md',  '<cmd>:Dotnet ef database drop<CR>',        desc = 'EF DB Drop' },
    { '<leader>ma',  '<cmd>:Dotnet ef migrations add<CR>',       desc = 'EF Migrations Add' },
    { '<leader>ml',  '<cmd>:Dotnet ef migrations list<CR>',      desc = 'EF Migrations List' },
  },
}
