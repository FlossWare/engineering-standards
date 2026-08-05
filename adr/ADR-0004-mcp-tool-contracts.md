# ADR-0004: MCP and Tool Contracts

> Formerly `docs/architecture/decisions/ADR-0003-mcp-tool-contracts.md`

## Status
Accepted

## Date
2026-07-31

## Context
AI agents need predictable access to capabilities across repositories, infrastructure, and services.

## Decision
Tools SHALL expose explicit contracts. MCP-compatible interfaces are preferred for agent capability discovery and invocation.

## Consequences
- Agents consume capabilities instead of implementations.
- Integrations become replaceable.
- Security boundaries become clearer.

## Related ADRs
- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
