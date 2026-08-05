# ADR-0003: No Local Inference by Default

> Formerly `docs/architecture/decisions/ADR-0002-no-local-inference-default.md`

## Status
Accepted

## Date
2026-07-31

## Context
AI systems should remain usable across small infrastructure, cloud environments, and developer workstations.

## Decision
Local inference SHALL NOT be the default execution path. Systems SHALL prefer configured providers and use local models only when explicitly enabled.

## Consequences
- Lower infrastructure requirements.
- Easier deployment.
- Hardware becomes an optimization option rather than a prerequisite.

## Related ADRs
- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
