# ADR-0006: Unified Service UI Contract

## Status
Accepted

## Context
Projects such as PXEOS and TFTP OS require consistent operator experiences.

## Decision
User interfaces SHALL integrate through stable service APIs and contracts rather than embedding project-specific implementations.

## Consequences
- Services remain independently deployable.
- A unified UI can aggregate capabilities.
- Backend evolution does not require UI rewrites.
