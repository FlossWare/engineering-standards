# ADR-0006: Cross Cutting Decorators

> Formerly `docs/architecture/decisions/ADR-0005-cross-cutting-decorators.md`

## Status
Accepted

## Date
2026-07-31

## Context
When cross-cutting behavior is explicitly enabled, a consistent implementation style keeps business logic free of infrastructure concerns.

## Decision
Cross-cutting concerns SHOULD use decorators, interceptors, or equivalent middleware patterns.

Examples include:
- logging
- metrics
- tracing
- auditing
- persistence
- retries

This decision defines the preferred *mechanism*. Activation remains governed by [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md): no cross-cutting side effect without explicit opt-in.

## Consequences
Business logic remains focused while operational behavior stays consistent.

## Related ADRs
- [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md) — Explicit Opt-In Cross-Cutting Behavior (activation policy)
