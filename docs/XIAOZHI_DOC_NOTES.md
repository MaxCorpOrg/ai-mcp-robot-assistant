# Заметки по документации xiaozhi-esp32

Источник: `https://github.com/78/xiaozhi-esp32`

## Ключевые выводы

1. Устройство поддерживает MCP и может расширяться через cloud-side MCP tools.
2. Поддержаны протоколы WebSocket и MQTT+UDP.
3. Для self-hosted backend в README перечислены отдельные серверные проекты.
4. Рекомендуемый путь для нашего этапа: не трогать firmware-ветку, а развивать серверный MCP слой и знания.

## Что это значит для MAX_CORP

- Оставляем совместимость с XiaoZhi MCP.
- Строим собственный серверный слой в Linux:
  - отдельный runtime на каждого робота;
  - общая KB;
  - управляемые сервисы и runbook.

## Полезные разделы upstream

- `README.md` — общая модель и ссылки на server implementations.
- `docs/websocket.md` — handshake/headers/message flow.
- `docs/mcp-usage.md` — структура `tools/list` и `tools/call`.
