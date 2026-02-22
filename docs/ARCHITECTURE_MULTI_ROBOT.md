# Архитектура AI_ROBOT (multi-robot)

## Цель

Платформа, где:
- каждый робот запускается как отдельная единица;
- у каждого свои endpoint/профиль/настройки;
- общая база знаний используется всеми роботами.

## Схема

1. На сервере работает отдельный `systemd`-инстанс на робота:
   - `ai-robot-bridge@robot-a`
   - `ai-robot-bridge@robot-b`
2. Каждый инстанс читает свои файлы:
   - `/opt/ai_robot/robots/<robot-id>/mcp_endpoint.txt`
   - `/opt/ai_robot/robots/<robot-id>/robot.env`
   - `/opt/ai_robot/robots/<robot-id>/profile.md`
   - `/opt/ai_robot/robots/<robot-id>/mcp_config.json`
3. Все инстансы используют общую KB:
   - `/opt/ai_robot/shared/kb/common/*`
   - `/opt/ai_robot/shared/kb/robots/<robot-id>/*`
4. MCP tools:
   - `tools_simple.py` — базовые тестовые инструменты.
   - `tools_email.py` — почтовая интеграция (по необходимости).
   - `tools_knowledge.py` — поиск/чтение знаний из общей KB.

## Принципы

- Изоляция по robot-id.
- Общие знания — централизованно.
- Секреты не хранятся в git.
- Управление через `systemd` и скрипт `robotctl.sh`.
