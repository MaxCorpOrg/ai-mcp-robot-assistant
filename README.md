# AI_ROBOT Platform (MAX_CORP)

Платформа для роботов на базе XiaoZhi + MCP, с раздельными профилями роботов и общей базой знаний.

## Что уже реализовано

- Многороботный runtime на сервере (`systemd` template `ai-robot-bridge@.service`).
- Каждый робот запускается отдельно (`robot_id`) со своим:
  - `mcp_endpoint.txt`
  - `robot.env`
  - `profile.md`
  - `mcp_config.json`
- Общая база знаний для всех роботов: `/opt/ai_robot/shared/kb`.
- MCP-инструмент `tools_knowledge.py` для поиска и чтения из общей KB.
- Скрипты управления:
  - `scripts/platform/install_maxcorp_server.sh`
  - `scripts/platform/add_robot.sh`
  - `scripts/platform/robotctl.sh`

## Быстрый запуск на сервере

См. `docs/DEPLOY_MAX_CORP_SERVER.md`.

Коротко:

```bash
git clone git@github.com:MaxCorpOrg/ai-mcp-robot-assistant.git
cd ai-mcp-robot-assistant
sudo bash scripts/platform/install_maxcorp_server.sh --robot-id jarvis-main
sudo nano /opt/ai_robot/robots/jarvis-main/mcp_endpoint.txt
sudo systemctl restart ai-robot-bridge@jarvis-main
```

## Документация

- `docs/ARCHITECTURE_MULTI_ROBOT.md` — архитектура "отдельные роботы + общая KB".
- `docs/DEPLOY_MAX_CORP_SERVER.md` — пошаговый деплой на Ubuntu 24.04.
- `docs/XIAOZHI_DOC_NOTES.md` — выжимка по официальной документации `xiaozhi-esp32`.
