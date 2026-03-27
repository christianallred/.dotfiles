# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Installation

Run from the home directory (`$HOME`):

```bash
~/.dotfiles/install.sh
```

This creates symlinks from `~/.dotfiles/` to the standard config locations. It does **not** use stow or chezmoi — all linking is manual via `ln -n -s`.

## Architecture

This is a symlink-based dotfiles repo. Everything lives in `~/.dotfiles/` and gets linked into place:

| Config | Links to |
|--------|----------|
| `~/.zshrc` | `.zshrc` |
| `~/.tmux.conf` | `.tmux.conf` |
| `~/.config/nvim` | `nvim/` |
| `~/.config/ghostty` | `ghostty/` |
| `~/.config/lazygit` | `lazygit/` |
| `~/.config/kitty/<user>.conf` | `.kitty.conf` |
| `~/.claude/statusline-command.py` | `claude/statusline-command.py` |

Secrets are sourced from `~/.dotfiles/.zsh_secrets` (git-ignored, never committed). Aliases live in `.zsh_alias`.

## Neovim

Plugin manager: **lazy.nvim** (bootstrap in `nvim/lua/lazy-manager.lua`). Entry point is `nvim/init.lua`, which loads:
- `lua/options.lua` — vim options
- `lua/remap.lua` — keybindings
- `lua/autocmd/lsp-attach.lua` — LSP on-attach behavior
- `lua/lazy-manager.lua` — plugin management
- `lua/lsp.lua` — LSP server setup

Plugin configs are in `nvim/lua/plugins/`. LSP server configs are in `nvim/lsp/` — add a new server by creating `<servername>.lua` there.

Formatter: **stylua** (configured in `nvim/stylua.toml` — tab indents, width 4).

AI integrations: **avante.nvim** (Claude claude-sonnet-4-20250514) and **mcphub.nvim** (MCP support via npm).

## Claude Statusline

`claude/statusline-command.py` is a custom Python script that formats Claude session info for the terminal statusline. It displays model, directory, git branch/status, context %, cost, duration, and rate limits with color coding.
