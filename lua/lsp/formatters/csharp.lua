-- Same Roslyn engine as Visual Studio, driven by .editorconfig
return {
  -- Run in order: Roslyn never joins lines, so pull stray ';' up first
  formatter = { 'cs_join_semicolons', 'dotnet_format' },
  mason = false,
  filetypes = { 'cs' },
  definitions = {
    cs_join_semicolons = {
      format = function(_, _, lines, callback)
        local out = {}
        for _, line in ipairs(lines) do
          local prev = out[#out]
          -- Skip joins that would land inside a // comment or after { / ;
          if
            line:match '^%s*;%s*$'
            and prev
            and prev:match '%S'
            and not prev:find('//', 1, true)
            and not prev:match '[{;]%s*$'
          then
            out[#out] = prev:gsub('%s+$', '') .. ';'
          else
            table.insert(out, line)
          end
        end
        callback(nil, out)
      end,
    },
    dotnet_format = {
      command = 'dotnet',
      args = { 'format', 'whitespace', '--folder', '$DIRNAME', '--include', '$FILENAME' },
      stdin = false,
    },
  },
}
