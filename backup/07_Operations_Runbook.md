# Operations Runbook

## Start Bridge
```bash
bash /home/max/AI_ROBOT/local-mcp-test/mcp-calculator/start_bridge.sh
```

## Stop Bridge
```bash
bash /home/max/AI_ROBOT/local-mcp-test/mcp-calculator/stop_bridge.sh
```

## Live Logs
```bash
tail -f /home/max/AI_ROBOT/local-mcp-test/mcp-calculator/mcp_bridge.log
```

## Process Health Check
```bash
ps -ef | rg "mcp_pipe.py|tools_simple.py|tools_email.py" | rg -v rg
```

Expected:
- one `mcp_pipe.py`
- one `tools_simple.py`
- one `tools_email.py`

## Update Email Credentials
1. Edit `mail_env.sh`.
2. Restart bridge.
3. Validate via voice command + logs.

## Failure Patterns and Fixes
### Symptom: no tool response
- Check bridge process exists.
- Check endpoint token validity.
- Check log for reconnect loop.

### Symptom: email tool fails
- Validate IMAP host.
- Confirm app password is active.
- Confirm box name is `INBOX`.

### Symptom: duplicate bridge processes
- Run `stop_bridge.sh` (it includes cleanup).
- Start once.

## Decision Rule
Always fix ops issues from runbook first, then debug deeper code.

