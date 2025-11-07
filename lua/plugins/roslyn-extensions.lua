return {
  'seblyng/roslyn.nvim',
  -- The 'ft' (filetype) option tells lazy.nvim to load this plugin
  -- only when one of these filetypes is detected.
  ft = { 'cs', 'cshtml', 'csproj', 'sln' },
  opts = {
    silent = true,
  },
}
