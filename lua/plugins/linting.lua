return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    -- 1. Base Configuration
    local linters_by_ft = {
      markdown = { 'markdownlint' },
      dockerfile = { 'hadolint' },
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
    }

    -- 2. Conditional Go Support (Linux Only)
    if vim.fn.has 'win32' == 0 then
      linters_by_ft.go = { 'golangcilint' }
    end

    lint.linters_by_ft = linters_by_ft

    -- 3. Helper: Check for ESLint config
    local eslint_config_files = {
      '.eslintrc',
      '.eslintrc.js',
      '.eslintrc.cjs',
      '.eslintrc.json',
      'eslint.config.js',
      'eslint.config.mjs',
      'eslint.config.cjs',
    }

    local function has_eslint_config()
      return #vim.fs.find(eslint_config_files, {
        upward = true,
        stop = vim.uv.os_homedir(),
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      }) > 0
    end

    -- 4. Clean Autocmd
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        local ft = vim.bo.filetype

        -- If it's a JS/TS file, only run if config exists
        if ft:match 'javascript' or ft:match 'typescript' then
          if has_eslint_config() then
            lint.try_lint()
          end
        else
          -- For all other types (Go, Markdown, Docker), just run whatever is in the table
          -- If we are on Windows, the 'go' key doesn't exist, so this does nothing safely.
          lint.try_lint()
        end
      end,
    })
  end,
}
