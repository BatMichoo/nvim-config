return function()
  local hl = vim.api.nvim_set_hl

  -- C# Tree-sitter Groups -> Link to Global Groups
  hl(0, '@type.c_sharp', { link = '@type' })
  hl(0, '@variable.c_sharp', { link = '@variable' })
  hl(0, '@variable.field.c_sharp', { link = '@property' })
  hl(0, '@variable.member.c_sharp', { link = '@property' })
  hl(0, '@function.c_sharp', { link = '@function' })
  hl(0, '@keyword.c_sharp', { link = '@keyword' })
  hl(0, '@keyword.import.c_sharp', { link = '@keyword' })
  hl(0, '@keyword.control.c_sharp', { link = '@keyword.control' })
  hl(0, '@constant.builtin.c_sharp', { link = '@keyword' })
  hl(0, '@type.struct.c_sharp', { link = '@type.struct' })

  -- Aliasing
  hl(0, '@variable.parameter.c_sharp', { link = '@variable.c_sharp' })
  hl(0, '@constant.c_sharp', { link = '@property' })
  hl(0, '@method.c_sharp', { link = '@function.c_sharp' })
  hl(0, '@type.enum.c_sharp', { link = '@type.c_sharp' })

  -- C# LSP Semantic Token Groups -> Link to Global/C# Groups
  hl(0, '@lsp.type.keyword.cs', { link = '@keyword.c_sharp' })
  hl(0, '@lsp.type.controlKeyword.cs', { link = '@keyword.control.c_sharp' })
  hl(0, '@lsp.type.class.cs', { link = '@type.c_sharp' })
  hl(0, '@lsp.type.static.cs', { link = '@type.c_sharp' })
  hl(0, '@lsp.type.field.cs', { link = '@variable.field.c_sharp' })
  hl(0, '@lsp.type.property.cs', { link = '@variable.member.c_sharp' })
  hl(0, '@lsp.type.variable.cs', { link = '@variable.c_sharp' })
  hl(0, '@lsp.type.constant.cs', { link = '@property' })
  hl(0, '@lsp.type.parameter.cs', { link = '@variable.c_sharp' })
  hl(0, '@lsp.type.namespace.cs', { link = '@variable.member.c_sharp' })
  hl(0, '@lsp.type.enumMember.cs', { link = '@variable.member.c_sharp' })
  hl(0, '@lsp.typemod.constant.static.cs', { link = '@variable.member.c_sharp' })
  hl(0, '@lsp.type.interface.cs', { link = '@type.interface' })
  hl(0, '@lsp.type.enum.cs', { link = '@lsp.type.interface.cs' })
  hl(0, '@lsp.type.method.cs', { link = '@function.c_sharp' })
  hl(0, '@lsp.type.extensionMethod.cs', { link = '@function.c_sharp' })
  hl(0, '@lsp.type.event.cs', { link = '@function.c_sharp' })
  hl(0, '@lsp.type.struct.cs', { link = '@type.struct.c_sharp' })
end
