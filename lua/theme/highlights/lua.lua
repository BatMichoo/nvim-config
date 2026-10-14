---@diagnostic disable-next-line: unused-local
return function(p)
  local hl = vim.api.nvim_set_hl

  hl(0, '@lsp.type.property.lua', { link = '@property' })
  hl(0, '@lsp.mod.global.lua', { link = '@type' })
  hl(0, '@lsp.mod.defaultLibrary.lua', { link = '@type' })
  hl(0, '@lsp.typemod.function.defaultLibrary.lua', { link = '@function' })
end
