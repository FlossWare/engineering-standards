# ADR-0026: Versioning, Tagging, and Releases

## Status

Proposed

## Date

2026-09-18

## Context

FlossWare repositories increasingly produce reusable contracts, implementations, libraries, services, documentation, and distributable artifacts. The ecosystem therefore needs a common way to distinguish source identity, compatibility identity, and released delivery outputs.

Git already provides immutable content identity through commit SHAs, while tags and GitHub Releases provide human-facing release identity and distribution metadata. Without a common policy, repositories can invent incompatible conventions, move tags after publication, or conflate repository versions with domain contract versions, implementation versions, and runtime dependency versions.

FlossWare also contains repositories that define contracts rather than distributable software. A single versioning scheme should therefore not force every repository, document, or commit to pretend that it is a releasable software artifact.

## Scope

This decision applies to FlossWare repositories that establish versioned compatibility or publish released software, contracts, libraries, services, schemas, protocols, or other durable artifacts.

It establishes the generic FlossWare policy for versioning, Git tags, releases, and release provenance.

AI-domain versioning and compatibility semantics remain governed by FlossWare/loom-ai.

## Non-goals

- Does not require every repository to publish releases.
- Does not make Git tags the source of truth.
- Does not define AI-domain contract semantics.
- Does not prescribe a particular package registry.
- Does not require every internal implementation detail to receive an independently visible version.
- Does not require documentation-only changes to receive software release versions.

## Decision

### Identity layers

FlossWare SHALL distinguish the following identities:

| Identity | Purpose |
| --- | --- |
| Git commit SHA | Immutable identity of source state |
| Version | Human-facing compatibility/release identity |
| Git tag | Named binding of a release version to an exact Git object |
| GitHub Release | Distribution and release metadata associated with a tag |
| Artifact digest/checksum | Identity of a generated delivery artifact |

A version SHALL NOT replace the commit SHA as the authoritative identity of source state.

A release SHALL identify the exact source commit from which its artifacts were produced.

### Versioning applicability

A repository SHALL use an explicit versioning policy when it publishes a compatibility-bearing artifact or release.

Repositories that do not publish such artifacts MAY remain unversioned and rely on Git commit identity.

Documentation, architecture notes, experiments, and internal tooling MAY use milestone or date-based identifiers when compatibility versioning is not meaningful.

A repository SHALL NOT introduce a version number merely because another repository has one.

### Compatibility versioning

Where a published artifact has a stable compatibility contract, FlossWare SHOULD use semantic versioning semantics:

- MAJOR indicates incompatible public API or contract changes.
- MINOR indicates backward-compatible functionality.
- PATCH indicates backward-compatible fixes.

Pre-1.0 versions SHALL be treated as development compatibility versions. During 0.x development, breaking changes MAY occur in minor releases and SHALL be documented.

Semantic versioning is a compatibility contract, not a statement about project maturity, quality, or importance.

For repositories where a simpler milestone sequence is more appropriate, human-facing milestones MAY use identifiers such as 0.1, 0.2, and 0.3. Such milestone identifiers SHALL NOT be presented as semantic-version compatibility guarantees unless the repository explicitly defines them as such.

When an ecosystem requires a three-component package version, a milestone such as 0.1 MAY correspond to a package release such as 0.1.0; the mapping SHALL be documented by that repository.

### Git tags

Released versions SHALL be represented by Git tags.

Release tags SHOULD use the form vMAJOR.MINOR.PATCH for artifacts using semantic versioning.

Tags SHALL identify the exact commit being released.

Release tags SHALL NOT be moved or reused after publication.

Annotated Git tags SHOULD be used for release versions so that the tag can carry release metadata and provenance.

Floating compatibility tags such as v1 or v1.2 MAY be used only where a consumer ecosystem explicitly requires a moving compatibility reference. Such tags are not release identities and SHALL NOT replace immutable release-specific tags.

### Release creation

A release-bearing repository SHOULD follow this sequence:

1. Complete implementation and validation on a normal development branch.
2. Merge the release candidate into the repository's release branch, normally main.
3. Run the required CI, conformance, security, and artifact validation.
4. Create the release-specific Git tag against the validated commit.
5. Generate the release artifacts from that tagged source.
6. Verify artifact integrity and provenance.
7. Publish the GitHub Release and associated artifacts.
8. Record release notes describing externally relevant changes and compatibility impact.

A release SHALL NOT be represented as complete merely because a tag exists if required artifacts or release validation have failed.

GitHub supports immutable releases that lock the release tag and assets after publication. FlossWare release-bearing repositories SHOULD enable and use immutable releases where supported.

### Release notes

A published release SHOULD include release notes.

Release notes SHOULD identify:

- The release version.
- Compatibility-impacting changes.
- New capabilities.
- Fixes relevant to consumers.
- Deprecations and removals.
- Migration requirements where applicable.
- Links to relevant documentation.
- Artifact or provenance information when useful.

Release notes are consumer documentation. Commit history remains the detailed engineering history.

### Changelog

Repositories with recurring public or cross-team releases SHOULD maintain a changelog or equivalent release-history document.

A changelog MAY be generated from release metadata, provided the resulting information remains understandable to consumers.

The changelog SHALL NOT become a second source of truth for source state. The release tag and commit remain authoritative for identifying the released source.

### Artifact provenance

Released artifacts SHOULD provide enough provenance to identify:

- Repository.
- Release version.
- Git commit SHA or release tag.
- Build workflow or release process.
- Relevant build and dependency inputs.
- Integrity information such as checksums or registry digests.

Generated artifacts SHALL remain derived outputs. Repository source and authoritative configuration remain the source of truth, consistent with ADR-0022.

### Compatibility and deprecation

A release that changes a public contract SHALL document the compatibility impact.

Breaking changes SHOULD include migration guidance when practical.

Deprecated behavior SHOULD identify:

- What is deprecated.
- The replacement, when one exists.
- The expected removal or compatibility horizon when known.

A version SHALL NOT be used to conceal an undocumented breaking change.

### Repository version versus domain contract version

A repository version and a domain contract version are separate concepts.

A repository MAY release an implementation without changing the domain contract version.

A domain contract MAY change while multiple language implementations subsequently release compatible implementation versions.

For AI-domain contracts, FlossWare/loom-ai is authoritative for the domain-specific versioning and compatibility rules.

### Implementation and runtime versions

Implementation versions, dependency versions, model versions, provider versions, and runtime versions SHALL NOT be conflated with the repository's release version.

When these values affect reproducibility or behavior, release metadata SHOULD record them as provenance rather than embedding them into the repository version itself.

### Automation

Release automation SHOULD validate:

- Version/tag consistency.
- That the tag resolves to the intended commit.
- Required CI and conformance checks.
- Artifact creation and installation.
- Artifact integrity.
- Release metadata and provenance.

Automation SHOULD create releases only from validated source state.

Automation SHALL NOT silently move or reuse an existing release tag.

## Consequences

### Positive

- Source identity, compatibility identity, and distribution metadata remain distinct.
- Consumers can identify exactly what source produced a release.
- Repositories can use versioning when it has semantic value without forcing artificial versions on everything.
- Release tags become trustworthy immutable references.
- AI-domain versioning remains with Loom rather than being duplicated here.
- Release automation can enforce a consistent lifecycle across FlossWare.

### Negative

- Release-bearing repositories require additional release discipline.
- Immutable releases make mistakes more visible because published tags cannot simply be moved.
- Different artifact ecosystems may require different concrete version representations.
- Maintaining provenance and release notes adds work.

## Alternatives Considered

### Version every repository

Rejected. Not every repository represents a compatibility-bearing artifact, and artificial versioning adds noise rather than useful information.

### Use only Git commit SHAs

Rejected as the sole consumer-facing convention. Commit SHAs provide excellent immutable identity but poor human-facing compatibility semantics.

### Use only GitHub Releases

Rejected. Releases are distribution metadata built around Git tags; the underlying source identity must remain explicit.

### Allow mutable release tags

Rejected. A consumer should be able to trust that a published version continues to identify the same source and artifacts.

### Mandate one version scheme for every artifact type

Rejected. Software packages, contracts, documentation, and internal experiments do not all have identical compatibility semantics.

## Related ADRs

- ADR-0022 — Reproducible Build Artifacts and Distribution
- ADR-0024 — Contract-Centric Repository Layering and Naming
- ADR-0025 — AI Architecture Ownership

AI-domain versioning and compatibility decisions are maintained in FlossWare/loom-ai.
