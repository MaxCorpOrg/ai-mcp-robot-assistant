# Migration Checklist to New ChatGPT Account

## Objective
Recreate full project context and operational capability in another account with minimal loss.

## Step 1: Transfer Documentation
- Copy entire `/home/max/AI_ROBOT/backup` folder.
- Start new account conversation with `00_INDEX.md` first.

## Step 2: Re-establish Workspace Context
- Confirm repository paths:
  - `/home/max/AI_ROBOT/xiaozhi-esp32`
  - `/home/max/AI_ROBOT/local-mcp-test/mcp-calculator`

## Step 3: Re-validate Local MCP Stack
- Run `start_bridge.sh`.
- Confirm processes and logs.
- Run voice tests for simple tool and email read.

## Step 4: Secrets Hygiene During Migration
- Rotate MCP endpoint token.
- Rotate email app password if previously exposed.
- Update `mcp_endpoint.txt` and `mail_env.sh`.

## Step 5: Prompt Migration
- Port quiet-mode prompt into cloud role config.
- Re-test motion behavior quality.

## Step 6: Regression Test List
- voice command to action mapping.
- stop command behavior.
- unread email query.
- non-command chat behavior (quiet mode should stay calm).

## Step 7: Confirm Open Decisions
- whether to keep official cloud or move self-hosted.
- whether to add send-email and weather tools now or later.

## Definition of Done
- New account can operate robot and local tools without relying on old chat history.

