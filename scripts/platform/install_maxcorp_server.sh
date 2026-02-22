#!/usr/bin/env bash
set -euo pipefail

APP_ROOT="${APP_ROOT:-/opt/ai_robot}"
REPO_URL="${REPO_URL:-git@github.com:MaxCorpOrg/ai-mcp-robot-assistant.git}"
ROBOT_ID="jarvis-main"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --robot-id)
      ROBOT_ID="${2:-}"
      shift 2
      ;;
    --repo-url)
      REPO_URL="${2:-}"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ $EUID -ne 0 ]]; then
  echo "Run as root: sudo bash $0 [--robot-id <id>] [--repo-url <url>]"
  exit 1
fi

if [[ -z "$ROBOT_ID" ]]; then
  echo "robot-id is empty"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y git python3 python3-venv ca-certificates

mkdir -p "$APP_ROOT"
if [[ ! -d "$APP_ROOT/repo/.git" ]]; then
  git clone "$REPO_URL" "$APP_ROOT/repo"
else
  git -C "$APP_ROOT/repo" fetch --all
  git -C "$APP_ROOT/repo" pull --ff-only
fi

python3 -m venv "$APP_ROOT/.venv"
"$APP_ROOT/.venv/bin/pip" install --upgrade pip
"$APP_ROOT/.venv/bin/pip" install -r "$APP_ROOT/repo/local-mcp-test/mcp-calculator/requirements.txt"

install -d -m 755 "$APP_ROOT/bin" "$APP_ROOT/shared/kb/common" "$APP_ROOT/robots"
install -m 755 "$APP_ROOT/repo/scripts/platform/add_robot.sh" "$APP_ROOT/bin/add_robot.sh"
install -m 755 "$APP_ROOT/repo/scripts/platform/run_robot_bridge.sh" "$APP_ROOT/bin/run_robot_bridge.sh"
install -m 755 "$APP_ROOT/repo/scripts/platform/robotctl.sh" "$APP_ROOT/bin/robotctl.sh"
install -m 644 "$APP_ROOT/repo/scripts/platform/ai-robot-bridge@.service" /etc/systemd/system/ai-robot-bridge@.service

if [[ ! -f "$APP_ROOT/shared/kb/common/README.md" ]]; then
  cat > "$APP_ROOT/shared/kb/common/README.md" <<'EOF'
# Shared Knowledge Base

Сюда складывается общая база знаний для всех роботов.

Рекомендуемая структура:
- `common/` — общие правила и справочные документы.
- `robots/<robot-id>/` — данные только конкретного робота.
EOF
fi

APP_ROOT="$APP_ROOT" "$APP_ROOT/bin/add_robot.sh" "$ROBOT_ID"

systemctl daemon-reload
systemctl enable "ai-robot-bridge@$ROBOT_ID" >/dev/null 2>&1 || true

echo
echo "Install completed."
echo "Robot prepared: $ROBOT_ID"
echo "Set endpoint: $APP_ROOT/robots/$ROBOT_ID/mcp_endpoint.txt"
echo "Start service: systemctl start ai-robot-bridge@$ROBOT_ID"
echo "Status: systemctl status ai-robot-bridge@$ROBOT_ID"
echo "Robot manager: $APP_ROOT/bin/robotctl.sh list"
