# ADR-0001: Explicit Opt-In Cross-Cutting Infrastructure Behavior

## Status

Accepted

## Date

2026-08-07

## Context

FlossWare consists of modular services that may require cross-cutting capabilities such as event publication, auditing, metrics, tracing, persistence integration, notifications, workflow triggers, and agent-facing tool exposure.

A common framework pattern is to enable these behaviors globally by default. While convenient initially, this creates hidden coupling between components and makes system behavior difficult to understand, test, and operate.

The same problem appears beyond runtime annotations: a dependency on the classpath, a build plugin, a deployment profile, or an MCP server can silently activate behavior. FlossWare requires modular architecture where components can be used independently and infrastructure behavior is intentionally selected at every layer.

## Decision

FlossWare components SHALL follow an explicit opt-in model.

**Features SHALL have explicit activation points and SHALL NOT become active solely because a component, protocol adapter, dependency, or service is present.**

### Default behavior

The default behavior of any component or library is:

- no event publication
- no automatic auditing
- no automatic metrics
- no implicit persistence
- no hidden external side effects
- no automatic MCP exposure
- no automatic authorization grant to an agent

### Opt-in applies at all layers

| Layer | Rule |
|-------|------|
| **Dependency inclusion** | Adding a library or module to the dependency graph SHALL NOT by itself enable cross-cutting side effects. The dependency MAY provide capability; activation remains separate. |
| **Build-time activation** | Build plugins, annotation processors, and code generators that inject infrastructure behavior SHALL require explicit project configuration (flags, profiles, or config files). |
| **Deployment configuration** | Runtime profiles, feature flags, and environment overlays SHALL enable capabilities only when declared. Presence of an optional service or MCP server in the environment SHALL NOT auto-wire it into every component. |
| **Runtime behavior** | Call-site annotations, explicit registration, or config-driven middleware SHALL be required before events, audit, metrics, tracing, or similar behaviors fire. |
| **Agent tools** | MCP tools SHALL require explicit exposure and authorization. Discoverability SHALL NOT imply permission to execute a tool. |

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

Cross-cutting behaviors SHALL be explicitly enabled by the developer (annotation, configuration, or registration).

## Event Contract Model

When events are used, they SHALL conform to versioned contracts.

Events consist of:

- a common **envelope**
- a **type** string identifying the domain event
- a **payload** schema for that type

### Versioning rules

| Field | Meaning |
|-------|---------|
| `envelopeVersion` | Version of the **envelope schema** (common fields such as id, type, timestamp, correlationId). Independent of domain payload evolution. |
| `type` | Stable event name. Breaking payload changes SHALL use a **new type** (e.g. `pxe.boot.started.v2`), not only a payload field bump. |
| payload schema | Defined per `type`; optional fields MAY be added in a backward-compatible way for the same type. |

Example:

```json
{
  "id": "uuid",
  "envelopeVersion": "1.0",
  "type": "pxe.boot.started.v1",
  "source": "pxe-controller",
  "timestamp": "2026-07-31T19:45:00Z",
  "correlationId": "job-12345",
  "payload": {}
}
```

Do **not** use a single ambiguous `version` field for both envelope and domain semantics. Event schemas are maintained independently from implementations and are treated as public contracts between services.

## Agent Tool Contract Model

When MCP is used, the MCP server and tool definitions are capability adapters, not implicit activation mechanisms.

- MCP exposure requires explicit configuration ([ADR-0018](ADR-0018-mcp-capability-exposure.md)).
- Tool authorization is separate from tool discovery ([ADR-0019](ADR-0019-agent-tool-security-and-authorization.md)).
- MCP adapters SHALL delegate to reusable capabilities rather than duplicate business logic ([ADR-0020](ADR-0020-capability-protocol-separation.md)).

## Consequences

### Positive

- Components remain lightweight and reusable.
- Dependencies are explicit at every lifecycle stage.
- Testing is simpler (no surprise side effects from classpath or protocol presence alone).
- Services can adopt infrastructure capabilities incrementally.
- Agent access remains explicitly controlled.

### Negative

- Developers must intentionally add required behaviors at the appropriate layer.
- Teams must maintain event and tool contracts and versions.
- Build and deploy configs need clear feature-flag documentation.

## Alternatives Considered

### Automatic Event or Tool Publication

Rejected.

Reason:
- Creates hidden behavior.
- Makes simple services dependent on infrastructure.
- Makes debugging and authorization more difficult.

### Global Framework Interceptors

Rejected as the default.

Reason:
- Useful in some deployments, but too implicit for the FlossWare core model.

### Opt-in only at runtime

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
- MCP capability adapters
- tool authorization hooks

These capabilities SHOULD be available but never activated without explicit configuration or registration.

Auto-configuration (e.g. classpath scanning that enables features by default) SHALL NOT be the default posture. If a framework offers auto-config, FlossWare integrations SHOULD disable it unless the project explicitly opts in.

## Related ADRs

- [ADR-0004](ADR-0004-mcp-tool-contracts.md) — MCP and Tool Contracts
- [ADR-0005](ADR-0005-event-driven-internal-bus.md) — Event-Driven Internal Bus
- [ADR-0006](ADR-0006-cross-cutting-decorators.md) — Cross-Cutting Decorators
- [ADR-0016](ADR-0016-configuration-as-source-of-truth.md) — Configuration as Source of Truth
- [ADR-0018](ADR-0018-mcp-capability-exposure.md) — MCP Capability Exposure
- [ADR-0019](ADR-0019-agent-tool-security-and-authorization.md) — Agent Tool Security and Authorization
- [ADR-0020](ADR-0020-capability-protocol-separation.md) — Capability and Protocol Separation

## Result

FlossWare services remain modular by default while still supporting sophisticated orchestration, automation, and AI-driven workflows when intentionally enabled.
