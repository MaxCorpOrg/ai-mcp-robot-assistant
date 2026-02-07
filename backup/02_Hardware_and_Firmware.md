# Hardware and Firmware

## Hardware Profile
- Robot class: OTTO humanoid variant.
- MCU: ESP32-S3 / ESP32-S3-WROOM-1.
- Network: Wi-Fi 2.4GHz.
- Display: 240x240 (ST7789 family in board config).
- Actuators: servo-based limbs (legs, feet, optional hands).
- Audio: mic + speaker (voice in/out).
- AI chip: no ML307 required in this setup.

## Firmware Project
Repository path:
- `/home/max/AI_ROBOT/xiaozhi-esp32`

Board profile used:
- `BOARD_TYPE_OTTO_ROBOT` in `main/Kconfig.projbuild`.
- Board config at `main/boards/otto-robot`.

## Firmware Role in System
Firmware responsibilities:
- Device state machine.
- Networking and provisioning.
- Audio pipeline transport.
- Servo and display control.
- MCP tools registration for robot actions.

Firmware does NOT run heavy LLM inference.

## When Reflashing Is Required
Reflash only when changing firmware-level logic, for example:
- New motion primitives in `otto_movements.cc`.
- New/changed MCP tools in `otto_controller.cc`.
- Board pin mapping or low-level drivers.

No reflash needed for:
- Prompt/persona updates.
- Cloud behavior changes.
- Most tool logic running in local MCP bridge.

## Operational Advice
- Keep one stable firmware baseline.
- Version control every behavior change in prompt docs.
- Reflash only with explicit purpose and rollback plan.

