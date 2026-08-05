# ADR-0010: REST Service Boundaries and Integration Model

## Status
Accepted

## Date
2026-08-05

## Context

FlossWare needs a clear split between synchronous external contracts, asynchronous internal integration, and data-layer responsibilities. Without boundaries, clients reach into databases, UIs embed service logic, and event flows become unclear.

## Decision

- **REST** SHALL be the default synchronous external contract for clients and operator UIs ([ADR-0007](ADR-0007-unified-service-ui-contract.md)).
- Clients SHALL NOT access databases directly.
- Business capabilities SHALL be exposed through services.
- **Asynchronous** communication SHOULD use versioned events on the internal bus ([ADR-0005](ADR-0005-event-driven-internal-bus.md)).
- Services SHOULD publish domain events after successful operations when downstream reaction is needed (subject to explicit opt-in, [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md)).
- Agent-facing tools SHOULD use MCP ([ADR-0004](ADR-0004-mcp-tool-contracts.md)); that path does not replace REST for human/operator clients.

## Consequences

### Positive
- Clear ownership of APIs vs events vs data.
- Independent deployability of services and UIs.
- Consistent security boundary at the service edge.

### Negative
- More upfront API design work.
- Some use cases need both REST and events for the same capability.

## Alternatives Considered

### Direct DB access from clients
Rejected — breaks encapsulation and security.

### Events as the only external contract
Rejected — poor fit for request/response operator UX.

### REST + events with explicit boundaries (chosen)
Matches existing multi-frontend and modular service goals.

## Related ADRs
- [ADR-0005](ADR-0005-event-driven-internal-bus.md)
- [ADR-0007](ADR-0007-unified-service-ui-contract.md)
- [ADR-0011](ADR-0011-stored-procedure-database-access.md)
