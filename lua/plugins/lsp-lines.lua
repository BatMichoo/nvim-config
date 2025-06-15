return {
  'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  -- event = "VeryLazy",
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('lsp_lines').setup()

    vim.diagnostic.config {
      virtual_lines = true,
      virtual_text = false,
    }

    -- local function toggleLines()
    --   local new_value = not vim.diagnostic.config().virtual_lines
    --   vim.diagnostic.config { virtual_lines = new_value, virtual_text = not new_value }
    --   return new_value
    -- end
    --
    -- vim.keymap.set('n', '<leader>lu', toggleLines, { desc = 'Toggle Underline Diagnostics', silent = true })
  end,
}
