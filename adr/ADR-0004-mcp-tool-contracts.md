# ADR-0004: MCP and Tool Contracts

> Formerly `docs/architecture/decisions/ADR-0003-mcp-tool-contracts.md`

## Status
Accepted

## Date
2026-07-31

## Context

AI agents need predictable discovery and invocation of capabilities across repositories, infrastructure, and services. Ad-hoc tool wiring per agent creates fragile integrations and unclear security boundaries.

## Decision

Tools SHALL expose explicit contracts.

- MCP-compatible interfaces SHOULD be preferred for **AI agent** capability discovery and invocation.
- MCP is **not** a replacement for REST/OpenAPI (external synchronous service contracts) or for internal service-to-service APIs.
- Layered model:
  - Agents → MCP (tool contracts)
  - External clients / UIs → REST + stable OpenAPI
  - Internal high-performance paths → gRPC or events as appropriate

## Consequences

### Positive
- Agents consume capabilities instead of implementations.
- Integrations become replaceable.
- Security boundaries become clearer (tool surface is explicit).

### Negative
- Dual contract maintenance (MCP for agents, OpenAPI for services) when the same capability is exposed both ways.
- MCP ecosystem maturity varies by language/runtime.

## Alternatives Considered

### OpenAPI-only for agents
Rejected as the sole agent contract — weaker standardized tool discovery/invocation compared to MCP for agent runtimes.

### Custom JSON-RPC / proprietary tool protocol
Rejected — higher integration cost and weaker ecosystem leverage.

### gRPC reflection as primary agent contract
Rejected for agent-facing tools — less agent-ecosystem alignment than MCP; still valid for internal service meshes.

### MCP for agents + OpenAPI for services (chosen)
Matches consumer needs without forcing one protocol everywhere.

## Related ADRs
- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
- [ADR-0007](ADR-0007-unified-service-ui-contract.md) — Unified Service UI Contract
