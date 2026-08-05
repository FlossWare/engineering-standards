# ADR-0001: Explicit Opt-In Cross-Cutting Infrastructure Behavior

## Status

Accepted

## Date

2026-07-31

## Context

FlossWare consists of modular services that may require cross-cutting capabilities such as:

- event publication
- auditing
- metrics
- tracing
- persistence integration
- notifications
- workflow triggers

A common framework pattern is to enable these behaviors globally by default. While convenient initially, this creates hidden coupling between components and makes system behavior difficult to understand, test, and operate.

FlossWare requires a modular architecture where components can be used independently and where infrastructure behavior is intentionally selected.

## Decision

FlossWare components will follow an explicit opt-in model.

The default behavior of any component or library is:

- no event publication
- no automatic auditing
- no automatic metrics
- no implicit persistence
- no hidden external side effects

Cross-cutting behaviors MUST be explicitly enabled by the developer.

Examples:

```java
@PublishEvent("pxe.install.completed.v1")
public void completeInstall() {
}
```

```java
@Audit
public void removeImage() {
}
```

## Event Contract Model

When events are used, they MUST conform to versioned contracts.

Events consist of:

- a common envelope
- a versioned event type
- a defined payload schema

Example:

```json
{
  "id": "uuid",
  "version": "1.0",
  "type": "pxe.boot.started.v1",
  "source": "pxe-controller",
  "timestamp": "2026-07-31T19:45:00Z",
  "correlationId": "job-12345",
  "payload": {}
}
```

Event schemas are maintained independently from implementations and are treated as public contracts between services.

## Consequences

### Positive

- Components remain lightweight and reusable.
- Dependencies are explicit.
- Testing is simpler.
- Services can adopt infrastructure capabilities incrementally.
- Event-driven architecture can evolve without forcing every service into it.

### Negative

- Developers must intentionally add required behaviors.
- Teams must maintain event contracts and versions.

## Alternatives Considered

### Automatic Event Publication

Rejected.

Reason:
- Creates hidden behavior.
- Makes simple services dependent on infrastructure.
- Makes debugging more difficult.

### Global Framework Interceptors

Rejected as the default.

Reason:
- Useful in some deployments, but too implicit for the FlossWare core model.

## Implementation Guidance

FlossWare common libraries SHOULD provide optional support for:

- event contracts
- schema validation
- publishers
- subscribers
- audit handlers
- metrics handlers

These capabilities SHOULD be available but never activated without explicit configuration or annotation.

## Related ADRs

- [ADR-0005](ADR-0005-event-driven-internal-bus.md) — Event-Driven Internal Bus
- [ADR-0006](ADR-0006-cross-cutting-decorators.md) — Cross-Cutting Decorators (preferred *mechanism* when a behavior is opted in)

## Result

FlossWare services remain modular by default while still supporting sophisticated orchestration, automation, and AI-driven workflows when intentionally enabled.
