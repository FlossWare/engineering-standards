# ADR-0015: Dynamic Service Discovery for AI Models

## Status
Accepted

## Date
2026-08-05

## Context

The AI model landscape changes rapidly: providers add and remove models weekly, free tiers appear and disappear, rate limits shift, and model quality varies over time. Static model registries (hardcoded lists of model names, endpoints, and API keys) cannot keep pace with this churn.

A system that hardcodes a fixed model list today will have stale entries within weeks — dead models that waste retry budget, missing models that could improve results, and incorrect metadata that causes silent failures.

Internal FlossWare operations with large dynamic registries observed that automated discovery can surface many additional routable models without code changes, that health checks can catch “HTTP 200 but wrong answer” models, and that provider bridge tables reduce integration cost for known call formats. These are **internal operational observations**, not externally published studies.

## Decision

AI model inventories SHALL be maintained as dynamic registries, not hardcoded configuration alone.

### Registry as inventory source

- The model registry SHALL be the authoritative *inventory* source for available models, their providers, and their capabilities.
- Hardcoded model entries MAY exist as a bootstrap or override layer but SHALL NOT be the sole source of routing information.
- The registry SHOULD be populated by automated discovery (scrapers, provider API enumeration) rather than manual entry only.
- **Policy** (allowed pools, free-first filters, budgets) remains configuration-owned ([ADR-0016](ADR-0016-configuration-as-source-of-truth.md)).

### Provider bridge tables

- Systems SHALL maintain a provider configuration table that maps each provider to its endpoint pattern, authentication mechanism, and call format. This table is the concrete implementation of the provider abstraction layer ([ADR-0002](ADR-0002-ai-provider-abstraction.md)).
- Adding a new model from a known provider SHALL NOT require code changes — only a registry entry.
- New providers require a bridge table entry and, if the call format is novel, a new call format adapter.

### Health verification lifecycle

Models SHALL progress through a defined lifecycle:

1. **Discovered** — present in registry, not yet verified.
2. **Verified** — passed health check (correct response to a known-answer probe).
3. **Disabled** — failed health check or consistently produces errors.
4. **Unverified** — previously verified but health status has expired or been invalidated.

- Only **verified** models SHOULD receive production traffic by default.
- Health checks SHOULD use objective, mechanically verifiable probes (e.g., arithmetic questions with known answers).
- Health check results SHOULD be pushed back to the registry to update model status.

### Discovery cadence

- Automated model discovery SHOULD run at least daily.
- Health checks SHOULD run continuously in the background, cycling through unverified models in small batches.
- Full re-verification of the verified pool SHOULD occur on a configurable schedule (weekly is a reasonable default).

### Free-tier filtering

- Systems operating under a free-first policy ([ADR-0008](ADR-0008-free-first-modular-platform.md)) SHALL maintain a set of known free providers.
- Dynamic models from paid-only providers SHALL NOT be added to the routing pool unless explicitly enabled.
- The free/paid classification SHOULD be a registry attribute, not hardcoded per provider.

### Graceful degradation

- If the registry is unreachable, the system SHALL fall back to hardcoded model entries.
- Registry refresh failures SHALL be logged but SHALL NOT block request processing.
- The system SHOULD cache the last successful registry snapshot for offline operation.

## Consequences

### Positive
- New models become routable automatically as they are discovered and verified.
- Dead models are detected and removed without manual intervention.
- Provider bridge tables make adding new providers a configuration change, not a code change.
- Health verification prevents routing to models that are alive but inaccurate.

### Negative
- Registry infrastructure must be operated and monitored.
- Automated discovery may import low-quality or irrelevant models that consume health check budget.
- Health check probes test a narrow capability; a model that passes a simple arithmetic probe may still fail at complex tasks.
- Stale registry cache during extended outages may route to models that have since been decommissioned.

## Alternatives Considered

### Hardcoded model list only
Rejected — cannot adapt to the pace of model ecosystem changes.

### Fully dynamic with no hardcoded fallback
Rejected — registry outage would leave the system with zero available models.

### Dynamic registry with hardcoded bootstrap and health verification (chosen)
Combines automated discovery with reliability guarantees and quality gates.

## Related ADRs
- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
- [ADR-0003](ADR-0003-no-local-inference-default.md) — No Local Inference by Default
- [ADR-0008](ADR-0008-free-first-modular-platform.md) — Free-First Modular Platform
- [ADR-0012](ADR-0012-multi-model-consensus-quality-gates.md) — Multi-Model Consensus for Quality Gates
- [ADR-0013](ADR-0013-bandit-based-model-selection.md) — Bandit-Based Model Selection
- [ADR-0016](ADR-0016-configuration-as-source-of-truth.md) — Configuration as Source of Truth
