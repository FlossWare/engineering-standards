# ADR-0007: Unified Service UI Contract

> Formerly `docs/architecture/decisions/ADR-0006-unified-service-ui-contract.md`

## Status
Accepted

## Date
2026-07-31

## Context

Projects such as PXE OS and TFTP OS need consistent operator experiences across TUI, GUI, web, and mobile clients. Embedding project-specific UI logic in services (or embedding service logic in each UI) multiplies maintenance cost and blocks a unified operator console.

`flossware-tftp-os` already demonstrates multiple frontends consuming a shared REST API under `/api/v1/` (Java, Android, iOS), with Python TUI/GUI optionally using the library in-process.

## Decision

User interfaces SHALL integrate through stable service APIs and contracts rather than embedding project-specific implementations.

- REST (+ OpenAPI) is the default external synchronous contract for operator UIs.
- Clients SHALL NOT access databases directly.
- Backend evolution SHOULD preserve backward-compatible API contracts or use explicit versioning.
- Same-process, same-language library use MAY be used when the library is the service implementation boundary; polyglot or remote UIs SHALL use the service API.

## Consequences

### Positive
- Services remain independently deployable.
- A unified UI can aggregate capabilities.
- Backend evolution does not require full UI rewrites.
- New frontends can be added against the same contract.

### Negative
- API design discipline is mandatory.
- Lowest-common-denominator APIs may need extension points for advanced UIs.

## Alternatives Considered

### UI embedded in each service
Rejected — fragments operator experience and duplicates UI work.

### Shared UI library calling internal modules directly
Rejected — breaks independent deployability and language boundaries.

### Stable service API contracts (chosen)
Matches multi-frontend reality in `flossware-tftp-os` and supports a unified console.

## Reference implementation

- [tftp-os UI contract validation](../docs/architecture/reference-implementations/tftp-os-ui-contract.md)
- Upstream: [FlossWare/flossware-tftp-os](https://github.com/FlossWare/flossware-tftp-os)

## Related ADRs
- [ADR-0004](ADR-0004-mcp-tool-contracts.md) — MCP and Tool Contracts (agent path; UI path remains REST/OpenAPI)
- [ADR-0010](ADR-0010-rest-service-boundaries.md) — REST Service Boundaries
