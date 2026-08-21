# ADR-0009: Core FlossWare Architecture Principles

## Status
Accepted

## Date
2026-08-21

## Context

FlossWare spans many repositories (provisioning, AI orchestration, platforms, tools). Without shared principles, individual projects drift toward incompatible defaults, hidden coupling, and uneven quality.

## Decision

All FlossWare repositories SHALL apply the following principles:

1. **Configuration is the source of truth** — runtime behavior is driven by explicit, reviewable configuration, not hardcoded environment assumptions. See [ADR-0016](ADR-0016-configuration-as-source-of-truth.md).
2. **Defaults are minimal** — capabilities are explicitly enabled at dependency, build, deploy, and runtime layers ([ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md)).
3. **Modular and composable** — components can be used independently.
4. **Contracts over implementations** — depend on stable APIs, events, and tool contracts, not concrete libraries.
5. **Free-first** — prefer free/open components and services when they satisfy required capability, quality, security, compliance, operational, and economic constraints; paid choices are permitted when justified ([ADR-0008](ADR-0008-free-first-modular-platform.md)).
6. **Avoid unnecessary coupling** — no hidden side effects, no shared-database integration as a default bus.
7. **Automation and repeatability** — favor infrastructure-as-code and reproducible pipelines.
8. **Agent-neutral** — FlossWare provides reusable capabilities and infrastructure without requiring a particular AI agent runtime, IDE, terminal UI, or conversational UI ([ADR-0017](ADR-0017-agent-neutral-architecture.md)).
9. **Capability before protocol** — reusable capability implementations remain independent of MCP, REST, events, and other transport protocols ([ADR-0020](ADR-0020-capability-protocol-separation.md)).
10. **Security at capability boundaries** — agent-facing tools and external service contracts require explicit authorization rather than inheriting unrestricted access from connectivity ([ADR-0019](ADR-0019-agent-tool-security-and-authorization.md)).
11. **Policy-driven AI execution topology** — FlossWare SHALL NOT impose a universal local-first or remote-first inference topology. Execution candidates are selected by explicit policy, inventory, verification, availability, and workload requirements ([ADR-0003](ADR-0003-no-local-inference-default.md)).

## Consequences

### Positive
- Shared vocabulary for design reviews and ADRs.
- Easier cross-repo reuse and AI-assisted development.
- External agent runtimes can consume FlossWare without becoming architectural dependencies.
- Protocols can evolve without duplicating capability implementations.
- AI workloads can select hosted or local execution according to explicit requirements rather than an arbitrary architectural default.

### Negative
- Principle-level guidance still needs concrete ADRs for messaging, REST, data access, AI operations, security, and protocol adapters.
- Policy-driven execution requires clear configuration and routing semantics.

## Alternatives Considered

### Per-repo principles only
Rejected — causes drift across the org.

### Heavy centralized framework
Rejected — conflicts with modular, opt-in defaults.

### FlossWare-owned agent platform and UI
Rejected — unnecessarily couples reusable infrastructure to one interaction model.

## Related ADRs
- [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md)
- [ADR-0003](ADR-0003-no-local-inference-default.md)
- [ADR-0004](ADR-0004-mcp-tool-contracts.md)
- [ADR-0008](ADR-0008-free-first-modular-platform.md)
- [ADR-0010](ADR-0010-rest-service-boundaries.md)
- [ADR-0013](ADR-0013-bandit-based-model-selection.md)
- [ADR-0015](ADR-0015-dynamic-ai-model-inventory.md)
- [ADR-0016](ADR-0016-configuration-as-source-of-truth.md)
- [ADR-0017](ADR-0017-agent-neutral-architecture.md)
- [ADR-0018](ADR-0018-mcp-capability-exposure.md)
- [ADR-0019](ADR-0019-agent-tool-security-and-authorization.md)
- [ADR-0020](ADR-0020-capability-protocol-separation.md)
