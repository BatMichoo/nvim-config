# 🚀 Neovim Configuration

A modern, fast, and feature-rich Neovim configuration optimized for **.NET (C#)**, **Web Development (TS/JS)**, and **Go**, with deep AI integration.

## ✨ Highlights

- ⚡ **Fast**: Built with `lazy.nvim` for modularity and lazy-loading.
- 🛠️ **Full LSP Suite**: Powered by `mason.nvim` for easy tool management.
- 🔷 **C# First-Class Support**: Custom Roslyn extensions and `easy-dotnet.nvim` for a seamless .NET experience.
- 🎨 **Modern Aesthetics**: `vscode-modern` theme with custom semantic highlighting for C#.
- 🤖 **AI-Powered**: Native integration with `CodeCompanion.nvim` for agentic workflows.
- 🧩 **Productivity Boosters**: Telescope, Harpoon, Neo-tree, and more.

---

## 🏗️ Core Architecture

- **Plugin Manager**: `lazy.nvim`
- **LSP Management**: `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`
- **Completion**: `nvim-cmp` with snippets and LSP integration.
- **Tree-sitter**: `nvim-treesitter` for high-performance syntax highlighting.
- **Formatting**: `conform.nvim` (auto-format on save for Lua, Web, Go).
- **Linting**: `nvim-lint` (ESLint for Web, golangcilint for Go).

---

## 🎨 UI & UX

- **Theme**: `vscode_modern_theme.nvim` with transparent background and custom highlights.
- **Statusline**: `lualine.nvim` for a clean and informative bottom bar.
- **Notifications**: `noice.nvim` and `nvim-notify` for modern popups and CMD line.
- **File Explorer**: `neo-tree.lua` for sidebar navigation.
- **Dashboard**: `alpha.nvim` for a fast, custom start screen.
- **Fuzzy Finder**: `telescope.nvim` for files, symbols, and diagnostics.
- **Others**: `indent-blankline`, `highlight-colors`, `todo-comments`.

---

## 💻 Language Support

### 🔷 .NET (C#)

- **Engine**: Roslyn-based LSP with custom extensions.
- **Easy-Dotnet**: Comprehensive keybindings for:
  - `dotnet build/run/test/watch`
  - EF Core Migrations
  - NuGet package management
  - Solution/Project navigation
- **Debugger**: `netcoredbg` integration via DAP.

### 🌐 Web Stack

- **Languages**: TypeScript, JavaScript, React, HTML, CSS, JSON.
- **Formatting**: Auto-format with `prettier`.
- **Linting**: Smart ESLint detection (runs only if config is present).

### 🐹 Go (Linux)

- **LSP**: `gopls`
- **Formatting**: `goimports`
- **Linting**: `golangci-lint`

---

## 🤖 AI Integration

The config features **CodeCompanion.nvim** integrated with the **Gemini CLI agent**.

- `<leader>ci`: Inline AI prompt.
- `<leader>cc`: Open AI Chat buffer.
- `<leader>cg`: Start an Agentic Workflow.
- `<leader>ct`: Open the CodeCompanion CLI.

---

## ⌨️ Key Navigation & Shortcuts

| Action               | Shortcut      |
| :------------------- | :------------ |
| **Search Files**     | `<leader>sf`  |
| **Search Word**      | `<leader>sg`  |
| **Format**           | `<leader>f`   |
| **Toggle Sidebar**   | `<leader>nt`  |
| **Quickfix List**    | `<leader>q`   |
| **LSP Rename**       | `grn`         |
| **LSP Code Action**  | `gra`         |
| **LSP References**   | `grr`         |
| **Terminal Exit**    | `<Esc><Esc>`  |
| **Split Navigation** | `<C-h/j/k/l>` |

---

## 📦 Installation

1. Ensure you have **Neovim 0.10+** installed.
2. Clone this repo to `~/.config/nvim`.
3. Open Neovim; `lazy.nvim` will automatically download and install all plugins.
4. Run `:Mason` to check if language servers (like `roslyn`, `ts_ls`, `gopls`) are installing correctly.

---

_Happy Coding!_ 🚀
