return {
  'GustavEikaas/easy-dotnet.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  ft = { 'cs', 'csproj', 'sln' },
  config = function()
    require('easy-dotnet').setup {
      debugger = {
        auto_register_dap = true,
      },
      lsp = {
        enabled = true,
      },
      auto_bootstrap_namespace = {
        type = 'file_scoped',
        enabled = true,
      },
      test_runner = {
        -- Test-file keymaps reuse the neotest keys from unit-test.lua, so C# keeps the
        -- same muscle memory. The defaults (<leader>d, <leader>t) would shadow those prefixes.
        mappings = {
          run_test_from_buffer = { lhs = '<leader>tn', desc = 'Run: Nearest Test' },
          run_all_tests_from_buffer = { lhs = '<leader>tf', desc = 'Run: Current File' },
          debug_test_from_buffer = { lhs = '<leader>dt', desc = 'Debug: Nearest Unit Test' },
          peek_stack_trace_from_buffer = { lhs = '<leader>tp', desc = 'Peek Test Output' },
        },
      },
    }

    -- Roslyn skips buffers not yet on disk, and LSP only attaches on FileType,
    -- so a new .cs file never gets a client. Retry attaching after the first save.
    vim.api.nvim_create_autocmd('BufWritePost', {
      desc = 'Attach Roslyn to newly created .cs files',
      group = vim.api.nvim_create_augroup('easy-dotnet-new-file', { clear = true }),
      pattern = '*.cs',
      callback = function(ev)
        if #vim.lsp.get_clients { bufnr = ev.buf, name = 'easy_dotnet' } == 0 then
          vim.api.nvim_exec_autocmds('FileType', { group = 'nvim.lsp.enable', buffer = ev.buf })
        end
      end,
    })
  end,
  keys = {
    -- Running & Building
    { '<leader>nt', '<cmd>:Dotnet test default<CR>', desc = 'Run Default Test' },
    { '<leader>nT', '<cmd>:Dotnet test solution<CR>', desc = 'Run Solution Tests' },
    { '<leader>ts', '<cmd>:Dotnet testrunner<CR>', ft = 'cs', desc = 'Test Runner' },
    { '<leader>nb', '<cmd>:Dotnet build default<CR>', desc = 'Build Default Project' },
    { '<leader>nB', '<cmd>:Dotnet build solution<CR>', desc = 'Build Solution' },
    { '<leader>nq', '<cmd>:Dotnet build default quickfix<CR>', desc = 'Build Default to Quickfix' },
    { '<leader>nQ', '<cmd>:Dotnet build solution quickfix<CR>', desc = 'Build Solution to Quickfix' },
    { '<leader>nr', '<cmd>:Dotnet run default<CR>', desc = 'Run Default Project' },
    { '<leader>nw', '<cmd>:Dotnet watch default<CR>', desc = 'Watch Default Project' },

    -- Project & Diagnostics
    { '<leader>nd', '<cmd>:Dotnet diagnostic<CR>', desc = 'View Diagnostics' },
    { '<leader>ne', '<cmd>:Dotnet diagnostic errors<CR>', desc = 'View Errors' },
    { '<leader>nO', '<cmd>:Dotnet outdated<CR>', desc = 'Check Outdated Packages' },
    { '<leader>ns', '<cmd>:Dotnet solution select<CR>', desc = 'Select/Change Solution' },
    { '<leader>nn', '<cmd>:Dotnet new<CR>', desc = 'New Project/Item' },
    { '<leader>nc', '<cmd>:Dotnet createfile<CR>', desc = 'Create File Picker' },

    -- Package Management
    { '<leader>npa', '<cmd>:Dotnet add package<CR>', desc = 'Add NuGet Package' },
    { '<leader>npr', '<cmd>:Dotnet remove package<CR>', desc = 'Remove NuGet Package' },
    { '<leader>nv', '<cmd>:Dotnet project view<CR>', desc = 'View Project' },

    -- EF Core
    { '<leader>mu', '<cmd>:Dotnet ef database update pick<CR>', desc = 'EF DB Update (Pick Target)' },
    { '<leader>md', '<cmd>:Dotnet ef database drop<CR>', desc = 'EF DB Drop' },
    { '<leader>ma', '<cmd>:Dotnet ef migrations add<CR>', desc = 'EF Migrations Add' },
    { '<leader>ml', '<cmd>:Dotnet ef migrations list<CR>', desc = 'EF Migrations List' },
  },
}
