# ADR-0005: Event Driven Internal Bus

> Formerly `docs/architecture/decisions/ADR-0004-event-driven-internal-bus.md`

## Status
Accepted

## Date
2026-07-31

## Context

FlossWare services need asynchronous integration without tight coupling between producers and consumers. Synchronous chains create fragility and block independent evolution. Event publication remains subject to [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md) (explicit opt-in).

## Decision

Internal integrations SHOULD use versioned events and pub/sub contracts where asynchronous communication improves modularity.

### Baseline guarantees
- **Delivery:** at-least-once
- **Ordering:** per-partition / per-aggregate key where the broker supports it; no global ordering assumption
- **Idempotency:** consumers SHALL tolerate duplicates (idempotency keys or natural keys)
- **Retries:** bounded retries with backoff; poison messages → dead-letter topic/queue
- **Schema evolution:** events are versioned (`type` + `version`); producers MAY add optional fields; breaking changes require a new versioned type
- **Publish failure:** producers SHALL treat publish failure as operation failure unless a specific event class is documented as fire-and-forget

Broker technology (Kafka, NATS, RabbitMQ, cloud buses, in-process for tests) SHOULD remain an implementation detail behind the contract.

Event envelope and versioning follow the model in [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md).

## Consequences

### Positive
- Services remain loosely coupled.
- New consumers can subscribe without changing producers.
- Event schemas become managed contracts.

### Negative
- Operational complexity (DLQ, replay, monitoring).
- Eventual consistency requires careful UX and API design.
- Duplicate delivery forces idempotent consumers.

## Alternatives Considered

### Synchronous-only integration
Rejected as the sole model — increases coupling and reduces independent deployability.

### Exactly-once as platform guarantee
Rejected as a default platform claim — expensive and broker-specific; at-least-once + idempotent consumers is more portable.

### Shared database as integration bus
Rejected — hidden coupling and schema ownership conflicts.

## Related ADRs
- [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md) — Explicit Opt-In Cross-Cutting Behavior
- [ADR-0006](ADR-0006-cross-cutting-decorators.md) — Cross-Cutting Decorators
