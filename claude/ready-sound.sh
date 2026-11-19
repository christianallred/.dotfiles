#!/bin/sh
# Usage: ready-sound.sh done|blocked
# done: Claude finished its turn. blocked: Claude is waiting on a permission prompt or question.
# Plays in the background and exits 0 when no player or sound file is available.

play() { "$@" </dev/null >/dev/null 2>&1 & }

case "$1" in
  blocked) mac=Ping wsl="Windows Ding" fd=message ;;
  *) mac=Glass wsl="Windows Notify System Generic" fd=complete ;;
esac

case "$(uname -s)" in
  Darwin)
    sound="/System/Library/Sounds/$mac.aiff"
    command -v afplay >/dev/null 2>&1 && [ -f "$sound" ] && play afplay "$sound"
    ;;
  Linux)
    if [ -n "$WSL_DISTRO_NAME" ] || grep -qi microsoft /proc/version 2>/dev/null; then
      # WSLg audio is unreliable, so play the sound on the Windows side; PlaySync
      # because Play returns before the sound starts and powershell would exit
      command -v powershell.exe >/dev/null 2>&1 &&
        play powershell.exe -NoProfile -NonInteractive -Command \
          "(New-Object Media.SoundPlayer 'C:\\Windows\\Media\\$wsl.wav').PlaySync()"
    else
      sound="/usr/share/sounds/freedesktop/stereo/$fd.oga"
      if [ -f "$sound" ] && command -v paplay >/dev/null 2>&1; then
        play paplay "$sound"
      elif [ -f "$sound" ] && command -v pw-play >/dev/null 2>&1; then
        play pw-play "$sound"
      elif command -v canberra-gtk-play >/dev/null 2>&1; then
        play canberra-gtk-play -i "$fd"
      fi
    fi
    ;;
esac
exit 0
