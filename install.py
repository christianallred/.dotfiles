#!/usr/bin/env python3
import json
import sys
from pathlib import Path

HOME = Path.home()
DOTFILES = HOME / ".dotfiles"

STATUSLINE_SETTING = {
    "type": "command",
    "command": "~/.claude/statusline-command.py",
}


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


def configure_statusline():
    settings_path = HOME / ".claude" / "settings.json"

    settings = {}
    if settings_path.exists():
        try:
            settings = json.loads(settings_path.read_text() or "{}")
        except json.JSONDecodeError as e:
            print(f"skipping claude statusline setting ({settings_path} is not valid JSON: {e})")
            return

    if settings.get("statusLine") == STATUSLINE_SETTING:
        print("skipping claude statusline setting (already configured)")
        return

    if "statusLine" in settings:
        print(f"replacing existing claude statusLine setting: {settings['statusLine']}")
    else:
        print("adding claude statusline setting")

    settings["statusLine"] = STATUSLINE_SETTING
    settings_path.parent.mkdir(parents=True, exist_ok=True)
    settings_path.write_text(json.dumps(settings, indent=2) + "\n")


def main():
    source_from_rc(".zshrc")
    source_from_rc(".bashrc")

    link("lazygit/", DOTFILES / "lazygit", HOME / ".config" / "lazygit")
    link("ghostty/", DOTFILES / "ghostty", HOME / ".config" / "ghostty")
    link("nvim/", DOTFILES / "nvim", HOME / ".config" / "nvim")
    link(".tmux.conf", DOTFILES / ".tmux.conf", HOME / ".tmux.conf")
    link(
        "claude statusline",
        DOTFILES / "claude" / "statusline-command.py",
        HOME / ".claude" / "statusline-command.py",
    )

    configure_statusline()


if __name__ == "__main__":
    sys.exit(main())
