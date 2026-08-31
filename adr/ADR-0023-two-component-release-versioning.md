# ADR-0023: Two-Component Release Versioning

## Status
Accepted

## Date
2026-08-31

## Context

FlossWare projects need a simple, consistent release-version convention. Conventional three-component semantic versioning (`MAJOR.MINOR.PATCH`) adds distinctions that FlossWare does not intend to maintain. FlossWare treats Git history and commit identifiers as the precise implementation history; release versions are human-facing markers for successive released states.

The ecosystem therefore needs a minimal versioning rule that avoids patch-level version proliferation while still distinguishing major compatibility milestones from ordinary updates.

## Decision

FlossWare releases SHALL use exactly two numeric components:

`X.Y`

The version progression SHALL be:

`0.1 → 0.2 → 0.3 → ... → 1.0 → 1.1 → 1.2 → ...`

### Version rules

- The version SHALL contain exactly two components.
- The first component (`X`) identifies the major compatibility/stability generation.
- The second component (`Y`) identifies the successive release/update within that generation.
- FlossWare SHALL NOT publish patch versions such as `0.1.1`, `1.2.3`, or equivalent three-component forms.
- Every release/update increments `Y` by one within the current major generation.
- `0.x` denotes pre-1.0 development and does not imply semantic-version patch/minor behavior.
- `1.0` denotes the first stable major release.
- A change to `X` is reserved for a major compatibility or stability milestone and is not used for ordinary updates.
- Git commit SHAs remain the authoritative immutable identifiers for exact source state; release versions are human-facing release identifiers.

### Applicability

This convention applies to FlossWare repositories that publish versioned software or other release artifacts. Repositories that do not expose a release version MAY use Git commit identity alone.

Build and distribution systems MUST preserve the repository's two-component release version and MUST NOT silently transform it into a three-component SemVer-style version.

## Consequences

### Positive

- Simple release progression that is easy to understand and communicate.
- No meaningless patch-level version proliferation.
- Clear distinction between pre-1.0 and stable generations.
- Git remains responsible for precise implementation history.
- Consistent versioning across the FlossWare ecosystem.

### Negative

- Consumers cannot infer a separate patch-level category from the release number.
- Some third-party tooling assumes three-component semantic versions and may require explicit compatibility configuration.
- The project must treat the second component as the release sequence rather than assigning separate patch semantics.

## Alternatives Considered

### Semantic Versioning (`X.Y.Z`)

Rejected because FlossWare does not intend to maintain a separate patch-release category.

### Date-based versions

Rejected because FlossWare wants release sequence and major-generation information rather than calendar identity.

### Sequential single-component versions

Rejected because retaining the major-generation component provides useful information about compatibility/stability milestones.

## Related ADRs

- [ADR-0022](ADR-0022-reproducible-build-artifacts-and-distribution.md) — Reproducible Build Artifacts and Distribution
- [ADR-0016](ADR-0016-configuration-as-source-of-truth.md) — Configuration as Source of Truth
