# Security and Secrets

## Threat Model (Practical)
The system contains high-value credentials:
- MCP endpoint token.
- Email app password.
- Potential third-party API keys.

If leaked, attacker may:
- Use MCP endpoint access.
- Read mailbox metadata/content.
- Trigger unintended external actions via tools.

## Current Secret Locations
- `mcp_endpoint.txt` (local bridge directory).
- `mail_env.sh` (local bridge directory).

Permissions were set restrictively (`chmod 600`), but this is still plaintext.

## Minimum Security Baseline
1. Rotate secrets if ever posted in chat/screenshots.
2. Keep secrets out of git.
3. Use per-service least-privilege credentials.
4. Confirm app-password policies at provider side.

## Recommended Upgrades
- Move secrets to password manager + runtime export.
- Optional: use `pass`, `keyring`, or systemd environment files with strict perms.
- Add a "secrets rotation checklist" every quarter.

## Do Not Do
- Hardcode secrets in Python source.
- Share endpoint token in screenshots.
- Reuse same credentials across unrelated tools.

## Operational Discipline
Treat this robot stack as a production integration system, not as a toy script.

