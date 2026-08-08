# ADR-0002: AI Provider Abstraction

## Status
Accepted

## Date
2026-08-07

## Context

FlossWare requires AI capabilities across code generation, review, retrieval, and orchestration. Binding the platform to a single model vendor, runtime, or deployment topology would create lock-in, complicate testing, and prevent free-first or air-gapped deployments.

Teams need to swap providers (hosted APIs, free tiers, local runtimes) without rewriting business logic.

### Terminology

In this ADR and related integration ADRs, **provider** means an **integration adapter**: endpoint pattern, authentication, and call format for invoking models ([ADR-0015](ADR-0015-dynamic-ai-model-inventory.md) bridge tables). It does **not** mean a consensus **diversity unit** (model family / training lineage); that sense is defined only in [ADR-0012](ADR-0012-multi-model-consensus-quality-gates.md).

## Scope

How FlossWare application and platform code obtains AI model inference and related model APIs.

## Non-goals

- Does not choose specific model vendors or ranking algorithms ([ADR-0013](ADR-0013-bandit-based-model-selection.md)).
- Does not define agent tool protocols ([ADR-0004](ADR-0004-mcp-tool-contracts.md)).

## Decision

All AI capabilities SHALL be accessed through provider abstractions.

- Call sites depend on contracts (interfaces / ports), not concrete SDKs.
- Providers MAY include hosted APIs, free services, or local inference runtimes when explicitly enabled (see [ADR-0003](ADR-0003-no-local-inference-default.md)).
- Routing, fallback, and consensus policies sit above the provider layer ([ADR-0012](ADR-0012-multi-model-consensus-quality-gates.md), [ADR-0013](ADR-0013-bandit-based-model-selection.md)).

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
- [ADR-0012](ADR-0012-multi-model-consensus-quality-gates.md) — Multi-Model Consensus for Quality Gates
- [ADR-0013](ADR-0013-bandit-based-model-selection.md) — Bandit-Based Model Selection
- [ADR-0015](ADR-0015-dynamic-ai-model-inventory.md) — Dynamic AI Model Inventory
