# Email Integration (IMAP)

## Goal
Allow agent to read unread emails using local MCP tool.

## Implemented Tool
- File: `tools_email.py`
- Tool: `email_list_unread(limit=5)`
- Method: IMAP SSL login, `UNSEEN` search, returns metadata list.

## Required Environment Variables
- `MAIL_USER` — mailbox login (email address).
- `MAIL_PASS` — app password (not primary account password).
- `IMAP_HOST` — IMAP server hostname.
- `IMAP_BOX` — folder name (usually `INBOX`).

## Notes About Common Mistakes
- `IMAP_BOX` is not a port; it is folder name.
- Do not put spaces around `=` in shell exports.
- Copy-paste from messenger can inject hidden characters.

## Current Validation Result
A direct IMAP check was executed and returned:
- `ok: true`
- unread count detected.

This confirms credentials + host + folder combination is valid.

## Practical Voice Tests
- "Show my 3 unread emails"
- "Check unread mail"

## Security Reminder
Treat `MAIL_PASS` as secret. Rotate if ever exposed.

