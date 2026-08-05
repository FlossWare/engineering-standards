# ADR-0002: AI Provider Abstraction

> Formerly `docs/architecture/decisions/ADR-0001-ai-provider-abstraction.md`

## Status
Accepted

## Date
2026-07-31

## Context
FlossWare requires AI capabilities without coupling the platform to a single model vendor, runtime, or deployment topology.

## Decision
All AI capabilities SHALL be accessed through provider abstractions. Providers may include hosted APIs, free services, or local inference runtimes when explicitly enabled.

## Consequences
- No model vendor lock-in.
- Capabilities are selected through contracts.
- Local inference is an optional capability, not a requirement.

## Related ADRs
- [ADR-0003](ADR-0003-no-local-inference-default.md) — No Local Inference by Default
- [ADR-0004](ADR-0004-mcp-tool-contracts.md) — MCP and Tool Contracts
