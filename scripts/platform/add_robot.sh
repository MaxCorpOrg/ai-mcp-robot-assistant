#!/usr/bin/env bash
set -euo pipefail

APP_ROOT="${APP_ROOT:-/opt/ai_robot}"
ROBOT_ID="${1:-}"

if [[ -z "$ROBOT_ID" ]]; then
  echo "Usage: $0 <robot-id>"
  exit 1
fi

if [[ ! "$ROBOT_ID" =~ ^[a-zA-Z0-9._-]+$ ]]; then
  echo "Invalid robot-id. Allowed: a-z A-Z 0-9 . _ -"
  exit 1
fi

ROBOT_DIR="$APP_ROOT/robots/$ROBOT_ID"
REPO_DIR="$APP_ROOT/repo"
TOOLS_DIR="$REPO_DIR/local-mcp-test/mcp-calculator"
PYTHON_BIN="$APP_ROOT/.venv/bin/python"
KB_ROOT="$APP_ROOT/shared/kb"

mkdir -p "$ROBOT_DIR" "$KB_ROOT/common" "$KB_ROOT/robots/$ROBOT_ID"

if [[ ! -f "$ROBOT_DIR/profile.md" ]]; then
  cat > "$ROBOT_DIR/profile.md" <<EOF
# Robot Profile: $ROBOT_ID

## Role
Опишите назначение этого робота.

## Behavior
- Стиль общения
- Ограничения
- Приоритеты

## Integrations
- Какие сервисы должен использовать
EOF
fi

if [[ ! -f "$ROBOT_DIR/robot.env" ]]; then
  cat > "$ROBOT_DIR/robot.env" <<EOF
ROBOT_ID=$ROBOT_ID
ROBOT_NAME=$ROBOT_ID
KB_ROOT=$KB_ROOT
ROBOT_PROFILE_PATH=$ROBOT_DIR/profile.md

# Optional email integration
MAIL_USER=
MAIL_PASS=
IMAP_HOST=imap.gmail.com
IMAP_BOX=INBOX
EOF
  chmod 600 "$ROBOT_DIR/robot.env"
fi

if [[ ! -f "$ROBOT_DIR/mcp_endpoint.txt" ]]; then
  cat > "$ROBOT_DIR/mcp_endpoint.txt" <<'EOF'
wss://api.xiaozhi.me/mcp/?token=REPLACE_WITH_ROBOT_TOKEN
EOF
  chmod 600 "$ROBOT_DIR/mcp_endpoint.txt"
fi

if [[ ! -f "$ROBOT_DIR/mcp_config.json" ]]; then
  cat > "$ROBOT_DIR/mcp_config.json" <<EOF
{
  "mcpServers": {
    "simple-tools": {
      "type": "stdio",
      "command": "$PYTHON_BIN",
      "args": ["$TOOLS_DIR/tools_simple.py"]
    },
    "knowledge-tools": {
      "type": "stdio",
      "command": "$PYTHON_BIN",
      "args": ["$TOOLS_DIR/tools_knowledge.py"],
      "env": {
        "KB_ROOT": "$KB_ROOT",
        "ROBOT_PROFILE_PATH": "$ROBOT_DIR/profile.md",
        "ROBOT_ID": "$ROBOT_ID"
      }
    },
    "email-tools": {
      "type": "stdio",
      "command": "$PYTHON_BIN",
      "args": ["$TOOLS_DIR/tools_email.py"],
      "disabled": true
    }
  }
}
EOF
  chmod 600 "$ROBOT_DIR/mcp_config.json"
fi

echo "Robot profile prepared: $ROBOT_ID"
echo "Directory: $ROBOT_DIR"
