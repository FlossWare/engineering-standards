# ADR-0003: No Local Inference by Default

## Status
Accepted

## Date
2026-08-07

## Context

AI systems should remain usable on small infrastructure, cloud environments, and developer workstations. Making local GPU inference the default would raise the hardware bar, complicate onboarding, and couple product success to model packaging and driver stacks.

At the same time, privacy, air-gapped, cost, and latency scenarios legitimately need local models.

## Scope

Default deployment topology for model execution in FlossWare systems.

## Non-goals

- Does not ban local inference.
- Does not specify which local runtimes to package.

## Decision

Local inference SHALL NOT be the default execution path.

- Systems SHALL prefer configured remote/hosted providers.
- Local models MAY be enabled explicitly for specific deployment profiles.
- "No local by default" is a deployment-topology default, not a ban on local capability.

### When local SHOULD be preferred
- Air-gapped / offline environments
- Strict data-residency or privacy requirements (data must not leave the trust boundary)
- Cost-sensitive bulk workloads where amortized GPU cost beats API pricing
- Latency-critical interactive loops where remote round-trips are unacceptable

## Consequences

### Positive
- Lower infrastructure requirements for the common case.
- Easier deployment and CI.
- Hardware becomes an optimization option rather than a prerequisite.

### Negative
- Privacy-sensitive deployments must explicitly configure local paths.
- Teams may under-invest in local packaging quality if it is always "optional."

## Alternatives Considered

### Local-first default
Rejected for general FlossWare deployments — raises hardware and ops cost for most users.

### No local support at all
Rejected — blocks offline, regulated, and cost-sensitive use cases.

### Remote default with explicit local opt-in (chosen)
Balances accessibility with the ability to run fully local when justified.

## Related ADRs
- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
- [ADR-0008](ADR-0008-free-first-modular-platform.md) — Free-First Modular Platform
- [ADR-0015](ADR-0015-dynamic-ai-model-inventory.md) — Dynamic AI Model Inventory
