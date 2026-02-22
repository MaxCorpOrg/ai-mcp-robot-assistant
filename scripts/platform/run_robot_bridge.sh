#!/usr/bin/env bash
set -euo pipefail

APP_ROOT="${APP_ROOT:-/opt/ai_robot}"
ROBOT_ID="${1:-}"

if [[ -z "$ROBOT_ID" ]]; then
  echo "Usage: $0 <robot-id>"
  exit 1
fi

ROBOT_DIR="$APP_ROOT/robots/$ROBOT_ID"
REPO_DIR="$APP_ROOT/repo"
TOOLS_DIR="$REPO_DIR/local-mcp-test/mcp-calculator"
PYTHON_BIN="$APP_ROOT/.venv/bin/python"
MCP_PIPE="$TOOLS_DIR/mcp_pipe.py"

if [[ ! -d "$ROBOT_DIR" ]]; then
  echo "Robot directory not found: $ROBOT_DIR"
  exit 1
fi
if [[ ! -x "$PYTHON_BIN" ]]; then
  echo "Python venv not found: $PYTHON_BIN"
  exit 1
fi
if [[ ! -f "$MCP_PIPE" ]]; then
  echo "mcp_pipe.py not found: $MCP_PIPE"
  exit 1
fi

if [[ -f "$ROBOT_DIR/robot.env" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ROBOT_DIR/robot.env"
  set +a
fi

if [[ ! -f "$ROBOT_DIR/mcp_endpoint.txt" ]]; then
  echo "mcp_endpoint.txt not found: $ROBOT_DIR/mcp_endpoint.txt"
  exit 1
fi

MCP_ENDPOINT="$(tr -d '\r\n' < "$ROBOT_DIR/mcp_endpoint.txt")"
if [[ -z "$MCP_ENDPOINT" || "$MCP_ENDPOINT" == *"REPLACE_WITH_ROBOT_TOKEN"* ]]; then
  echo "MCP endpoint is not configured for robot '$ROBOT_ID'"
  exit 1
fi

export MCP_ENDPOINT
export MCP_CONFIG="$ROBOT_DIR/mcp_config.json"
export PYTHONUNBUFFERED=1
export PATH="$APP_ROOT/.venv/bin:$PATH"

cd "$TOOLS_DIR"
exec "$PYTHON_BIN" "$MCP_PIPE"
