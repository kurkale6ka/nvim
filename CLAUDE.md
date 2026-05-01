# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal Neovim configuration managed with **lazy.nvim**. There is no build step, test suite, or CI — changes take effect when Neovim restarts or `:Lazy reload` is run.

## Architecture

### Entry point

`init.lua` (root) is the single entry point. It sets all core Vim options, enables LSP servers via `vim.lsp.enable()`, defines LSP keybindings on `LspAttach`, and loads config modules from `lua/config/`.

### Config modules (`lua/config/`)

| File | Purpose |
|---|---|
| `lazy.lua` | Bootstraps lazy.nvim; imports plugin specs from `lua/plugins/` |
| `auto-commands/init.lua` | Autocommands (whitespace cleanup, yank highlight, last cursor position) |
| `noplugins.lua` | Disables unwanted built-in plugins (netrw, zip, tar, etc.) |
| `abbreviations.lua` | Typo corrections and personal shorthand expansions |
| `readline.lua` | Readline-style insert/command-mode keybindings |
| `statusline.lua` | Legacy statusline (superseded by lualine.nvim) |
| `clipboard.lua` | Clipboard integration |

`lua/local.lua` is gitignored — it holds machine-specific config (Copilot workspace folders, etc.).

### Plugin specs (`lua/plugins/`)

Each file exports a lazy.nvim spec table. Colorschemes live in `lua/plugins/colorschemes/`. The active colorscheme is onedark, set at the bottom of `init.lua`.

### LSP

Servers are enabled in `init.lua` with `vim.lsp.enable { 'bashls', 'lua_ls', 'pyright', 'ruff', 'tailwindcss', 'ts_ls' }`. Per-server settings live in `lsp/<server>.lua` (e.g. `lsp/lua_ls.lua`, `lsp/pyright.lua`).

**Formatting** is handled by conform.nvim (`lua/plugins/conform.lua`), not LSP formatters:
- Lua → stylua
- Python → isort (then LSP)
- Shell → shfmt
- HTML / Markdown / JSON / JS / TS → prettier

### Filetype-specific overrides

`after/ftplugin/` holds filetype-specific settings (html, css, perl, php, ruby, …). `filetype.lua` (root) adds custom filetype detection patterns (`.pgn`, `known_hosts`, `authorized_keys`).

### Autoload helpers (`autoload/`)

VimScript utilities exposed as commands: `:Ascii`, `:RemoveEOLSpaces`, `:Underline`, `:Scratch`. These are called from `init.lua` command definitions.

## Key conventions

- **Leader**: `<Space>` (normal), `\` (local leader)
- Adding a plugin: create a new file in `lua/plugins/` returning a lazy.nvim spec, or append to an existing file that groups related plugins.
- Adding an LSP server: add `vim.lsp.enable { '…' }` in `init.lua` and, if needed, a settings file at `lsp/<name>.lua`.
- `lazy-lock.json` is committed — update it intentionally with `:Lazy update`.

## Notable keybindings (for context when editing mappings)

| Key | Action |
|---|---|
| `<leader>f` | Format buffer (conform.nvim) |
| `<leader>b/l/h/g` | fzf buffers / git files / history / ripgrep |
| `<leader>v` | Toggle nvim-tree |
| `<leader>ca` | LSP code action |
| `<leader>m` | LSP rename |
| `gd` / `gD` | LSP definition / declaration |
| `K` | LSP hover |


<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:ca08a54f -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

## Session Completion

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
<!-- END BEADS INTEGRATION -->
