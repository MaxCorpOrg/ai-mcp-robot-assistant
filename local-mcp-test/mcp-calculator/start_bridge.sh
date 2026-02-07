#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

if [[ ! -f "$DIR/mcp_endpoint.txt" ]]; then
  echo "mcp_endpoint.txt not found"
  exit 1
fi

ENDPOINT="$(<"$DIR/mcp_endpoint.txt")"
if [[ -z "$ENDPOINT" ]]; then
  echo "mcp_endpoint.txt is empty"
  exit 1
fi

source "$DIR/.venv/bin/activate"
if [[ -f "$DIR/mail_env.sh" ]]; then
  # Load optional email credentials for tools_email.py.
  source "$DIR/mail_env.sh"
fi
nohup env MCP_ENDPOINT="$ENDPOINT" python mcp_pipe.py > "$DIR/mcp_bridge.log" 2>&1 &
echo $! > "$DIR/mcp_bridge.pid"
echo "bridge_started pid=$(cat "$DIR/mcp_bridge.pid")"
