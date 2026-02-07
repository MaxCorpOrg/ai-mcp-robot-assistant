# Project Context

## What This Project Is
This is a hybrid robot system:
- Hardware execution on ESP32-S3 (audio I/O, display, servos, network client).
- AI intelligence in the cloud (LLM/ASR/TTS behavior is server-side).
- Optional local MCP extensions on Linux host for extra capabilities (email, weather, custom APIs).

## Core Product Goal
Build a practical OTTO-like companion robot that:
- Responds by voice.
- Uses expressive movement.
- Can be extended with external tools and services.
- Is maintainable and evolvable without constant reflashing.

## Why This Architecture
### Reasoning
- ESP32 is good at deterministic I/O, motion, and protocol handling.
- LLM/ASR/TTS are better hosted remotely for quality and scalability.
- MCP gives a clean extension interface for adding local or remote tool capabilities.

### Intended Benefits
- Fast iteration on behavior (prompt changes in cloud).
- Safe hardware control boundaries (tool-based calls).
- Progressive scaling from toy setup to full private stack.

## Current Working State
- Robot is physically connected and already controlled by voice commands.
- Cloud-side role instructions are actively used.
- Local MCP bridge is deployed and connected to XiaoZhi MCP endpoint.
- Email integration path exists and IMAP connectivity has been tested.

## Strategic Objective
Move from "working demo" to "reliable personal platform" by:
1. Stabilizing operations.
2. Hardening security.
3. Expanding tool ecosystem.
4. Optionally migrating from official cloud to self-hosted backend.

