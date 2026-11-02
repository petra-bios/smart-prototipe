#!/bin/bash
# Fully-detached launcher for agy: run_agy.sh <prompt-file>
cd /Users/mozespetrabios/Documents/hermes-proj/smart-prototipe || exit 1
LOG=/Users/mozespetrabios/Documents/hermes-proj/smart-prototipe/build.log
rm -f "$LOG"
[ -f "$1" ] || { echo "usage: run_agy.sh <prompt-file>"; exit 1; }
nohup ~/.local/bin/agy -p "$(cat "$1")" \
  --model gemini-3.8-flash-high \
  --dangerously-skip-permissions \
  --print-timeout 12h \
  > "$LOG" 2>&1 &
echo "launched pid $! ($1)"
