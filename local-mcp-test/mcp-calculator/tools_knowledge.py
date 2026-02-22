from __future__ import annotations

import os
import re
from datetime import datetime
from pathlib import Path

from fastmcp import FastMCP

mcp = FastMCP("SharedKnowledgeTools")

ALLOWED_SUFFIXES = {".md", ".txt", ".json"}
MAX_FILE_BYTES = 512 * 1024
MAX_FILES = 2000


def _kb_root() -> Path:
    raw = os.getenv("KB_ROOT", "/opt/ai_robot/shared/kb").strip()
    return Path(raw).expanduser().resolve()


def _robot_profile_path() -> Path | None:
    raw = os.getenv("ROBOT_PROFILE_PATH", "").strip()
    if not raw:
        return None
    return Path(raw).expanduser().resolve()


def _iter_docs():
    root = _kb_root()
    if not root.exists():
        return []
    docs = []
    for path in sorted(root.rglob("*")):
        if len(docs) >= MAX_FILES:
            break
        if not path.is_file():
            continue
        if path.suffix.lower() not in ALLOWED_SUFFIXES:
            continue
        try:
            if path.stat().st_size > MAX_FILE_BYTES:
                continue
        except OSError:
            continue
        docs.append(path)
    return docs


def _safe_rel_path(user_path: str) -> Path:
    cleaned = user_path.strip().replace("\\", "/")
    if not cleaned:
        raise ValueError("path is empty")
    rel = Path(cleaned)
    if rel.is_absolute():
        raise ValueError("absolute path is not allowed")
    if ".." in rel.parts:
        raise ValueError("parent path traversal is not allowed")
    return rel


def _read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore")


def _tokens(query: str):
    return [t for t in re.split(r"\W+", query.lower()) if len(t) >= 2]


def _snippet(text: str, terms, max_chars: int) -> str:
    if not text:
        return ""
    text_l = text.lower()
    pos = -1
    for term in terms:
        found = text_l.find(term)
        if found >= 0 and (pos == -1 or found < pos):
            pos = found
    if pos == -1:
        pos = 0
    start = max(0, pos - max_chars // 3)
    end = min(len(text), start + max_chars)
    return text[start:end].strip()


@mcp.tool()
def kb_list_documents(limit: int = 50) -> dict:
    """List documents available in shared knowledge base."""
    limit = max(1, min(limit, 200))
    root = _kb_root()
    docs = _iter_docs()
    rel = [str(p.relative_to(root)) for p in docs[:limit]]
    return {"ok": True, "kb_root": str(root), "count": len(rel), "documents": rel}


@mcp.tool()
def kb_search(query: str, max_results: int = 5, max_chars: int = 900) -> dict:
    """Keyword search across shared knowledge base files."""
    query = query.strip()
    if not query:
        return {"ok": False, "error": "query is empty"}
    max_results = max(1, min(max_results, 20))
    max_chars = max(200, min(max_chars, 4000))
    terms = _tokens(query)
    if not terms:
        return {"ok": False, "error": "query tokens are empty"}

    root = _kb_root()
    results = []
    for path in _iter_docs():
        try:
            text = _read_text(path)
        except OSError:
            continue
        lowered = text.lower()
        score = sum(lowered.count(term) for term in terms)
        if score <= 0:
            continue
        results.append(
            {
                "path": str(path.relative_to(root)),
                "score": score,
                "snippet": _snippet(text, terms, max_chars),
            }
        )
    results.sort(key=lambda x: x["score"], reverse=True)
    return {
        "ok": True,
        "query": query,
        "kb_root": str(root),
        "count": len(results[:max_results]),
        "results": results[:max_results],
    }


@mcp.tool()
def kb_read_document(path: str, max_chars: int = 3000) -> dict:
    """Read a specific KB document by relative path."""
    max_chars = max(200, min(max_chars, 12000))
    root = _kb_root()
    try:
        rel = _safe_rel_path(path)
    except ValueError as exc:
        return {"ok": False, "error": str(exc)}

    full = (root / rel).resolve()
    if not str(full).startswith(str(root)):
        return {"ok": False, "error": "path is outside KB root"}
    if not full.exists() or not full.is_file():
        return {"ok": False, "error": "document not found"}
    if full.suffix.lower() not in ALLOWED_SUFFIXES:
        return {"ok": False, "error": "file type is not allowed"}

    try:
        text = _read_text(full)
    except OSError as exc:
        return {"ok": False, "error": str(exc)}
    return {
        "ok": True,
        "path": str(rel),
        "updated_at": datetime.fromtimestamp(full.stat().st_mtime).isoformat(),
        "content": text[:max_chars],
    }


@mcp.tool()
def kb_robot_profile(max_chars: int = 3000) -> dict:
    """Read robot profile for the current robot instance."""
    max_chars = max(200, min(max_chars, 12000))
    profile = _robot_profile_path()
    if profile is None:
        return {"ok": False, "error": "ROBOT_PROFILE_PATH is not configured"}
    if not profile.exists() or not profile.is_file():
        return {"ok": False, "error": "robot profile file not found"}
    try:
        text = _read_text(profile)
    except OSError as exc:
        return {"ok": False, "error": str(exc)}
    return {"ok": True, "path": str(profile), "content": text[:max_chars]}


if __name__ == "__main__":
    mcp.run(transport="stdio")
