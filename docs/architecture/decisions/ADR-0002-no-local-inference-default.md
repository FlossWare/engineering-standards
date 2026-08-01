# ADR-0002: No Local Inference by Default

## Status
Accepted

## Context
AI systems should remain usable across small infrastructure, cloud environments, and developer workstations.

## Decision
Local inference SHALL NOT be the default execution path. Systems SHALL prefer configured providers and use local models only when explicitly enabled.

## Consequences
- Lower infrastructure requirements.
- Easier deployment.
- Hardware becomes an optimization option rather than a prerequisite.
