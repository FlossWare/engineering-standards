# ADR-0011: Stored Procedure Database Access Policy

## Status
Accepted

## Date
2026-08-05

## Context

Stored procedures can encapsulate set-based logic, transactions, and schema details. Overuse turns the database into an application server and hides orchestration that belongs in services or workflows.

## Scope

Data-access patterns for FlossWare services that use relational (or similar) databases.

## Non-goals

- Does not ban stored procedures.
- Does not prescribe a specific RDBMS or procedure language.

## Decision

### Stored procedures MAY contain

- Data integrity rules enforced close to the data
- Transactional data operations that are naturally data-centric
- Database-centric logic (set-based transforms, bulk updates, schema encapsulation)
- Stable data APIs that hide physical schema from callers
- Performance-critical operations that benefit from engine-side execution

### Stored procedures SHOULD NOT become

- The **sole** location for application orchestration
- Owners of **business workflows that span multiple systems** (external APIs, message buses, AI pipelines)
- Replacements for service-layer capability exposure ([ADR-0010](ADR-0010-rest-service-boundaries.md))
- Message routing / event-bus control planes ([ADR-0005](ADR-0005-event-driven-internal-bus.md))

### Hard boundaries

Stored procedures SHALL NOT replace:

- Service-layer orchestration
- AI workflows
- External integrations
- Message routing / event bus responsibilities

Services remain the authority for business capability exposure. Clients still MUST NOT call the database directly.

Goal: preserve benefits of database APIs without recreating tightly coupled database-centric architectures.

## Consequences

### Positive
- Performance and transactional integrity where the DB is the right tool.
- Schema evolution can be hidden behind procedure contracts.
- Clear MAY / SHOULD NOT split reduces “app in the database” drift.

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
