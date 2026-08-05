# ADR-0009: Core FlossWare Architecture Principles

## Status
Accepted

## Date
2026-08-05

## Context

FlossWare spans many repositories (provisioning, AI orchestration, platforms, tools). Without shared principles, individual projects drift toward incompatible defaults, hidden coupling, and uneven quality.

## Decision

All FlossWare repositories SHALL apply the following principles:

1. **Configuration is the source of truth** — runtime behavior is driven by explicit, reviewable configuration, not hardcoded environment assumptions. See [ADR-0016](ADR-0016-configuration-as-source-of-truth.md).
2. **Defaults are minimal** — capabilities are explicitly enabled at dependency, build, deploy, and runtime layers ([ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md)).
3. **Modular and composable** — components can be used independently.
4. **Contracts over implementations** — depend on stable APIs/events/tool contracts, not concrete libraries.
5. **Free-first** — prefer free/open components; justify commercial choices ([ADR-0008](ADR-0008-free-first-modular-platform.md)).
6. **Avoid unnecessary coupling** — no hidden side effects, no shared-database integration as a default bus.
7. **Automation and repeatability** — favor infrastructure-as-code and reproducible pipelines.

## Consequences

### Positive
- Shared vocabulary for design reviews and ADRs.
- Easier cross-repo reuse and AI-assisted development.

### Negative
- Principle-level guidance still needs concrete ADRs for messaging, REST, data access, AI ops, etc.

## Alternatives Considered

### Per-repo principles only
Rejected — causes drift across the org.

### Heavy centralized framework
Rejected — conflicts with modular, opt-in defaults.

## Related ADRs
- [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md)
- [ADR-0008](ADR-0008-free-first-modular-platform.md)
- [ADR-0016](ADR-0016-configuration-as-source-of-truth.md)
