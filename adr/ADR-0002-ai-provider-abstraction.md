# ADR-0002: AI Provider Abstraction

> Formerly `docs/architecture/decisions/ADR-0001-ai-provider-abstraction.md`

## Status
Accepted

## Date
2026-07-31

## Context

FlossWare requires AI capabilities across code generation, review, retrieval, and orchestration. Binding the platform to a single model vendor, runtime, or deployment topology would create lock-in, complicate testing, and prevent free-first or air-gapped deployments.

Teams need to swap providers (hosted APIs, free tiers, local runtimes) without rewriting business logic.

## Decision

All AI capabilities SHALL be accessed through provider abstractions.

- Call sites depend on contracts (interfaces / ports), not concrete SDKs.
- Providers MAY include hosted APIs, free services, or local inference runtimes when explicitly enabled (see [ADR-0003](ADR-0003-no-local-inference-default.md)).
- Routing, fallback, and consensus policies sit above the provider layer.

## Consequences

### Positive
- No model vendor lock-in.
- Capabilities are selected through contracts.
- Local inference is an optional capability, not a requirement.
- Tests can substitute fake or recorded providers.

### Negative
- Extra abstraction cost and adapter maintenance.
- Feature parity across providers is imperfect; lowest-common-denominator APIs may hide advanced features unless optional capability interfaces exist.

## Alternatives Considered

### Single-vendor SDK everywhere
Rejected — couples product roadmap to one vendor and blocks free/local paths.

### Direct multi-SDK usage at call sites
Rejected — scatters vendor logic and makes policy (routing, fallback) inconsistent.

### Provider abstraction (chosen)
Accepted — centralizes integration and preserves deployment flexibility.

## Related ADRs
- [ADR-0003](ADR-0003-no-local-inference-default.md) — No Local Inference by Default
- [ADR-0004](ADR-0004-mcp-tool-contracts.md) — MCP and Tool Contracts
- [ADR-0008](ADR-0008-free-first-modular-platform.md) — Free-First Modular Platform
