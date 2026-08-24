# ADR-0008: Free-First Modular Platform

## Status
Superseded by [ADR-0021](ADR-0021-provider-neutral-ai-selection.md)

## Date
2026-08-21

## Historical Context

FlossWare previously used a free-first economic preference to emphasize accessibility while retaining the ability to use commercial services when justified. That approach was useful as an early constraint, but it is no longer the correct architectural policy for the AI platform.

## Supersession

As of 2026-08-23, FlossWare no longer treats any pricing tier as a preferred architectural default. Provider and model selection are provider-neutral and pricing-neutral. See [ADR-0021](ADR-0021-provider-neutral-ai-selection.md).

The historical goals of accessibility, cost awareness, modularity, and avoidance of unnecessary lock-in remain valid. They are now expressed as explicit routing and deployment policy rather than a repository-wide preference for one pricing class.

## Historical Decision

The former decision was to prefer free/open components when they satisfied workload requirements while permitting paid services when justified. That decision is retained here for historical traceability only and SHALL NOT be used as current normative guidance.

## Related ADRs

- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
- [ADR-0003](ADR-0003-no-local-inference-default.md) — Policy-Driven AI Execution Topology
- [ADR-0021](ADR-0021-provider-neutral-ai-selection.md) — Provider-Neutral AI Selection
