# ADR-0008: Free-First Modular Platform

## Status
Accepted

## Date
2026-08-21

## Context

FlossWare aims to stay accessible to individuals and small teams while remaining capable enough for serious infrastructure automation. Defaulting to commercial services raises cost and lock-in; forbidding them entirely blocks justified quality, reliability, security, or capability requirements.

FlossWare now supports a broader AI execution model that includes free-tier, commercial, hosted, and local execution. Free-first therefore needs to remain a guiding economic and accessibility principle without becoming a blanket runtime restriction.

## Scope

Default posture for selecting open/free vs commercial components and services across FlossWare repositories, including AI execution where applicable.

## Non-goals

- Does not ban commercial components or services.
- Does not require every workload to use a free option.
- Does not rank specific products or providers.
- Does not define local vs hosted execution topology; see [ADR-0003](ADR-0003-no-local-inference-default.md).

## Decision

FlossWare designs SHALL prefer free, open, modular components and services **when they satisfy the required capability, quality, security, compliance, operational, and economic constraints**.

Free-first is a preference and default selection heuristic, not a free-only architectural rule.

### Principles

- Modular by default.
- Contracts over implementations.
- Capabilities over dependencies.
- No unnecessary infrastructure requirements.
- Prefer free/open solutions when they are fit for purpose.
- Preserve the ability to use paid services when they provide justified value.

### Runtime AI policy

For AI workloads, free-first SHALL NOT override explicit workload or deployment requirements such as:

- Required model capability or quality
- Security or compliance requirements
- Privacy or data-residency constraints
- Reliability or availability requirements
- Latency requirements
- Total cost of ownership
- Capacity or rate-limit requirements

Where multiple eligible options satisfy the workload requirements, a free/open option SHOULD be preferred.

Paid execution MAY be selected when policy permits it and the workload requirements justify it. This does not require a permanent migration path to a free alternative.

Execution topology itself is policy-driven and topology-neutral according to [ADR-0003](ADR-0003-no-local-inference-default.md).

### When commercial / paid MAY be justified

Document the rationale when adopting a non-free component or service. Typical justifications include:

- No adequate free alternative for a required capability
- Material reliability, security, quality, or compliance gap in free options
- Clear total-cost advantage after operations and maintenance labor are included
- Capacity or latency requirements that free options cannot satisfy
- Explicit business, deployment, or user requirements

A paid choice does not need to be justified solely by the absence of a free alternative. Material quality or operational value is sufficient when the deployment policy permits the expenditure.

## Consequences

### Positive

- Platform remains accessible and adaptable without artificially limiting capability.
- Avoids accidental commercial lock-in.
- Allows the AI fleet to use paid models when they are materially better for the workload.
- Keeps cost a first-class routing concern without making it the only concern.

### Negative

- Teams must distinguish genuine value from convenience-driven paid defaults.
- Policy and routing configuration must make paid execution intentional and auditable.
- Free alternatives may require more integration work.

## Alternatives Considered

### Commercial-first
Rejected — conflicts with accessibility and free-first mission.

### Free-only (no commercial allowed)
Rejected — too rigid when quality, capability, security, reliability, capacity, or compliance gaps are real.

### Free-first with explicit justification for paid (chosen)
Balances accessibility and cost discipline with pragmatic access to better capabilities.

## Related ADRs

- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
- [ADR-0003](ADR-0003-no-local-inference-default.md) — Policy-Driven AI Execution Topology
- [ADR-0013](ADR-0013-bandit-based-model-selection.md) — Adaptive Model Selection
- [ADR-0015](ADR-0015-dynamic-ai-model-inventory.md) — Dynamic AI Model Inventory
- [ADR-0016](ADR-0016-configuration-as-source-of-truth.md) — Configuration as Source of Truth
