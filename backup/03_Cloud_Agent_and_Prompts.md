# Cloud Agent and Prompt Strategy

## Why Prompt Layer Matters
Prompt layer is currently the fastest control surface.
It governs:
- Action policy (when to move, how often to move).
- Tone and persona.
- Tool usage style and safety constraints.

## Current Style Direction
A "quiet" mode was requested:
- Less random movement.
- Motion only when user asks or context strongly suggests it.
- Conservative movement parameters.

## Recommended Prompt Design Pattern
1. Identity and boundaries.
2. Tool policy (allowed tools + parameter ranges).
3. Priority rules (explicit user commands override random behavior).
4. Safety fallback behavior.
5. Response style constraints.

## Practical Prompt Rules (Suggested)
- Never invent non-existent tools.
- Use only known `self.otto.*` tools.
- Keep motion minimal unless explicitly asked.
- Call `self.otto.stop` before interrupting queued action flow.
- Use short post-action speech.

## Why This Works
- Reduces unintended servo wear.
- Improves predictability for user.
- Limits accidental "show-mode" behavior.

## Long-Term Prompt Goal
Split prompts by profile:
- `quiet` profile (daily use).
- `show` profile (demo/event mode).
- `maintenance` profile (diagnostic language and strict tools).

