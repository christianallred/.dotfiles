#!/usr/bin/env python3
import json
import platform
import re
import shutil
import subprocess
import sys
from pathlib import Path

HOME = Path.home()
DOTFILES = HOME / ".dotfiles"

MIN_NVIM = (0, 12)

# (command, what uses it, brew package, apt package)
REQUIRED_TOOLS = [
    ("zsh", "shell config", "zsh", "zsh"),
    ("git", "everything", "git", "git"),
    ("nvim", "editor (0.12+ for nvim-treesitter main)", "neovim", None),
    ("tmux", "tm / ta session scripts", "tmux", "tmux"),
    ("lazygit", "lg alias, tmux session window", "lazygit", None),
    ("fzf", "project and session pickers", "fzf", "fzf"),
    ("yq", "wt post-create actions (mikefarah yq v4)", "yq", None),
    ("tree-sitter", "builds nvim-treesitter parsers", "tree-sitter-cli", None),
    ("cc", "C compiler for treesitter parsers", None, "build-essential"),
    ("rg", "telescope live grep", "ripgrep", "ripgrep"),
]

OPTIONAL_TOOLS = [
    ("make", "avante.nvim build", None, "make"),
    ("npm", "mcphub.nvim build", "node", None),
    ("claude", "Claude Code, tmux session window", None, None),
    ("spock", "tmux session window (go install github.com/tava-health/review-api/cmd/spock@latest)", None, None),
    ("ghostty", "terminal config", "ghostty", None),
    ("wakeonlan", "eup alias", "wakeonlan", "wakeonlan"),
]


def nvim_too_old():
    out = subprocess.run(["nvim", "--version"], capture_output=True, text=True).stdout
    match = re.search(r"v(\d+)\.(\d+)", out)
    return match and (int(match[1]), int(match[2])) < MIN_NVIM


def describe(cmd, used_by, brew, apt):
    pkg = brew if platform.system() == "Darwin" else apt
    hint = ""
    if pkg:
        hint = f" (brew install {pkg})" if platform.system() == "Darwin" else f" (sudo apt install {pkg})"
    return f"  - {cmd}: {used_by}{hint}"


def check_tools():
    missing = [t for t in REQUIRED_TOOLS if not shutil.which(t[0])]
    missing_optional = [t for t in OPTIONAL_TOOLS if not shutil.which(t[0])]
    old_nvim = shutil.which("nvim") and nvim_too_old()

    if not (missing or missing_optional or old_nvim):
        print("all tools found")
        return

    if missing:
        print("missing tools:")
        print("\n".join(describe(*t) for t in missing))
    if old_nvim:
        print(f"nvim is older than {'.'.join(map(str, MIN_NVIM))}, nvim-treesitter needs a newer version")
    if missing_optional:
        print("missing optional tools:")
        print("\n".join(describe(*t) for t in missing_optional))

    if (missing or old_nvim) and input("\ncontinue anyway? [y/N] ").strip().lower() != "y":
        sys.exit(1)
    print()

STATUSLINE_SETTING = {
    "type": "command",
    "command": "~/.claude/statusline-command.py",
}

READY_SOUND = "~/.claude/hooks/ready-sound.sh"
TMUX_WAITING = "~/.claude/hooks/tmux-waiting.sh"
NEEDS_INPUT = "permission_prompt|elicitation_dialog"


def hook(event, command, matcher=None):
    entry = {"hooks": [{"type": "command", "command": command, "timeout": 5}]}
    if matcher:
        entry = {"matcher": matcher, **entry}
    return event, entry


# (event, hook entry) merged into ~/.claude/settings.json without touching other hooks
CLAUDE_HOOKS = [
    hook("Stop", f"{READY_SOUND} Glass"),
    hook("Notification", f"{READY_SOUND} Ping", NEEDS_INPUT),
    hook("Stop", f"{TMUX_WAITING} done"),
    hook("Notification", f"{TMUX_WAITING} blocked", NEEDS_INPUT),
    hook("UserPromptSubmit", f"{TMUX_WAITING} clear"),
    # clears the flag once a permission prompt is answered and the tool has run
    hook("PostToolUse", f"{TMUX_WAITING} clear"),
    hook("SessionEnd", f"{TMUX_WAITING} clear"),
]

# commands earlier versions of this script installed, removed from settings.json on the next run
RETIRED_HOOK_COMMANDS = [f"{TMUX_WAITING} set"]


def source_from_rc(rc_name):
    rc = HOME / rc_name
    target = DOTFILES / rc_name

    # Migrate from the old symlink setup: appending to a symlinked rc file
    # would write into the dotfiles copy itself and make it source itself forever.
    if rc.is_symlink() and rc.resolve() == target.resolve():
        print(f"replacing {rc_name} symlink with a regular file")
        rc.unlink()

    if rc.exists() and f"dotfiles/{rc_name}" in rc.read_text():
        return

    print(f"adding dotfiles source to {rc_name}")
    with rc.open("a") as f:
        f.write(f"\n# Dotfiles\nsource {target}\n")


def link(name, src, dest):
    # is_symlink() so a broken symlink still counts as "already exists"
    if dest.exists() or dest.is_symlink():
        print(f"skipping {name} (already exists)")
        return

    print(f"linking {name}")
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.symlink_to(src)


def merge_statusline(settings):
    if settings.get("statusLine") == STATUSLINE_SETTING:
        return False

    if "statusLine" in settings:
        print(f"replacing existing claude statusLine setting: {settings['statusLine']}")
    else:
        print("adding claude statusline setting")

    settings["statusLine"] = STATUSLINE_SETTING
    return True


def merge_hooks(settings):
    hooks = settings.setdefault("hooks", {})
    changed = False

    for event, entries in hooks.items():
        for entry in entries:
            kept = [h for h in entry.get("hooks", []) if h.get("command") not in RETIRED_HOOK_COMMANDS]
            if len(kept) != len(entry.get("hooks", [])):
                print(f"removing retired claude {event} hook")
                entry["hooks"] = kept
                changed = True
        hooks[event] = [e for e in entries if e.get("hooks")]

    for event, entry in CLAUDE_HOOKS:
        command = entry["hooks"][0]["command"]
        entries = hooks.setdefault(event, [])
        if any(h.get("command") == command for e in entries for h in e.get("hooks", [])):
            continue

        print(f"adding claude {event} hook: {command}")
        entries.append(entry)
        changed = True

    return changed


def configure_claude_settings():
    settings_path = HOME / ".claude" / "settings.json"

    settings = {}
    if settings_path.exists():
        try:
            settings = json.loads(settings_path.read_text() or "{}")
        except json.JSONDecodeError as e:
            print(f"skipping claude settings ({settings_path} is not valid JSON: {e})")
            return

    # list, not a generator: both merges must run
    if not any([merge_statusline(settings), merge_hooks(settings)]):
        print("skipping claude settings (already configured)")
        return

    settings_path.parent.mkdir(parents=True, exist_ok=True)
    settings_path.write_text(json.dumps(settings, indent=2) + "\n")


def main():
    check_tools()

    source_from_rc(".zshrc")

    link("lazygit/", DOTFILES / "lazygit", HOME / ".config" / "lazygit")
    link("ghostty/", DOTFILES / "ghostty", HOME / ".config" / "ghostty")
    link("nvim/", DOTFILES / "nvim", HOME / ".config" / "nvim")
    link(".tmux.conf", DOTFILES / ".tmux.conf", HOME / ".tmux.conf")
    link(
        "claude statusline",
        DOTFILES / "claude" / "statusline-command.py",
        HOME / ".claude" / "statusline-command.py",
    )
    link(
        "claude ready sound hook",
        DOTFILES / "claude" / "ready-sound.sh",
        HOME / ".claude" / "hooks" / "ready-sound.sh",
    )
    link(
        "claude tmux waiting hook",
        DOTFILES / "claude" / "tmux-waiting.sh",
        HOME / ".claude" / "hooks" / "tmux-waiting.sh",
    )

    configure_claude_settings()


if __name__ == "__main__":
    sys.exit(main())
