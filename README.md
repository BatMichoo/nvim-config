# 🚀 Neovim Configuration

A modern, fast, cross-platform, and feature-rich Neovim configuration optimized for **.NET (C#)**, **Web Development (TS/JS/React/Electron)**, and **Go**, with deep AI integration, unit testing, and full DAP debugging.

## ✨ Highlights

- ⚡ **Fast**: Built with `lazy.nvim` for modularity, zero-lag startup, and lazy-loading.
- 🛠️ **Unified Tool Management**: Modular tool registries (`lsp/`, `dap/`) auto-installing LSPs, linters, formatters, and debuggers via `mason.nvim`.
- 🐞 **Cross-Platform Debugging**: Full `nvim-dap` support for JS/TS/React, Electron (Main & Renderer), .NET (`netcoredbg`), and Go (`delve`).
- 🧪 **Integrated Unit Testing**: Powered by `neotest` (`neotest-vitest`, `neotest-dotnet`, `neotest-golang`) with direct DAP debugging (`<leader>dt`).
- 🔷 **C# First-Class Support**: Custom Roslyn extensions and `easy-dotnet.nvim` for a seamless .NET experience.
- 🎨 **Modern Aesthetics**: `vscode-modern` theme with custom semantic highlighting.
- 🤖 **AI-Powered**: Native integration with `CodeCompanion.nvim` for agentic workflows.
- 🗄️ **Database Client**: `dadbod-grip.nvim` with connections defined in a local, untracked `lua/databases.lua`.
- 🧩 **Productivity Boosters**: Telescope, Harpoon, Neo-tree, and more.

---

## 🏗️ Core Architecture

- **Plugin Manager**: `lazy.nvim`
- **Domain Registries**: Modular domain folders (`lua/lsp/`, `lua/debugging/`, `lua/testing/`) for plug-and-play server, debugger, and test adapter management.
- **Tool Installer**: `lua/utils/installer.lua` aggregating `lsp/servers`, `lsp/linters`, `lsp/formatters`, and `debugging` for `mason.nvim`.
- **LSP Management**: `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`
- **Debugging**: `nvim-dap`, `nvim-dap-ui`, `js-debug-adapter`, `netcoredbg`, `delve`.
- **Testing**: `neotest` with adapters dynamically loaded from `lua/testing/` (`vitest`, `dotnet`, `golang`).
- **Completion**: `nvim-cmp` with snippets and LSP integration.
- **Tree-sitter**: `nvim-treesitter` for high-performance syntax highlighting.
- **Formatting**: `conform.nvim` (auto-format on save for Lua, Web, Go).
- **Linting**: `nvim-lint` (ESLint for Web, golangcilint for Go).

---

## 🎨 UI & UX

- **Theme**: `vscode_modern_theme.nvim` with transparent background and custom highlights.
- **Statusline**: `lualine.nvim` for a clean and informative bottom bar, with an animated progress bar for LSP and native Neovim progress (e.g. Roslyn loading a solution).
- **Notifications**: `noice.nvim` and `nvim-notify` for modern popups and CMD line.
- **File Explorer**: `neo-tree.lua` for sidebar navigation.
- **Dashboard**: `alpha.nvim` for a fast, custom start screen.
- **Fuzzy Finder**: `telescope.nvim` for files, symbols, and diagnostics.
- **Debugger UI**: `nvim-dap-ui` for variable scopes, watches, and stack traces.

---

## 💻 Language Support & Debugging

### 🌐 Web Stack, React & Electron

- **Languages**: TypeScript, JavaScript, React, HTML, CSS, JSON.
- **Formatting & Linting**: Auto-format with `prettier`, smart ESLint detection.
- **Testing**: `neotest-vitest` adapter for Vitest unit tests.
- **Debugging (`js-debug-adapter`)**:
  - Launch / Attach Node.js processes
  - Launch / Attach Chrome for Vite & React frontend apps
  - Debug Electron Main Process (including Electron Forge + Vite with sourcemaps)
  - Attach Electron Renderer Process (Port `9222`)

### 🔷 .NET (C#)

- **Engine**: Roslyn-based LSP with custom extensions.
- **Easy-Dotnet**: Comprehensive keybindings for `dotnet build/run/test/watch`, EF Core, and NuGet.
- **Testing & Debugging**: `neotest-dotnet` and `netcoredbg` integration via DAP.

### 🐹 Go

- **LSP**: `gopls`
- **Formatting & Linting**: `goimports`, `golangci-lint`
- **Testing & Debugging**: `neotest-golang` and `delve` integration via DAP.

---

## 🤖 AI Integration

The config features **CodeCompanion.nvim** integrated with the **Gemini CLI agent**.

- `<leader>ci`: Inline AI prompt.
- `<leader>cc`: Open AI Chat buffer.
- `<leader>cg`: Start an Agentic Workflow.
- `<leader>ct`: Open the CodeCompanion CLI.

---

## 🗄️ Databases

Database browsing and querying use **dadbod-grip.nvim** (a fork with SQL Server Entra ID auth). Connections live in `lua/databases.lua`, which is gitignored so credentials stay out of the repo:

```sh
cp lua/databases.template.lua lua/databases.lua
```

Then fill in `servers` (host aliases) and `definitions` (one entry per database, listing which servers it lives on). Restart Neovim after editing; the file is read once when grip loads.

| Action                 | Shortcut     |
| :--------------------- | :----------- |
| **Toggle Browser Tab** | `<leader>Db` |
| **Connections**        | `<leader>Dc` |
| **Query Pad**          | `<leader>Dq` |
| **Tables**             | `<leader>Dt` |
| **Schema Browser**     | `<leader>Ds` |
| **Query History**      | `<leader>Dh` |
| **Load Saved Query**   | `<leader>Dl` |

The dashboard's `b` button opens the same browser tab.

---

## ⌨️ Key Navigation & Shortcuts

### General & Search
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

### Debugging (DAP)
| Action                    | Shortcut     |
| :------------------------ | :----------- |
| **Start / Continue**      | `<F5>`       |
| **Step Into**             | `<F1>`       |
| **Step Over**             | `<F2>`       |
| **Step Out**              | `<F3>`       |
| **Toggle Debug UI**       | `<F7>`       |
| **Toggle Breakpoint**     | `<leader>b`  |
| **Conditional Breakpoint**| `<leader>B`  |
| **Debug Nearest Test**    | `<leader>dt` |

### Unit Testing (Neotest)
| Action               | Shortcut     |
| :------------------- | :----------- |
| **Run Nearest Test** | `<leader>tn` |
| **Run File Tests**   | `<leader>tf` |
| **Run All Tests**    | `<leader>ta` |
| **Test Summary**     | `<leader>ts` |
| **Output Panel**     | `<leader>tp` |

---

## 📦 Installation

1. Ensure you have **Neovim 0.12+** installed.
2. Clone this repo to `~/.config/nvim`.
3. Open Neovim; `lazy.nvim` will automatically download and install all plugins.
4. `utils.installer` will automatically prompt Mason to install all LSP servers, linters, formatters, and debuggers.
5. Optional: copy `lua/databases.template.lua` to `lua/databases.lua` and add your database connections (see the Databases section above).

---

_Happy Coding!_ 🚀
