# ADR-0016: Configuration as Source of Truth

## Status
Accepted

## Date
2026-08-05

## Context

FlossWare principle #1 states that configuration is the source of truth ([ADR-0009](ADR-0009-core-architecture-principles.md)). Without a dedicated decision record, teams interpret that loosely: hardcoded defaults, generated files treated as authoritative, or hidden config paths that make runtime behavior hard to explain.

This ADR makes the principle normative and testable.

## Scope

Applies to FlossWare services, libraries, and deployment artifacts that control runtime behavior via configuration.

## Non-goals

- Does not require a single global config format or server.
- Does not move business algorithms or multi-step workflows into configuration files.

## Decision

### Authoritative configuration

- **Declarative, reviewable configuration** SHALL be the authoritative source for system behavior (files, config services, or equivalent artifacts that can be diffed in version control or audited).
- **Runtime behavior SHOULD be explainable from configuration** — an operator ought to determine why a capability is on or off by inspecting config and explicit opt-in markers ([ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md)), not by reverse-engineering code paths alone.

### What configuration SHOULD describe

Configuration SHOULD express:

- **Intent** — desired capabilities and modes for an environment
- **Policy** — allow/deny, free-first filters, quality-gate rules
- **Topology** — endpoints, pools, service bindings
- **Enablement** — explicit feature on/off and opt-in markers
- **Operational limits** — budgets, rate limits, timeouts, quotas

### What configuration SHOULD NOT become

Configuration SHOULD NOT replace a programming language. Avoid embedding:

- **Business workflows** that span multiple systems or long-running processes
- **Algorithms** (routing math, scoring formulas beyond simple thresholds)
- **Procedural logic** (branching scripts, loops, ad-hoc code in config)

Complex behavior belongs in versioned application code or services, parameterized by declarative config.

### Defaults and activation

- **Defaults SHALL be minimal** and capabilities disabled unless explicitly enabled.
- Activation MUST NOT occur solely because a dependency is present (see ADR-0001 layers).

### Generated artifacts

- **Generated artifacts are not sources of truth.** Build outputs, generated clients, compiled bundles, and derived caches MAY be used at runtime but SHALL be reproducible from authoritative config and source.
- Pipelines SHOULD regenerate derived artifacts from source-of-truth inputs rather than hand-editing outputs.

### No hidden configuration paths

- Components SHALL NOT create hidden or undocumented configuration channels (undocumented env vars, magic files outside the project config model, or silent fallbacks that override declared config without logging).
- Optional overrides (env, flags) SHOULD be documented and layered in a defined precedence order.

### Relationship to dynamic registries

Dynamic model registries ([ADR-0015](ADR-0015-dynamic-service-discovery-ai-models.md)) MAY supply *inventory* data, but policy (which pools are allowed, free-first filters, budget limits) SHALL remain under explicit configuration owned by the deploying system.

## Consequences

### Positive

- Auditable, reviewable behavior changes via config PRs.
- Easier debugging and multi-environment promotion.
- Aligns with opt-in defaults and free-first modular design.
- Clear boundary reduces “programming in YAML/JSON” failure modes.

### Negative

- More discipline required for config schema and documentation.
- Temptation to bypass config for "just this once" hotfixes must be resisted.
- Teams must resist stuffing workflows into config for short-term convenience.

## Alternatives Considered

### Code-as-config (behavior only in source)
Rejected as sole authority — harder for operators to tune without releases; conflicts with environment-specific deployment.

### Generated files as authority
Rejected — not reviewable as intent; drifts from source.

### Configuration as general-purpose application logic
Rejected — unmaintainable, hard to test, and obscures real code ownership.

### Declarative config as authority within clear boundaries (chosen)
Matches FlossWare principles and supports explainable runtime behavior without config-as-code sprawl.

## Related ADRs

- [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md) — Explicit Opt-In
- [ADR-0009](ADR-0009-core-architecture-principles.md) — Core Architecture Principles
- [ADR-0015](ADR-0015-dynamic-service-discovery-ai-models.md) — Dynamic Service Discovery for AI Models
