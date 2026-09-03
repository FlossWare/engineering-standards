# ADR-0023: Canonical FlossWare AI Persistent State Root

## Status
Proposed

## Date
2026-09-02

## Context

FlossWare AI tooling needs persistent state that survives cleanup or replacement of Git working trees. Profiles, directory bindings, provider/account/model metadata, setup-managed Crush state, and runtime state must not be scattered across repositories or competing user-data locations.

The current setup implementation uses `~/.flossware/ai` as its default root. The desired canonical location is `~/.FlossWare/ai`, preserving the user's existing configuration while making the ownership boundary explicit.

## Scope

This decision applies to FlossWare AI setup and the components that consume its configuration/state contracts, including `agent-setup`, `agent-ai`, `model-router-ai`, `consensus-ai`, and `crush-demo`.

## Non-goals

- Does not redesign model routing, provider selection, consensus, or agent orchestration.
- Does not require Loom.
- Does not move Git repositories into the state directory.
- Does not make credential secret values part of FlossWare state.
- Does not automatically delete legacy state.

## Decision

`~/.FlossWare/ai` SHALL be the canonical persistent FlossWare AI state root.

`FLOSSWARE_AI_HOME` MAY override the root for tests, CI, containers, and unusual installations. The override SHALL take precedence over the default and SHALL be resolved consistently by all setup-managed components.

The conceptual state layout is:

```text
~/.FlossWare/ai/
├── profiles/
├── providers/
├── accounts/
├── models/
├── credentials/   # references/metadata only; never secret values
├── config/
├── crush/
├── cache/         # disposable and regenerable
└── state/
```

The exact layout MAY use existing abstractions rather than creating duplicate stores. All persistent setup-managed AI state SHALL remain below the canonical root.

Git repositories SHALL own source code and repository-local development artifacts. They SHALL NOT become an alternative authority for persistent FlossWare AI account, model, provider, or profile state.

Credential secret values SHALL remain in authoritative environment, native credential, or agent-owned stores. FlossWare state MAY contain credential references or presence metadata where required by an existing contract, but SHALL NOT contain API keys, OAuth tokens, passwords, or equivalent secret material.

Migration from the legacy `~/.flossware/ai` location SHALL be non-destructive, idempotent, and conflict-aware. Migration SHALL preserve supported profile and configuration state. Conflicting records SHALL be surfaced rather than silently merged or overwritten. Legacy state SHALL remain available until the operator explicitly removes it.

Disposable caches SHOULD be separated from persistent state under `cache/` and MAY be safely regenerated.

`agent-setup` is the canonical owner of setup/profile/configuration state. Other components SHALL consume its contract rather than establish competing persistent roots.

## Consequences

### Positive

- One predictable location for persistent AI configuration and state.
- Repository cleanup cannot accidentally remove user AI configuration.
- Free-provider/account/model configuration survives replacement of working trees.
- Tests and CI can redirect state deterministically.
- Credentials remain outside configuration state.
- Disposable cache data can be removed without losing configuration.

### Negative

- Migration logic is required for existing installations.
- Operators must distinguish persistent state from disposable cache data.
- Components with hard-coded legacy paths require updates.

## Alternatives Considered

### Continue using `~/.flossware/ai`

Rejected because it conflicts with the desired canonical naming convention and leaves the state-root contract less explicit.

### Store state inside each Git repository

Rejected because repository cleanup, multiple working trees, and cloned projects would duplicate or destroy user-level configuration.

### Use platform-specific XDG/application-data locations as the primary root

Rejected for this FlossWare-specific tooling because a single explicit cross-platform convention is easier to document and inspect. Platform-native credential stores remain appropriate for secrets.

### Canonical `~/.FlossWare/ai` with explicit override and safe migration

Chosen because it gives FlossWare AI one durable ownership boundary while preserving existing user state and testability.

## Related ADRs

- [ADR-0016](ADR-0016-configuration-as-source-of-truth.md) — Configuration as Source of Truth
- [ADR-0021](ADR-0021-provider-neutral-ai-selection.md) — Provider-Neutral AI Selection
- [ADR-0022](ADR-0022-reproducible-build-artifacts-and-distribution.md) — Reproducible Build Artifacts and Distribution
- [ADR-0020](ADR-0020-capability-protocol-separation.md) — Capability and Protocol Separation
- `FlossWare/agent-setup#84` — Canonical persistent AI state root implementation
