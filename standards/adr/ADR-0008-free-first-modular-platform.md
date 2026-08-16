# ADR-0008: Free-First Modular Platform

## Status
Accepted

## Date
2026-08-07

## Context

FlossWare aims to stay accessible to individuals and small teams while remaining capable enough for serious infrastructure automation. Defaulting to commercial services raises cost and lock-in; forbidding them entirely blocks justified quality or capability gaps.

## Scope

Default posture for selecting open/free vs commercial components across FlossWare repositories.

## Non-goals

- Does not ban commercial components.
- Does not rank specific products.

## Decision

FlossWare designs SHALL prefer free, open, modular components while preserving the ability to integrate commercial services when justified.

### Principles
- Modular by default.
- Contracts over implementations.
- Capabilities over dependencies.
- No unnecessary infrastructure requirements.

### When commercial / paid MAY be justified
Document the rationale when adopting a non-free component. Typical justifications:
- No adequate free alternative for a required capability
- Material reliability, security, or compliance gap in free options
- Clear total-cost advantage after ops labor is included
- Temporary bridge with a tracked exit path to a free/open option

## Consequences

### Positive
- Platform remains accessible, adaptable, and maintainable.
- Avoids accidental lock-in.

### Negative
- Free components may need more integration work.
- Teams must resist convenience-driven paid defaults without rationale.

## Alternatives Considered

### Commercial-first
Rejected — conflicts with accessibility and free-first mission.

### Free-only (no commercial allowed)
Rejected — too rigid when quality/compliance gaps are real.

### Free-first with explicit justification for paid (chosen)
Balances mission with pragmatism.

## Related ADRs
- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
- [ADR-0003](ADR-0003-no-local-inference-default.md) — No Local Inference by Default
