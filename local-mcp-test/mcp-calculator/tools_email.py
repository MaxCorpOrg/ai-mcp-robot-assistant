import os
import imaplib
import email
from fastmcp import FastMCP

mcp = FastMCP("LocalEmailTools")


def _env(name: str, default: str = "") -> str:
    val = os.getenv(name, default).strip()
    return val


@mcp.tool()
def email_list_unread(limit: int = 5) -> dict:
    """List latest unread emails from IMAP inbox."""
    user = _env("MAIL_USER")
    password = _env("MAIL_PASS")
    host = _env("IMAP_HOST", "imap.gmail.com")
    box = _env("IMAP_BOX", "INBOX")

    if not user or not password:
        return {
            "ok": False,
            "error": "MAIL_USER/MAIL_PASS not set",
            "hint": "Use app-password for Gmail/Outlook, not your main account password",
        }

    try:
        limit = max(1, min(limit, 20))
        conn = imaplib.IMAP4_SSL(host)
        conn.login(user, password)
        conn.select(box)

        typ, data = conn.search(None, "UNSEEN")
        if typ != "OK":
            conn.logout()
            return {"ok": False, "error": "IMAP search failed"}

        ids = data[0].split()[-limit:]
        result = []

        for msg_id in ids:
            typ, msg_data = conn.fetch(msg_id, "(RFC822)")
            if typ != "OK" or not msg_data or not msg_data[0]:
                continue

            msg = email.message_from_bytes(msg_data[0][1])
            result.append(
                {
                    "from": str(msg.get("From", "")),
                    "subject": str(msg.get("Subject", "")),
                    "date": str(msg.get("Date", "")),
                }
            )

        conn.close()
        conn.logout()

        return {"ok": True, "count": len(result), "emails": result}
    except Exception as e:
        return {"ok": False, "error": str(e)}


if __name__ == "__main__":
    mcp.run(transport="stdio")
