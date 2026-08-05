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

Architecture decisions are documented as ADRs under `adr/`.

| ADR | Topic |
| --- | --- |
| ADR-0001 | Core FlossWare architecture principles |
| ADR-0002 | Event-driven messaging architecture |
| ADR-0003 | REST service boundaries and integration |
| ADR-0004 | Stored procedure database access policy |

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
