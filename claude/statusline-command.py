#!/usr/bin/env python3
import sys
import json
import subprocess
from datetime import datetime


data = json.load(sys.stdin)

model = data.get("model", {}).get("display_name", "")
workspace = data.get("workspace", {})
cwd = workspace.get("current_dir") or data.get("cwd", "")
cost = data.get("cost", {}).get("total_cost_usd", 0) or 0
duration_ms = data.get("cost", {}).get("total_duration_ms", 0) or 0
used_pct_raw = data.get("context_window", {}).get("used_percentage") or 0
pct = int(float(used_pct_raw))

CYAN   = "\033[36m"
GREEN  = "\033[32m"
YELLOW = "\033[33m"
RED    = "\033[31m"
RESET  = "\033[0m"

# Pick bar color based on context usage
if pct >= 90:
    bar_color = RED
elif pct >= 70:
    bar_color = YELLOW
else:
    bar_color = GREEN

filled = pct // 10
empty = 10 - filled
bar = "█" * filled + "░" * empty

mins = duration_ms // 60000
secs = (duration_ms % 60000) // 1000

dir_name = cwd.split("/")[-1] if cwd else ""

# Git info
branch = ""
git_status = ""
try:
    result = subprocess.run(
        ["git", "-C", cwd, "-c", "core.hooksPath=/dev/null", "branch", "--show-current"],
        capture_output=True, text=True
    )
    if result.returncode == 0:
        branch = result.stdout.strip()

    staged = subprocess.run(
        ["git", "-C", cwd, "-c", "core.hooksPath=/dev/null", "diff", "--cached", "--numstat"],
        capture_output=True, text=True
    )
    modified = subprocess.run(
        ["git", "-C", cwd, "-c", "core.hooksPath=/dev/null", "diff", "--numstat"],
        capture_output=True, text=True
    )
    staged_count = len([l for l in staged.stdout.strip().splitlines() if l])
    modified_count = len([l for l in modified.stdout.strip().splitlines() if l])

    if staged_count > 0:
        git_status += f"{GREEN}+{staged_count}{RESET}"
    if modified_count > 0:
        git_status += f"{YELLOW}~{modified_count}{RESET}"
except Exception:
    pass


# rate limits
rate = data.get('rate_limits', {})
five_h_obj = rate.get('five_hour', {})
week_obj = rate.get('seven_day', {})
five_h = five_h_obj.get('used_percentage')
week = week_obj.get('used_percentage')
parts = []
if five_h is not None:
    reset_ts = five_h_obj.get('resets_at')
    reset_str = f" (@{datetime.fromtimestamp(reset_ts).strftime('%H:%M')})" if reset_ts else ""
    parts.append(f"5h: {five_h:.0f}%{reset_str}")
if week is not None:
    parts.append(f"7d: {week:.0f}%")




if branch:
    print(f"{CYAN}[{model}]{RESET} 📁 {dir_name} | 🌿 {branch} {git_status}")
else:
    print(f"{CYAN}[{model}]{RESET} 📁 {dir_name}")

cost_fmt = f"${cost:.2f}"
print(f"Context: {bar_color}{bar}{RESET} {pct}% | {YELLOW}{cost_fmt}{RESET} | ⏱️ {mins}m {secs}s | 📊 {' '.join(parts)}")


