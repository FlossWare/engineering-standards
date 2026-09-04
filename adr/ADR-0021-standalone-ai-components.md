# ADR-0021: Standalone AI Components

## Status

Proposed

## Date

2026-08-21

## Scope

This ADR applies to reusable FlossWare `*-ai` capability libraries and their optional agent/protocol integrations. It governs dependency direction, standalone usability, composability, and separation between capability implementations and agent/transport adapters.

## Non-goals

- This ADR does not require every component to expose MCP.
- This ADR does not prescribe one agent integration mechanism for every agent.
- This ADR does not require Loom to provide identical integration behavior to every external runtime.
- This ADR does not prevent a component from offering optional Loom-specific or agent-specific adapters.

## Context

FlossWare is developing reusable `*-ai` components for capabilities such as resilience, budgeting, caching, security, observability, routing, structured output, consensus, evaluation, RAG, workflow, streaming, conversation, learning, and optimization.

These components are useful to more than one orchestration runtime. In particular, they should be directly usable from Claude Code, Cursor, Crush, OpenCode, Loom, ordinary Python applications, and future agent runtimes. Requiring Loom would turn a reusable capability into an orchestrator-specific dependency and would prevent independent adoption.

Existing FlossWare ADRs already establish agent neutrality, explicit opt-in cross-cutting behavior, MCP capability exposure, and capability/protocol separation. This ADR applies those principles specifically to reusable AI components.

## Decision

FlossWare `*-ai` components SHALL be standalone, agent-neutral capabilities. Loom is a consumer of these components, not a required runtime dependency.

A component MUST be usable without installing Loom or another FlossWare orchestrator. Agent- and protocol-specific integration SHALL be implemented as an adapter around the capability rather than embedded in the capability itself.

```text
                 Standalone FlossWare Capability
                              |
              +---------------+---------------+
              |               |               |
          Python API       MCP adapter     Other adapters
              |               |               |
         Applications    Claude/Cursor/   Loom/HTTP/etc.
                         Crush/OpenCode
```

## Rules

### Standalone capability

- `*-ai` core implementations MUST NOT depend on Loom, a specific agent runtime, or a specific agent vendor.
- Core packages SHOULD minimize required dependencies and MUST NOT require an orchestration service merely to provide their primary capability.
- Public APIs SHOULD be usable directly from ordinary Python applications.
- Capability behavior MUST be testable independently of any agent or transport.

### Protocol and agent separation

- Agent-facing protocols such as MCP MUST remain adapters around the underlying capability, consistent with ADR-0020.
- MCP support SHOULD be provided where the capability represents a useful agent operation; not every library or decorator needs an MCP server.
- Agent-specific configuration, manifests, skills, commands, hooks, and packaging MUST remain outside the core capability implementation.
- Multiple consumers MAY expose the same capability through different adapters.

### Cross-cutting components

Components implementing cross-cutting behavior SHOULD provide explicit, composable decorators and/or policy objects where appropriate. Decorators SHOULD:

- preserve function metadata and signatures where practical;
- support composition/stacking;
- avoid implicit global state;
- accept explicit configuration and dependencies;
- work independently of Loom;
- provide both decorator and lower-level APIs when the capability warrants both.

Examples include retry, resilience, budgets, caching, security, observability, and structured-output enforcement.

### Capability components

Components representing agent-facing capabilities MAY provide a CLI and/or optional MCP adapter. Examples include consensus, evaluation, RAG, workflow, conversation, streaming, and learning capabilities.

### Loom integration

Loom MAY provide native composition and deeper integration with any `*-ai` component, but a component MUST remain independently usable when integrated with Loom.

Loom-specific adapters MUST NOT become required dependencies of the standalone package.

## Recommended package structure

```text
foo-ai/
├── src/foo_ai/          # standalone capability
├── tests/               # capability and contract tests
├── examples/            # direct usage examples
├── docs/
├── README.md
├── STANDARDS.md
└── pyproject.toml
```

Optional integrations SHOULD be isolated, for example:

```text
foo-ai[mcp]
foo-ai[loom]
```

or in separate adapter packages when the dependency surface warrants it.

## Acceptance criteria

A `*-ai` component conforms when a developer can:

1. install the component without Loom;
2. import and invoke its primary capability directly;
3. compose it with unrelated Python code;
4. run its tests without an agent runtime;
5. expose it through an appropriate protocol/agent adapter without changing the core capability; and
6. use the same component from Loom and from another supported agent/runtime.

## Consequences

### Positive

- Components become independently useful and reusable.
- Claude Code, Cursor, Crush, OpenCode, Loom, and future runtimes can consume the same implementation.
- Loom remains an orchestration platform rather than a dependency hub.
- Cross-cutting behavior can be composed directly into arbitrary applications.
- Protocol and agent integrations can evolve independently.

### Negative

- Each component needs clear contracts and independent tests.
- MCP/agent adapters add integration work for capabilities that benefit from agent exposure.
- Dependency/version compatibility must be managed at component boundaries.

## Alternatives Considered

### Require Loom for all FlossWare AI components
Rejected. This creates unnecessary coupling and prevents direct use by other agents, applications, and libraries.

### Put agent-specific behavior into every component
Rejected. This duplicates integration logic and violates agent neutrality.

### Make every component an MCP server
Rejected. Some capabilities are best consumed as Python libraries or decorators and do not represent meaningful agent tools.

### Standalone capability with optional adapters (chosen)
Provides maximum reuse while allowing deep Loom integration and first-class agent exposure where appropriate.

## Related ADRs

- [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md) — Explicit Opt-In Cross-Cutting Behavior
- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
- [ADR-0004](ADR-0004-mcp-tool-contracts.md) — MCP Tool Contracts
- [ADR-0006](ADR-0006-cross-cutting-decorators.md) — Cross-Cutting Decorators
- [ADR-0008](ADR-0008-free-first-modular-platform.md) — Free-First Modular Platform
- [ADR-0009](ADR-0009-core-architecture-principles.md) — Core Architecture Principles
- [ADR-0017](ADR-0017-agent-neutral-architecture.md) — Agent-Neutral Architecture
- [ADR-0018](ADR-0018-mcp-capability-exposure.md) — MCP Capability Exposure
- [ADR-0019](ADR-0019-agent-tool-security-and-authorization.md) — Agent Tool Security and Authorization
- [ADR-0020](ADR-0020-capability-protocol-separation.md) — Capability and Protocol Separation
