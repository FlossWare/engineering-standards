# ADR-0003: MCP and Tool Contracts

## Status
Accepted

## Context
AI agents need predictable access to capabilities across repositories, infrastructure, and services.

## Decision
Tools SHALL expose explicit contracts. MCP-compatible interfaces are preferred for agent capability discovery and invocation.

## Consequences
- Agents consume capabilities instead of implementations.
- Integrations become replaceable.
- Security boundaries become clearer.
