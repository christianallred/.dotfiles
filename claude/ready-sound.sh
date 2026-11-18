#!/bin/sh
# Usage: ready-sound.sh [macOS system sound name]
sound="/System/Library/Sounds/${1:-Glass}.aiff"

if command -v afplay >/dev/null 2>&1 && [ -f "$sound" ]; then
  afplay "$sound" >/dev/null 2>&1 &
fi
exit 0
