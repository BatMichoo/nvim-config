-- Same Roslyn engine as Visual Studio, driven by .editorconfig
return {
  formatter = 'dotnet_format',
  mason = false,
  filetypes = { 'cs' },
  definition = {
    command = 'dotnet',
    args = { 'format', 'whitespace', '--folder', '$DIRNAME', '--include', '$FILENAME' },
    stdin = false,
  },
}
