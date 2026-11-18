#!/bin/sh
# Usage: tmux-waiting.sh set|clear
[ -n "$TMUX_PANE" ] || exit 0

case "$1" in
  set) tmux set-option -t "$TMUX_PANE" @claude_waiting 1 ;;
  clear) tmux set-option -u -t "$TMUX_PANE" @claude_waiting ;;
esac >/dev/null 2>&1
exit 0
