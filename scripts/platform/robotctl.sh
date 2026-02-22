#!/usr/bin/env bash
set -euo pipefail

APP_ROOT="${APP_ROOT:-/opt/ai_robot}"
ACTION="${1:-help}"
ROBOT_ID="${2:-}"

usage() {
  cat <<'EOF'
Usage:
  robotctl.sh list
  robotctl.sh add <robot-id>
  robotctl.sh start <robot-id>
  robotctl.sh stop <robot-id>
  robotctl.sh restart <robot-id>
  robotctl.sh status <robot-id>
  robotctl.sh logs <robot-id>
EOF
}

require_robot_id() {
  if [[ -z "$ROBOT_ID" ]]; then
    echo "Robot id is required"
    exit 1
  fi
}

list_robots() {
  local robots_dir="$APP_ROOT/robots"
  if [[ ! -d "$robots_dir" ]]; then
    echo "No robots directory: $robots_dir"
    return
  fi

  printf "%-24s %-12s %-12s\n" "ROBOT" "ENDPOINT" "SERVICE"
  for dir in "$robots_dir"/*; do
    [[ -d "$dir" ]] || continue
    local id endpoint_file endpoint_state service_state
    id="$(basename "$dir")"
    endpoint_file="$dir/mcp_endpoint.txt"
    endpoint_state="missing"
    if [[ -f "$endpoint_file" ]]; then
      if grep -q "REPLACE_WITH_ROBOT_TOKEN" "$endpoint_file"; then
        endpoint_state="placeholder"
      elif [[ -n "$(tr -d '\r\n' < "$endpoint_file")" ]]; then
        endpoint_state="configured"
      fi
    fi
    if systemctl is-active --quiet "ai-robot-bridge@$id"; then
      service_state="active"
    else
      service_state="inactive"
    fi
    printf "%-24s %-12s %-12s\n" "$id" "$endpoint_state" "$service_state"
  done
}

case "$ACTION" in
  list)
    list_robots
    ;;
  add)
    require_robot_id
    "$APP_ROOT/bin/add_robot.sh" "$ROBOT_ID"
    ;;
  start|stop|restart|status)
    require_robot_id
    systemctl "$ACTION" "ai-robot-bridge@$ROBOT_ID"
    ;;
  logs)
    require_robot_id
    journalctl -u "ai-robot-bridge@$ROBOT_ID" -n 200 -f
    ;;
  help|--help|-h)
    usage
    ;;
  *)
    usage
    exit 1
    ;;
esac
