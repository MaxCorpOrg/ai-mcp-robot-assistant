# Деплой на MAX_CORP_SERVER (Ubuntu 24.04)

## 1) Клонирование репозитория

```bash
cd /root
git clone git@github.com:MaxCorpOrg/ai-mcp-robot-assistant.git
cd ai-mcp-robot-assistant
```

## 2) Установка платформы

```bash
sudo bash scripts/platform/install_maxcorp_server.sh --robot-id jarvis-main
```

Что создаётся:
- код: `/opt/ai_robot/repo`
- venv: `/opt/ai_robot/.venv`
- runtime: `/opt/ai_robot/robots`, `/opt/ai_robot/shared/kb`
- service: `/etc/systemd/system/ai-robot-bridge@.service`

## 3) Настройка робота

```bash
sudo nano /opt/ai_robot/robots/jarvis-main/mcp_endpoint.txt
```

Вставьте реальный endpoint с токеном (одна строка).

Опционально:

```bash
sudo nano /opt/ai_robot/robots/jarvis-main/robot.env
sudo nano /opt/ai_robot/robots/jarvis-main/profile.md
```

## 4) Запуск

```bash
sudo systemctl start ai-robot-bridge@jarvis-main
sudo systemctl status ai-robot-bridge@jarvis-main
```

Логи:

```bash
journalctl -u ai-robot-bridge@jarvis-main -f
```

## 5) Добавление второго робота

```bash
sudo APP_ROOT=/opt/ai_robot /opt/ai_robot/bin/add_robot.sh robot-02
sudo nano /opt/ai_robot/robots/robot-02/mcp_endpoint.txt
sudo systemctl enable --now ai-robot-bridge@robot-02
```

## 6) Управление

```bash
sudo /opt/ai_robot/bin/robotctl.sh list
sudo /opt/ai_robot/bin/robotctl.sh status jarvis-main
sudo /opt/ai_robot/bin/robotctl.sh logs jarvis-main
```
