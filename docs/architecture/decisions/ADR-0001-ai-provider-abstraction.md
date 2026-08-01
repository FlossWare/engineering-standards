# ADR-0001: AI Provider Abstraction

## Status
Accepted

## Context
FlossWare requires AI capabilities without coupling the platform to a single model vendor, runtime, or deployment topology.

## Decision
All AI capabilities SHALL be accessed through provider abstractions. Providers may include hosted APIs, free services, or local inference runtimes when explicitly enabled.

## Consequences
- No model vendor lock-in.
- Capabilities are selected through contracts.
- Local inference is an optional capability, not a requirement.
