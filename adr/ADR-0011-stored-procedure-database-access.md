# ADR-0011: Stored Procedure Database Access Policy

## Status
Accepted

## Date
2026-08-05

## Context

Stored procedures can encapsulate set-based logic, transactions, and schema details. Overuse turns the database into an application server and hides orchestration that belongs in services or workflows.

## Decision

Stored procedures SHOULD be used where they provide clear value:

- Database abstraction / stable data API for services
- Transaction boundaries that are naturally data-centric
- Complex set-based operations
- Performance-critical data operations
- Encapsulation of schema changes behind a stable procedure contract

Stored procedures SHALL NOT replace:

- Service-layer orchestration
- AI workflows
- External integrations
- Message routing / event bus responsibilities

Services remain the authority for business capability exposure ([ADR-0010](ADR-0010-rest-service-boundaries.md)). Clients still MUST NOT call the database directly.

## Consequences

### Positive
- Performance and transactional integrity where the DB is the right tool.
- Schema evolution can be hidden behind procedure contracts.

### Negative
- Logic split across service and DB requires discipline and testing strategy.
- Portability across database engines may decrease.

## Alternatives Considered

### No stored procedures
Rejected as absolute — leaves real set-based/transactional cases awkward.

### Stored procedures as primary application layer
Rejected — obscures orchestration and harms modularity.

### Selective use with service-owned boundaries (chosen)
Keeps DB strengths without relocating the application into SQL.

## Related ADRs
- [ADR-0010](ADR-0010-rest-service-boundaries.md)
- [ADR-0005](ADR-0005-event-driven-internal-bus.md)
