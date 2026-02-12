return {
  'rcarriga/nvim-notify',
  opts = function(_, opts)
    if vim.fn.has 'win32' == 1 then
      opts.background_colour = '#1F1F1F' -- VSCode Modern background
    end
  end,
}
