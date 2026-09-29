# ADR-0027: Versioning, Tagging, and Releases

## Status

Proposed

## Date

2026-09-18

## Context

FlossWare repositories increasingly produce reusable contracts, implementations, libraries, services, documentation, and distributable artifacts. The ecosystem therefore needs a common way to distinguish source identity, release identity, and delivery metadata.

Git already provides immutable content identity through commit SHAs, while tags and GitHub Releases provide human-facing release identity and distribution metadata. Without a common policy, repositories can invent incompatible conventions, move tags after publication, or conflate repository releases with domain contracts, implementations, and runtime dependencies.

## Scope

This decision applies to FlossWare repositories that establish versioned compatibility or publish released software, contracts, libraries, services, schemas, protocols, or other durable artifacts.

## Non-goals

- It does not require every repository to publish releases.
- It does not make Git tags the source of truth.
- It does not define AI-domain contract semantics.
- It does not prescribe a package registry.
- It does not require every implementation detail to receive an independently visible version.

## Decision

### Identity layers

FlossWare SHALL distinguish:

| Identity | Purpose |
| --- | --- |
| Git commit SHA | Immutable identity of source state |
| Release version | Human-facing release identity |
| Git tag | Named binding of a release version to an exact Git object |
| GitHub Release | Distribution and release metadata associated with a tag |
| Artifact digest/checksum | Identity of a generated delivery artifact |

A release SHALL identify the exact source commit from which its artifacts were produced.

### Versioning policy

ADR-0026 is the canonical FlossWare release-version format: released FlossWare artifacts use exactly two numeric components, `X.Y`.

This ADR does not replace or weaken ADR-0026. Repositories MAY document additional compatibility metadata when required by an external ecosystem, but FlossWare's own release identity remains two-component.

A repository SHALL NOT introduce a version number merely because another repository has one.

Repositories that do not publish compatibility-bearing artifacts MAY remain unversioned and rely on Git commit identity.

Documentation, architecture notes, experiments, and internal tooling MAY use milestone or date-based identifiers when compatibility versioning is not meaningful.

### Git tags

Released versions SHALL be represented by Git tags.

Release tags SHOULD use the form `vX.Y` for artifacts governed by ADR-0026.

Tags SHALL identify the exact commit being released.

Release tags SHALL NOT be moved or reused after publication.

Annotated Git tags SHOULD be used for release versions so that the tag can carry release metadata and provenance.

Floating compatibility tags MAY be used only where a consumer ecosystem explicitly requires a moving compatibility reference. Such tags are not release identities and SHALL NOT replace immutable release-specific tags.

### Release creation

A release-bearing repository SHOULD follow this sequence:

1. Complete implementation and validation on a normal development branch.
2. Merge the release candidate into the repository's release branch, normally `main`.
3. Run required CI, conformance, security, and artifact validation.
4. Create the release-specific Git tag against the validated commit.
5. Generate release artifacts from that tagged source.
6. Verify artifact integrity and provenance.
7. Publish the GitHub Release and associated artifacts.
8. Record release notes describing externally relevant changes and compatibility impact.

A release SHALL NOT be represented as complete merely because a tag exists if required artifacts or validation have failed.

### Release notes

A published release SHOULD include release notes identifying:

- the release version;
- compatibility-impacting changes;
- new capabilities;
- relevant fixes;
- deprecations and removals;
- migration requirements where applicable;
- relevant documentation; and
- artifact or provenance information when useful.

Release notes are consumer documentation. Commit history remains the detailed engineering history.

### Changelog

Repositories with recurring public or cross-team releases SHOULD maintain a changelog or equivalent release-history document.

A changelog MAY be generated from release metadata, provided the resulting information remains understandable to consumers.

The changelog SHALL NOT become a second source of truth for source state. The release tag and commit remain authoritative.

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

Deprecated behavior SHOULD identify what is deprecated, the replacement when one exists, and the expected removal or compatibility horizon when known.

A version SHALL NOT be used to conceal an undocumented breaking change.

### Repository version versus domain contract version

A repository release version and a domain contract version are separate concepts.

A repository MAY release an implementation without changing the domain contract version.

A domain contract MAY change while multiple language implementations subsequently release compatible implementation versions.

For AI-domain contracts, FlossWare/loom-ai is authoritative for domain-specific versioning and compatibility rules.

### Implementation and runtime versions

Implementation versions, dependency versions, model versions, provider versions, and runtime versions SHALL NOT be conflated with the repository release version.

When these values affect reproducibility or behavior, release metadata SHOULD record them as provenance rather than embedding them into the repository version itself.

### Automation

Release automation SHOULD validate:

- version/tag consistency;
- that the tag resolves to the intended commit;
- required CI and conformance checks;
- artifact creation and installation;
- artifact integrity; and
- release metadata and provenance.

Automation SHOULD create releases only from validated source state.

Automation SHALL NOT silently move or reuse an existing release tag.

## Consequences

### Positive

- Source identity, release identity, and distribution metadata remain distinct.
- Consumers can identify exactly what source produced a release.
- FlossWare avoids artificial patch-version proliferation.
- Release tags become trustworthy immutable references.
- AI-domain versioning remains with Loom rather than being duplicated here.
- Release automation can enforce a consistent lifecycle across FlossWare.

### Negative

- Release-bearing repositories require additional release discipline.
- Immutable release tags make mistakes more visible.
- Some artifact ecosystems may require adapters around FlossWare's two-component release identity.
- Maintaining provenance and release notes adds work.

## Alternatives Considered

### Version every repository

Rejected. Not every repository represents a compatibility-bearing artifact.

### Use only Git commit SHAs

Rejected as the sole consumer-facing convention. Commit SHAs provide immutable identity but poor human-facing release semantics.

### Use only GitHub Releases

Rejected. Releases are distribution metadata built around Git tags; source identity must remain explicit.

### Allow mutable release tags

Rejected. A published version should continue to identify the same source.

### Mandate semantic versioning everywhere

Rejected. FlossWare explicitly does not maintain a separate patch-release category.

## Related ADRs

- ADR-0022 — Reproducible Build Artifacts and Distribution
- ADR-0024 — Contract-Centric Repository Layering and Naming
- ADR-0025 — AI Architecture Ownership
- ADR-0026 — Two-Component Release Versioning

AI-domain versioning and compatibility decisions are maintained in FlossWare/loom-ai.
