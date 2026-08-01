# ADR-0004: Event Driven Internal Bus

## Status
Accepted

## Decision
Internal integrations SHOULD use versioned events and pub/sub contracts where asynchronous communication improves modularity.

## Consequences
- Services remain loosely coupled.
- New consumers can subscribe without changing producers.
- Event schemas become managed contracts.
