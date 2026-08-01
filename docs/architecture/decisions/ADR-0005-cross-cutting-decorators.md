# ADR-0005: Cross Cutting Decorators

## Status
Accepted

## Decision
Cross-cutting concerns SHOULD use decorators, interceptors, or equivalent middleware patterns.

Examples include:
- logging
- metrics
- tracing
- auditing
- persistence
- retries

## Consequences
Business logic remains focused while operational behavior stays consistent.
