-- Let Neovim watch files instead of Roslyn's in-process watcher, which misses
-- new files (they land in the misc workspace with no project context).
-- Needs inotifywait (inotify-tools) and raised inotify limits.
---@type vim.lsp.Config
return {
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
}
