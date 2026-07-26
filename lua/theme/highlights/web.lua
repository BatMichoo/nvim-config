return function(p)
  local hl = vim.api.nvim_set_hl

  hl(0, '@lsp.typemod.variable.defaultLibrary.javascript', { link = 'Type' })
  hl(0, '@lsp.typemod.variable.defaultLibrary.javascriptreact', { link = 'Type' })
  hl(0, '@tag.builtin', { link = '@tag' })
  hl(0, '@tag.javascript', { link = 'Type' })

  hl(0, '@lsp.typemod.variable.defaultLibrary.typescript', { link = 'Type' })
  hl(0, '@lsp.typemod.variable.defaultLibrary.typescriptreact', { link = 'Type' })
  hl(0, '@tag.typescript', { link = 'Type' })
end
