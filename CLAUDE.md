# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Installation

Run from anywhere:

```bash
~/.dotfiles/install.py
```

This creates symlinks from `~/.dotfiles/` to the standard config locations. It does **not** use stow or chezmoi — all linking is done by hand in `install.py`. The exception is `~/.zshrc`: the script appends a `source ~/.dotfiles/.zshrc` line to it instead, so existing contents are preserved. Bash is not configured; zsh is the only supported shell. It also merges a `statusLine` entry and the hooks in `CLAUDE_HOOKS` into `~/.claude/settings.json` without touching other keys or existing hooks. Before linking anything it checks for the tools the setup depends on (`REQUIRED_TOOLS` / `OPTIONAL_TOOLS` at the top of `install.py`) and asks before continuing if required ones are missing — add new dependencies there.

## Git Workflow

This is a personal repo with no PR process: commit directly to `main` and push. The branch, worktree, draft-PR and review-gate rules from the shared Tava guidance do not apply here.

## Architecture

This is a symlink-based dotfiles repo. Everything lives in `~/.dotfiles/` and gets linked into place:

| Config | Links to |
|--------|----------|
| `~/.zshrc` | sources `.zshrc` |
| `~/.config/nvim` | `nvim/` |
| `~/.config/ghostty` | `ghostty/` |
| `~/.config/lazygit` | `lazygit/` |
| `~/.tmux.conf` | `.tmux.conf` |
| `~/.claude/statusline-command.py` | `claude/statusline-command.py` |
| `~/.claude/hooks/ready-sound.sh` | `claude/ready-sound.sh` |
| `~/.claude/hooks/tmux-waiting.sh` | `claude/tmux-waiting.sh` |

Secrets are sourced from `~/.dotfiles/.zsh_secrets` (git-ignored, never committed). Aliases live in `.zsh_alias`.

## Neovim

Plugin manager: **lazy.nvim** (bootstrap in `nvim/lua/lazy-manager.lua`). Entry point is `nvim/init.lua`, which loads:
- `lua/options.lua` — vim options
- `lua/remap.lua` — keybindings
- `lua/autocmd/lsp-attach.lua` — LSP on-attach behavior
- `lua/lazy-manager.lua` — plugin management
- `lua/lsp.lua` — LSP server setup

Plugin configs are in `nvim/lua/plugins/`. LSP server configs are in `nvim/lsp/` — add a new server by creating `<servername>.lua` there.

Formatter: **stylua** (configured in `nvim/stylua.toml` — space indents, width 2).

AI integrations: **avante.nvim** (provider and model set in `nvim/lua/plugins/ai/avante.lua`) and **mcphub.nvim** (MCP support via npm).

## Claude Statusline

`claude/statusline-command.py` is a custom Python script that formats Claude session info for the terminal statusline. It displays model, directory, git branch/status, context %, cost, duration, and rate limits with color coding.

## Claude Ready Sound

`claude/ready-sound.sh <sound>` plays a macOS system sound with `afplay` and does nothing where `afplay` is missing. The `Stop` hook plays Glass when Claude finishes a turn; the `Notification` hook plays Ping for permission prompts and elicitation dialogs.

## Claude Waiting Flag in tmux

`claude/tmux-waiting.sh blocked|done|clear` sets or unsets the `@claude_waiting` option on the tmux session that owns `$TMUX_PANE`, and does nothing outside tmux. The `Notification` hook sets `blocked`; the `Stop` hook sets `done`; `UserPromptSubmit`, `PostToolUse`, `SessionStart` and `SessionEnd` clear it. `.tmux.conf` reads it in the `prefix + s` session list and in `status-right` and binds `prefix + u` / `prefix + U` to clear the flag for the current session / every session.
