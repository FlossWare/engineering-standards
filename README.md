# FlossWare Engineering Standards

This repository defines shared engineering standards, architecture decisions, and development conventions for the FlossWare ecosystem.

## Core Principles

- Configuration is the source of truth.
- Defaults are minimal; capabilities are explicitly enabled.
- Components are modular and composable.
- Prefer open standards and free-first implementations.
- Avoid unnecessary coupling.
- Favor automation, repeatability, and infrastructure-as-code.

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
| [ADR-0007](adr/ADR-0007-unified-service-ui-contract.md) | Unified Service UI Contract |
| [ADR-0008](adr/ADR-0008-free-first-modular-platform.md) | Free-First Modular Platform |

## ADR Process

All ADRs should include:

- Status
- Context
- Decision
- Consequences
- Alternatives considered
- Related ADRs

RFC 2119 keywords are used consistently:

- SHALL / SHALL NOT: mandatory requirements
- SHOULD / SHOULD NOT: recommended practices
- MAY: optional behavior
