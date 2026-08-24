# ADR-0006: Cross-Cutting Decorators

## Status
Accepted

## Date
2026-08-07

## Context

When cross-cutting behavior is explicitly enabled, a consistent implementation style keeps business logic free of infrastructure concerns. Without guidance, teams mix manual calls, global interceptors, and ad-hoc wrappers.

For AI integrations, this separation is especially important: provider adapters define *how* a model is invoked, while decorators define behavior applied around that invocation. Provider selection and routing are governed separately by [ADR-0021](ADR-0021-provider-neutral-ai-selection.md).

## Scope

Preferred *implementation mechanism* for opted-in cross-cutting concerns in FlossWare services and libraries.

## Non-goals

- Does not decide *whether* a behavior is enabled (see [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md)).
- Does not mandate a single language feature (annotations, middleware, or interceptors may all satisfy the pattern).
- Does not select an AI provider, model, deployment topology, or pricing tier (see [ADR-0021](ADR-0021-provider-neutral-ai-selection.md)).

## Decision

Cross-cutting concerns SHOULD use decorators, interceptors, or equivalent middleware patterns.

For AI components, the architectural separation SHALL be:

```text
request
  -> routing / policy
  -> provider contract
  -> cross-cutting decorators
  -> provider adapter
  -> model/runtime
```

The exact ordering MAY vary when a policy requires it, but provider-specific integration logic SHALL remain behind the provider contract and decorators SHALL NOT encode provider or pricing preferences.

Examples include:
- logging
- metrics
- tracing
- auditing
- persistence
- retries
- circuit breaking
- security/policy enforcement
- structured-output validation
- evaluation
- token/cost accounting
- caching

This decision defines the preferred *mechanism*. Activation remains governed by [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md): no cross-cutting side effect without explicit opt-in.

### Include as preferred (SHOULD)
- Annotation-driven or config-driven decorators/interceptors
- Explicit middleware registration
- Event publishers wired only when the component opts in
- AI decorators that operate against provider-neutral contracts

### Exclude as default / automatic
- Global framework interceptors that fire for every method
- Implicit persistence or auditing on entity lifecycle without an opt-in marker
- AOP that cannot be disabled per component
- Decorators that hard-code a model vendor or pricing tier

### Allowed (MAY)
- Explicit policy / strategy objects
- Manual calls to audit/metrics helpers when decorator overhead is undesirable
- Provider-specific decorators when explicitly isolated behind a provider adapter boundary

## Consequences

### Positive
- Business logic remains focused while operational behavior stays consistent.
- Provider integration, routing policy, and cross-cutting behavior remain independently evolvable.
- The same resilience, security, observability, and evaluation behavior can wrap different providers.
- Opt-in policy and mechanism stay independently evolvable.

### Negative
- Decorator stacks can become hard to reason about if overused.
- Language/runtime support for clean decorators varies.
- Ordering matters for some policies and must be documented when material.

## Alternatives Considered

### Global automatic interceptors
Rejected as default — violates explicit opt-in ([ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md)).

### Manual infrastructure calls only
Rejected as the primary style — scatters cross-cutting logic and reduces consistency.

### Decorators/middleware with opt-in activation (chosen)
Preserves modularity and consistency while keeping provider integration separate from cross-cutting behavior.

## Related ADRs
- [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md) — Explicit Opt-In Cross-Cutting Behavior (activation policy)
- [ADR-0005](ADR-0005-event-driven-internal-bus.md) — Event-Driven Internal Bus
- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
- [ADR-0021](ADR-0021-provider-neutral-ai-selection.md) — Provider-Neutral AI Selection
