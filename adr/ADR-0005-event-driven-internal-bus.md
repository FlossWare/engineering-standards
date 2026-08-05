# ADR-0005: Event Driven Internal Bus

> Formerly `docs/architecture/decisions/ADR-0004-event-driven-internal-bus.md`

## Status
Accepted

## Date
2026-07-31

## Context
FlossWare services need asynchronous integration without tight coupling between producers and consumers.

## Decision
Internal integrations SHOULD use versioned events and pub/sub contracts where asynchronous communication improves modularity.

## Consequences
- Services remain loosely coupled.
- New consumers can subscribe without changing producers.
- Event schemas become managed contracts.

## Related ADRs
- [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md) — Explicit Opt-In Cross-Cutting Behavior (event contract model)
