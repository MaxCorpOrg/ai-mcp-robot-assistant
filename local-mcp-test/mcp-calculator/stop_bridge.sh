#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$DIR/mcp_bridge.pid"

if [[ ! -f "$PID_FILE" ]]; then
  echo "no_pid_file"
else
  PID="$(cat "$PID_FILE")"
  if ps -p "$PID" > /dev/null 2>&1; then
    kill "$PID" || true
    sleep 1
    if ps -p "$PID" > /dev/null 2>&1; then
      kill -9 "$PID" || true
    fi
  fi
  rm -f "$PID_FILE"
fi

# Cleanup possible stale processes when pid file was missing/outdated.
pkill -f "python mcp_pipe.py" || true
pkill -f "python tools_simple.py" || true
pkill -f "python tools_email.py" || true

echo "bridge_stopped"
