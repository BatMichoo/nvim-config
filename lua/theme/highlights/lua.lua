return function(p)
  local hl = vim.api.nvim_set_hl

  hl(0, '@lsp.type.property.lua', { link = '@property' })
end
