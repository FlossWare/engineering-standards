# ADR-0010: REST Service Boundaries and Integration Model

## Status
Accepted

## Date
2026-08-07

## Context

FlossWare needs a clear split between synchronous external contracts, agent-facing tool contracts, asynchronous internal integration, and data-layer responsibilities. Without boundaries, clients reach into databases, UIs embed service logic, and event flows become unclear.

## Decision

- **REST** SHALL be the default synchronous service contract for external clients where HTTP request/response semantics are appropriate ([ADR-0007](ADR-0007-unified-client-service-contract.md)).
- Clients SHALL NOT access databases directly. See [ADR-0007](ADR-0007-unified-client-service-contract.md) for the definition of *client* and the in-process library exception.
- Business capabilities SHALL be exposed through services.
- **MCP** SHOULD be used for AI-agent capability discovery and invocation ([ADR-0004](ADR-0004-mcp-tool-contracts.md), [ADR-0018](ADR-0018-mcp-capability-exposure.md)).
- MCP and REST MAY expose the same underlying capability; neither should duplicate business logic ([ADR-0020](ADR-0020-capability-protocol-separation.md)).
- **Asynchronous** communication SHOULD use versioned events on the internal bus ([ADR-0005](ADR-0005-event-driven-internal-bus.md)).
- Services SHOULD publish domain events after successful operations when downstream reaction is needed (subject to explicit opt-in, [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md)).
- Agent-facing tools SHALL be independently authorized and SHALL NOT inherit unrestricted service access merely because the agent can connect ([ADR-0019](ADR-0019-agent-tool-security-and-authorization.md)).

## Integration model

```text
                    Service Capability
                           |
              +------------+------------+
              |            |            |
             REST         MCP         Events
              |            |            |
          Applications   AI Agents    Services
```

The service/capability is the architectural boundary. Protocols are consumer-specific contracts.

## Consequences

### Positive
- Clear ownership of APIs, agent tools, events, and data.
- Independent deployability of services and clients.
- Consistent security boundary at the service edge.
- Existing agent runtimes can consume capabilities without requiring a FlossWare UI or agent implementation.

### Negative
- More upfront contract design work.
- Some capabilities need both REST and MCP contracts.
- Contract and authorization testing spans multiple protocol adapters.

## Alternatives Considered

### Direct DB access from clients
Rejected — breaks encapsulation and security.

### Events as the only external contract
Rejected — poor fit for request/response clients and agent tool invocation.

### MCP as the universal external contract
Rejected — MCP is optimized for agent tool interaction and should not replace appropriate service APIs or event contracts.

### REST + MCP + events with explicit boundaries (chosen)
Matches modular service and agent integration needs without forcing one protocol everywhere.

## Related ADRs
- [ADR-0004](ADR-0004-mcp-tool-contracts.md) — MCP and Tool Contracts
- [ADR-0005](ADR-0005-event-driven-internal-bus.md) — Event-Driven Internal Bus
- [ADR-0007](ADR-0007-unified-client-service-contract.md) — Unified Client-Service Contract
- [ADR-0011](ADR-0011-stored-procedure-database-access.md) — Stored Procedure Database Access
- [ADR-0018](ADR-0018-mcp-capability-exposure.md) — MCP Capability Exposure
- [ADR-0019](ADR-0019-agent-tool-security-and-authorization.md) — Agent Tool Security and Authorization
- [ADR-0020](ADR-0020-capability-protocol-separation.md) — Capability and Protocol Separation
