# FlossWare Engineering Standards

This repository is the single canonical home for FlossWare engineering standards, architecture decisions, build tooling, CI/CD workflows, and development scripts.

> **Consolidated:** The former `FlossWare/build-tools` repository has been merged here. All build and release tooling now lives under `build-tools/` and `scripts/`.

## Repository Structure

```text
engineering-standards/
├── standards/          # Architecture decisions and documentation
│   ├── adr/            # Architecture Decision Records (ADR-0001 … ADR-0020)
│   └── docs/           # Reference architecture and implementation guides
├── build-tools/        # Build infrastructure
│   ├── maven/          # Maven parent POM + OpenRewrite / quality configs
│   └── gradle/         # Gradle standards plugin + consumer templates
├── ci/                 # CI/CD workflow definitions
│   └── workflows/      # GitHub Actions workflows
├── scripts/            # Shell scripts for project management and rollout
└── templates/          # Project templates and config snippets
```

## Core Principles

- Configuration is the source of truth.
- Defaults are minimal; capabilities are explicitly enabled.
- Components are modular and composable.
- Prefer open standards and free-first implementations.
- Avoid unnecessary coupling.
- Favor automation, repeatability, and infrastructure-as-code.
- Agent-neutral: capabilities and infrastructure, not a required agent runtime or UI.
- Capability before protocol; security at capability boundaries.

See [ADR-0009](standards/adr/ADR-0009-core-architecture-principles.md) and [ADR-0016](standards/adr/ADR-0016-configuration-as-source-of-truth.md) for normative statements.

## Architecture Decisions

Architecture decisions are documented as ADRs under [`standards/adr/`](standards/adr/).

| ADR | Topic |
| --- | --- |
| [ADR-0001](standards/adr/ADR-0001-explicit-opt-in-cross-cutting-behavior.md) | Explicit Opt-In Cross-Cutting Behavior |
| [ADR-0002](standards/adr/ADR-0002-ai-provider-abstraction.md) | AI Provider Abstraction |
| [ADR-0003](standards/adr/ADR-0003-no-local-inference-default.md) | No Local Inference by Default |
| [ADR-0004](standards/adr/ADR-0004-mcp-tool-contracts.md) | MCP and Tool Contracts |
| [ADR-0005](standards/adr/ADR-0005-event-driven-internal-bus.md) | Event-Driven Internal Bus |
| [ADR-0006](standards/adr/ADR-0006-cross-cutting-decorators.md) | Cross-Cutting Decorators |
| [ADR-0007](standards/adr/ADR-0007-unified-client-service-contract.md) | Unified Client-Service Contract |
| [ADR-0008](standards/adr/ADR-0008-free-first-modular-platform.md) | Free-First Modular Platform |
| [ADR-0009](standards/adr/ADR-0009-core-architecture-principles.md) | Core Architecture Principles |
| [ADR-0010](standards/adr/ADR-0010-rest-service-boundaries.md) | REST Service Boundaries and Integration |
| [ADR-0011](standards/adr/ADR-0011-stored-procedure-database-access.md) | Stored Procedure Database Access Policy |
| [ADR-0012](standards/adr/ADR-0012-multi-model-consensus-quality-gates.md) | Multi-Model Consensus for Quality Gates |
| [ADR-0013](standards/adr/ADR-0013-bandit-based-model-selection.md) | Bandit-Based Model Selection |
| [ADR-0014](standards/adr/ADR-0014-token-budget-management.md) | Token Budget Management |
| [ADR-0015](standards/adr/ADR-0015-dynamic-ai-model-inventory.md) | Dynamic AI Model Inventory |
| [ADR-0016](standards/adr/ADR-0016-configuration-as-source-of-truth.md) | Configuration as Source of Truth |
| [ADR-0017](standards/adr/ADR-0017-agent-neutral-architecture.md) | Agent-Neutral Architecture |
| [ADR-0018](standards/adr/ADR-0018-mcp-capability-exposure.md) | MCP Capability Exposure |
| [ADR-0019](standards/adr/ADR-0019-agent-tool-security-and-authorization.md) | Agent Tool Security and Authorization |
| [ADR-0020](standards/adr/ADR-0020-capability-protocol-separation.md) | Capability and Protocol Separation |

New ADRs SHOULD use [`standards/adr/TEMPLATE.md`](standards/adr/TEMPLATE.md).

### Suggested read order (MCP / capability cluster)

1. [ADR-0020](standards/adr/ADR-0020-capability-protocol-separation.md) — capability vs protocol
2. [ADR-0004](standards/adr/ADR-0004-mcp-tool-contracts.md) — MCP preference for agents
3. [ADR-0018](standards/adr/ADR-0018-mcp-capability-exposure.md) — MCP exposure rules
4. [ADR-0019](standards/adr/ADR-0019-agent-tool-security-and-authorization.md) — tool security
5. [ADR-0017](standards/adr/ADR-0017-agent-neutral-architecture.md) — agent-neutral posture

## Build Tooling

### Maven

The Maven parent POM and quality configurations live under [`build-tools/maven/`](build-tools/maven/):
- `pom.xml` — FlossWare parent POM with Checkstyle, PMD, SpotBugs, JaCoCo
- `src/main/resources/` — Checkstyle, PMD, SpotBugs, and JaCoCo configuration files
- `src/main/resources/META-INF/rewrite/` — OpenRewrite recipes

### Gradle

The Gradle standards plugin lives under [`build-tools/gradle/`](build-tools/gradle/):
- `FlosswareStandardsPlugin` — applies Checkstyle, PMD, SpotBugs, JaCoCo with FlossWare defaults
- `templates/` — consumer project examples (Groovy and Kotlin DSL)

## CI/CD Workflows

GitHub Actions workflows under [`ci/workflows/`](ci/workflows/):
- `quality-gate.yml` — Maven quality gate (Checkstyle, PMD, SpotBugs, JaCoCo)
- `gradle-quality-gate.yml` — Gradle quality gate
- `main.yml` — Main build workflow
- `check-findings-to-issues.yml` — Auto-create issues from SonarCloud/GitGuardian findings

## Scripts

Shell scripts under [`scripts/`](scripts/) for cross-project operations:
- `rollout-standards.sh` / `rollout-gradle-standards.sh` — roll out quality configs to all projects
- `create-new-project.sh` — scaffold a new FlossWare project
- `apply-maven-quality.sh` — apply Maven quality tooling to a project
- `verify-all-projects.sh` — verify all FlossWare projects build
- `bump-version.sh` — bump version across projects
- See the directory for the full list.

## Reference Architecture

- [Reference architecture diagram](standards/docs/architecture/reference-architecture.md) (Mermaid)
- [tftp-os client contract validation](standards/docs/architecture/reference-implementations/tftp-os-ui-contract.md)

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
- SHOULD / SHOULD NOT: recommended practices
- MAY: optional behavior
