# Local MCP Bridge Setup

## Purpose
Local MCP bridge connects XiaoZhi cloud endpoint to local tools running on Linux.
This is the extension layer for custom capabilities.

## Working Directory
- `/home/max/AI_ROBOT/local-mcp-test/mcp-calculator`

## Main Components
- `mcp_pipe.py` — bridge process (WebSocket <-> stdio tools).
- `mcp_config.json` — enabled/disabled local tool servers.
- `tools_simple.py` — basic test tools (`ping`, `now_local`, `say`).
- `tools_email.py` — email read tools (IMAP).
- `start_bridge.sh` / `stop_bridge.sh` — ops scripts.
- `mcp_endpoint.txt` — MCP endpoint URL with token.

## Enabled Services (Current)
In `mcp_config.json`:
- `simple-tools`: enabled.
- `email-tools`: enabled.
- example remote servers: disabled.

## Runtime Model
1. `mcp_pipe.py` opens WebSocket to MCP endpoint.
2. For each enabled server in config, starts a child tool process.
3. Bridges JSON-RPC messages between endpoint and local tool process.

## Why This Layer Is Important
- Avoids firmware changes for many features.
- Allows local-only integrations.
- Keeps logic modular and replaceable.

## Immediate Next Improvement
Move endpoint/token from plain file to safer secret storage and rotate regularly.

