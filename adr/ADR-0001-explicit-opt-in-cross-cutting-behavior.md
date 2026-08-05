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

The same problem appears beyond runtime annotations: a dependency on the classpath, a build plugin, or a deployment profile can silently activate behavior. FlossWare requires modular architecture where components can be used independently and infrastructure behavior is intentionally selected at every layer.

## Decision

FlossWare components SHALL follow an explicit opt-in model.

**Features MUST have explicit activation points and MUST NOT become active solely because a component is present.**

### Default behavior

The default behavior of any component or library is:

- no event publication
- no automatic auditing
- no automatic metrics
- no implicit persistence
- no hidden external side effects

### Opt-in applies at all layers

| Layer | Rule |
|-------|------|
| **Dependency inclusion** | Adding a library or module to the dependency graph SHALL NOT by itself enable cross-cutting side effects. The dependency MAY provide capability; activation remains separate. |
| **Build-time activation** | Build plugins, annotation processors, and code generators that inject infrastructure behavior SHALL require explicit project configuration (flags, profiles, or config files). |
| **Deployment configuration** | Runtime profiles, feature flags, and environment overlays SHALL enable capabilities only when declared. Presence of an optional service in the environment SHALL NOT auto-wire it into every component. |
| **Runtime behavior** | Call-site annotations, explicit registration, or config-driven middleware SHALL be required before events, audit, metrics, tracing, or similar behaviors fire. |

### Runtime examples

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

Cross-cutting behaviors MUST be explicitly enabled by the developer (annotation, configuration, or registration).

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
- Dependencies are explicit at every lifecycle stage.
- Testing is simpler (no surprise side effects from classpath alone).
- Services can adopt infrastructure capabilities incrementally.
- Event-driven architecture can evolve without forcing every service into it.

### Negative

- Developers must intentionally add required behaviors at the appropriate layer.
- Teams must maintain event contracts and versions.
- Build and deploy configs need clear feature-flag documentation.

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

### Opt-in only at runtime (annotations only)

Rejected as insufficient.

Reason:
- Dependency or build-time magic can still activate behavior without a runtime marker.
- Full-stack explicit activation is required for predictable modularity.

## Implementation Guidance

FlossWare common libraries SHOULD provide optional support for:

- event contracts
- schema validation
- publishers
- subscribers
- audit handlers
- metrics handlers

These capabilities SHOULD be available but never activated without explicit configuration or annotation.

Auto-configuration (e.g. classpath scanning that enables features by default) SHALL NOT be the default posture. If a framework offers auto-config, FlossWare integrations SHOULD disable it unless the project explicitly opts in.

## Related ADRs

- [ADR-0005](ADR-0005-event-driven-internal-bus.md) — Event-Driven Internal Bus
- [ADR-0006](ADR-0006-cross-cutting-decorators.md) — Cross-Cutting Decorators (preferred *mechanism* when a behavior is opted in)
- [ADR-0016](ADR-0016-configuration-as-source-of-truth.md) — Configuration as Source of Truth

## Result

FlossWare services remain modular by default while still supporting sophisticated orchestration, automation, and AI-driven workflows when intentionally enabled.
