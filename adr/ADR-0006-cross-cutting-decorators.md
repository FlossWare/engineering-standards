# ADR-0006: Cross-Cutting Decorators

## Status
Accepted

## Date
2026-08-07

## Context

When cross-cutting behavior is explicitly enabled, a consistent implementation style keeps business logic free of infrastructure concerns. Without guidance, teams mix manual calls, global interceptors, and ad-hoc wrappers.

## Scope

Preferred *implementation mechanism* for opted-in cross-cutting concerns in FlossWare services and libraries.

## Non-goals

- Does not decide *whether* a behavior is enabled (see [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md)).
- Does not mandate a single language feature (annotations, middleware, or interceptors may all satisfy the pattern).

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

### Include as preferred (SHOULD)
- Annotation-driven or config-driven decorators/interceptors
- Explicit middleware registration
- Event publishers wired only when the component opts in

### Exclude as default / automatic
- Global framework interceptors that fire for every method
- Implicit persistence or auditing on entity lifecycle without an opt-in marker
- AOP that cannot be disabled per component

### Allowed (MAY)
- Explicit policy / strategy objects
- Manual calls to audit/metrics helpers when decorator overhead is undesirable

## Consequences

### Positive
- Business logic remains focused while operational behavior stays consistent.
- Opt-in policy and mechanism stay independently evolvable.

### Negative
- Decorator stacks can become hard to reason about if overused.
- Language/runtime support for clean decorators varies.

## Alternatives Considered

### Global automatic interceptors
Rejected as default — violates explicit opt-in ([ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md)).

### Manual infrastructure calls only
Rejected as the primary style — scatters cross-cutting logic and reduces consistency.

### Decorators/middleware with opt-in activation (chosen)
Preserves modularity and consistency.

## Related ADRs
- [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md) — Explicit Opt-In Cross-Cutting Behavior (activation policy)
- [ADR-0005](ADR-0005-event-driven-internal-bus.md) — Event-Driven Internal Bus
