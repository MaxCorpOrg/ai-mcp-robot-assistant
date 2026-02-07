# Backup Index: XiaoZhi OTTO Project

This folder is a transfer package for moving the project context to another ChatGPT account.

## Purpose
- Preserve the current technical state.
- Preserve intent, goals, and engineering direction.
- Enable fast restart in a new account without losing decisions.

## Files
1. `01_Project_Context.md` — project scope, architecture, what is already working.
2. `02_Hardware_and_Firmware.md` — hardware profile, firmware board config, flashing rules.
3. `03_Cloud_Agent_and_Prompts.md` — cloud-side behavior design and prompt strategy.
4. `04_Local_MCP_Bridge.md` — local MCP bridge setup and current runtime layout.
5. `05_Email_Integration.md` — IMAP integration details and verification flow.
6. `06_Security_and_Secrets.md` — security model, token/password handling, rotation policy.
7. `07_Operations_Runbook.md` — start/stop/debug runbook for daily operations.
8. `08_Roadmap_and_Improvement_Ideas.md` — development direction and priorities.
9. `09_Migration_Checklist_New_Account.md` — step-by-step migration checklist.
10. `10_Known_Issues_and_Decisions.md` — known constraints, accepted tradeoffs, open questions.

## Recommended Read Order
1. `01_Project_Context.md`
2. `02_Hardware_and_Firmware.md`
3. `04_Local_MCP_Bridge.md`
4. `05_Email_Integration.md`
5. `07_Operations_Runbook.md`
6. `06_Security_and_Secrets.md`
7. `08_Roadmap_and_Improvement_Ideas.md`
8. `09_Migration_Checklist_New_Account.md`
9. `10_Known_Issues_and_Decisions.md`

## Current Snapshot (Short)
- Device: OTTO humanoid robot (ESP32-S3) with XiaoZhi firmware.
- Cloud mode in use (official XiaoZhi backend), with custom behavior prompts.
- Local MCP bridge deployed in `local-mcp-test/mcp-calculator`.
- Local tools active: basic tools + email tools.
- IMAP login test completed successfully.

