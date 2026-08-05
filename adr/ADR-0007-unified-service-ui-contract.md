# ADR-0007: Unified Service UI Contract

> Formerly `docs/architecture/decisions/ADR-0006-unified-service-ui-contract.md`

## Status
Accepted

## Date
2026-07-31

## Context
Projects such as PXEOS and TFTP OS require consistent operator experiences.

## Decision
User interfaces SHALL integrate through stable service APIs and contracts rather than embedding project-specific implementations.

## Consequences
- Services remain independently deployable.
- A unified UI can aggregate capabilities.
- Backend evolution does not require UI rewrites.

## Related ADRs
- See also validation against `flossware-tftp-os` multi-frontend implementation.
