-- Linux: let Neovim watch files instead of Roslyn's in-process watcher, which
-- misses new files (they land in the misc workspace with no project context).
-- Needs inotifywait (inotify-tools) and raised inotify limits.
-- Windows: the reverse. Neovim 0.12 builds baseUri watcher patterns from
-- backslash paths but matches them against normalized forward-slash paths, so
-- Roslyn's project watchers never fire. Roslyn's own watcher works fine there.
---@type vim.lsp.Config
return {
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = vim.fn.has 'win32' == 0,
      },
    },
  },
}
