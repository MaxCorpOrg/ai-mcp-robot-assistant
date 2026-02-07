from datetime import datetime
from fastmcp import FastMCP

mcp = FastMCP("LocalSimpleTools")


@mcp.tool()
def ping() -> dict:
    """Quick health check tool."""
    return {"ok": True, "service": "local-simple-tools"}


@mcp.tool()
def now_local() -> dict:
    """Current local date/time on Linux host."""
    now = datetime.now()
    return {
        "ok": True,
        "iso": now.isoformat(timespec="seconds"),
        "date": now.strftime("%Y-%m-%d"),
        "time": now.strftime("%H:%M:%S"),
    }


@mcp.tool()
def say(text: str) -> dict:
    """Echo text back. Useful to verify argument passing."""
    return {"ok": True, "echo": text}


if __name__ == "__main__":
    mcp.run(transport="stdio")
