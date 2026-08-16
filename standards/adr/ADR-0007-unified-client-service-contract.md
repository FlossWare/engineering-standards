# ADR-0007: Unified Client-Service Contract

> Formerly `docs/architecture/decisions/ADR-0006-unified-service-ui-contract.md`  
> Formerly `adr/ADR-0007-unified-service-ui-contract.md` (filename aligned to title)

## Status
Accepted

## Date
2026-08-07

## Context

FlossWare services may have many consumers: TUI, GUI, web, mobile, automation, and AI agents. Embedding project-specific client logic in services (or embedding service logic in each client) multiplies maintenance cost and blocks independent evolution.

`flossware-tftp-os` already demonstrates multiple frontends consuming a shared REST API under `/api/v1/` (Java, Android, iOS), with Python TUI/GUI optionally using the library in-process.

The architecture must not imply that FlossWare itself needs to build or own a UI. A UI is one possible client of a service contract; an agent runtime is another.

### Client definition

A **client** is any process or component that consumes a FlossWare capability through an external or library boundary, including operator UIs, automation, and agent runtimes. An **in-process library consumer** (same-language import of the service implementation library) is allowed only when that library *is* the service implementation boundary; it is not a license for direct database access.

## Decision

Clients SHALL integrate through stable service APIs and contracts rather than embedding project-specific implementations.

- REST (+ OpenAPI) is the default external synchronous service contract where HTTP request/response semantics are appropriate.
- AI-agent clients SHOULD use MCP for agent-facing capability discovery and invocation ([ADR-0004](ADR-0004-mcp-tool-contracts.md)).
- Clients SHALL NOT access databases directly.
- Backend evolution SHOULD preserve backward-compatible contracts or use explicit versioning.
- Same-process, same-language library use MAY be used when the library is the service implementation boundary; polyglot or remote clients SHALL use the service contract.
- FlossWare SHALL remain neutral about whether a consuming application provides a UI, terminal, IDE, automation workflow, or agent runtime ([ADR-0017](ADR-0017-agent-neutral-architecture.md)).

## Consequences

### Positive
- Services remain independently deployable.
- A unified client can aggregate capabilities.
- Backend evolution does not require full client rewrites.
- New frontends and agent runtimes can be added against stable contracts.
- FlossWare does not need to own a UI to provide a coherent client architecture.

### Negative
- API design discipline is mandatory.
- Multiple protocol contracts may need compatibility testing.

## Alternatives Considered

### UI embedded in each service
Rejected — fragments operator experience and duplicates service/client work.

### Shared UI library calling internal modules directly
Rejected — breaks independent deployability and language boundaries.

### Agent-specific service APIs
Rejected — couples reusable capabilities to a particular agent runtime.

### Stable service contracts with protocol-specific adapters (chosen)
Matches multi-client reality while keeping capabilities reusable and agent-neutral.

## Reference implementation

- [tftp-os UI contract validation](../docs/architecture/reference-implementations/tftp-os-ui-contract.md)
- Upstream: [FlossWare/flossware-tftp-os](https://github.com/FlossWare/flossware-tftp-os)

## Related ADRs
- [ADR-0004](ADR-0004-mcp-tool-contracts.md) — MCP and Tool Contracts
- [ADR-0010](ADR-0010-rest-service-boundaries.md) — REST Service Boundaries
- [ADR-0017](ADR-0017-agent-neutral-architecture.md) — Agent-Neutral Architecture
- [ADR-0020](ADR-0020-capability-protocol-separation.md) — Capability and Protocol Separation
