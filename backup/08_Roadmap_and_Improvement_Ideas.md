# Roadmap and Improvement Ideas

## Guiding Goal
Move from "works now" to "stable, extensible personal robotics platform".

## Phase 1: Stabilization
- Keep current firmware stable.
- Keep quiet prompt mode as default.
- Build reliable MCP operations discipline.

Success criteria:
- 7+ days no unexpected bridge outages.
- predictable voice-to-action behavior.

## Phase 2: Safe Feature Expansion
- Add weather tool (local API-backed or official service fallback).
- Add email send with explicit confirmation policy.
- Add simple task/reminder tool.

Success criteria:
- New tools do not degrade robot movement reliability.

## Phase 3: Knowledge Layer
- Build structured knowledge base (docs, personal procedures, FAQs).
- Add retrieval policy so agent answers from KB first.

Success criteria:
- factual consistency improves in repeated questions.

## Phase 4: Self-Hosted Intelligence (Optional)
- Deploy own XiaoZhi-compatible backend.
- Move model/provider control fully to own infrastructure.

Success criteria:
- complete control over providers, prompts, and data retention.

## Engineering Principles
- Prefer reversible changes.
- Log and document every integration.
- Avoid hidden coupling between motion and external tool logic.

