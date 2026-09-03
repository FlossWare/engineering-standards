# FlossWare Engineering Standards

This repository defines shared engineering standards, architecture decisions, and development conventions for the FlossWare ecosystem.

## Core Principles

- Configuration is the source of truth.
- Defaults are minimal; capabilities are explicitly enabled.
- Components are modular and composable.
- Provider- and pricing-neutral: no AI provider, model vendor, hosting topology, or pricing tier is an architectural default.
- Avoid unnecessary coupling.
- Favor automation, repeatability, and infrastructure-as-code.
- Agent-neutral: capabilities and infrastructure, not a required agent runtime or UI.
- Capability before protocol; security at capability boundaries.
- Released artifacts are derived, reproducible delivery outputs, not sources of truth.

See [ADR-0009](adr/ADR-0009-core-architecture-principles.md), [ADR-0016](adr/ADR-0016-configuration-as-source-of-truth.md), [ADR-0021](adr/ADR-0021-provider-neutral-ai-selection.md), [ADR-0022](adr/ADR-0022-reproducible-build-artifacts-and-distribution.md), and [ADR-0023](adr/ADR-0023-canonical-flossware-ai-state-root.md) for normative statements.

## Architecture Decisions

Architecture decisions are documented as ADRs under [`adr/`](adr/).

| ADR | Topic |
| --- | --- |
| [ADR-0001](adr/ADR-0001-explicit-opt-in-cross-cutting-behavior.md) | Explicit Opt-In Cross-Cutting Behavior |
| [ADR-0002](adr/ADR-0002-ai-provider-abstraction.md) | AI Provider Abstraction |
| [ADR-0003](adr/ADR-0003-no-local-inference-default.md) | No Local Inference by Default |
| [ADR-0004](adr/ADR-0004-mcp-tool-contracts.md) | MCP and Tool Contracts |
| [ADR-0005](adr/ADR-0005-event-driven-internal-bus.md) | Event-Driven Internal Bus |
| [ADR-0006](adr/ADR-0006-cross-cutting-decorators.md) | Cross-Cutting Decorators |
| [ADR-0007](adr/ADR-0007-unified-client-service-contract.md) | Unified Client-Service Contract |
| [ADR-0008](adr/ADR-0008-free-first-modular-platform.md) | Historical Free-First Platform Policy (Superseded) |
| [ADR-0009](adr/ADR-0009-core-architecture-principles.md) | Core Architecture Principles |
| [ADR-0010](adr/ADR-0010-rest-service-boundaries.md) | REST Service Boundaries and Integration |
| [ADR-0011](adr/ADR-0011-stored-procedure-database-access.md) | Stored Procedure Database Access Policy |
| [ADR-0012](adr/ADR-0012-multi-model-consensus-quality-gates.md) | Multi-Model Consensus for Quality Gates |
| [ADR-0013](adr/ADR-0013-bandit-based-model-selection.md) | Bandit-Based Model Selection |
| [ADR-0014](adr/ADR-0014-token-budget-management.md) | Token Budget Management |
| [ADR-0015](adr/ADR-0015-dynamic-ai-model-inventory.md) | Dynamic AI Model Inventory |
| [ADR-0016](adr/ADR-0016-configuration-as-source-of-truth.md) | Configuration as Source of Truth |
| [ADR-0017](adr/ADR-0017-agent-neutral-architecture.md) | Agent-Neutral Architecture |
| [ADR-0018](adr/ADR-0018-mcp-capability-exposure.md) | MCP Capability Exposure |
| [ADR-0019](adr/ADR-0019-agent-tool-security-and-authorization.md) | Agent Tool Security and Authorization |
| [ADR-0020](adr/ADR-0020-capability-protocol-separation.md) | Capability and Protocol Separation |
| [ADR-0021](adr/ADR-0021-provider-neutral-ai-selection.md) | Provider-Neutral AI Selection |
| [ADR-0022](adr/ADR-0022-reproducible-build-artifacts-and-distribution.md) | Reproducible Build Artifacts and Distribution |
| [ADR-0023](adr/ADR-0023-canonical-flossware-ai-state-root.md) | Canonical FlossWare AI Persistent State Root |

New ADRs SHOULD use [`adr/TEMPLATE.md`](adr/TEMPLATE.md).

### Suggested read order (MCP / capability cluster)

1. [ADR-0020](adr/ADR-0020-capability-protocol-separation.md) — capability vs protocol
2. [ADR-0004](adr/ADR-0004-mcp-tool-contracts.md) — MCP preference for agents
3. [ADR-0018](adr/ADR-0018-mcp-capability-exposure.md) — MCP exposure rules
4. [ADR-0019](adr/ADR-0019-agent-tool-security-and-authorization.md) — tool security
5. [ADR-0017](adr/ADR-0017-agent-neutral-architecture.md) — agent-neutral posture
6. [ADR-0021](adr/ADR-0021-provider-neutral-ai-selection.md) — provider and pricing neutrality
7. [ADR-0022](adr/ADR-0022-reproducible-build-artifacts-and-distribution.md) — reproducible artifact distribution
8. [ADR-0023](adr/ADR-0023-canonical-flossware-ai-state-root.md) — persistent AI state ownership

## Reference architecture

- [Reference architecture diagram](docs/architecture/reference-architecture.md) (Mermaid)
- [tftp-os client contract validation](docs/architecture/reference-implementations/tftp-os-ui-contract.md)

## ADR Process

All ADRs should include:

- Status
- Date
- Context
- Scope and Non-goals (recommended; required for new ADRs)
- Decision
- Consequences (positive and negative)
- Alternatives considered
- Related ADRs

RFC 2119 keywords are used consistently:

- SHALL / SHALL NOT: mandatory requirements (MUST is treated as equivalent to SHALL)
- SHOULD / SHOULD NOT: strong recommendation
- MAY: optional behavior
