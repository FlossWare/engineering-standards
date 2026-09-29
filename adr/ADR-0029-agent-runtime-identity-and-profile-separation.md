# ADR-0029: Agent Runtime Identity and Profile Separation

## Status

Proposed

## Date

2026-09-29

## Scope

This ADR applies to agent runtime infrastructure that may be reused across organizational or security contexts, including MCP clients, tool frameworks, LSP integrations, skills, shell integration, logging, telemetry, and provider adapters.

## Non-goals

- It does not require a specific identity provider.
- It does not prescribe one deployment topology.
- It does not permit sharing credentials or protected resources merely because runtime code is shared.

## Context

FlossWare and other organizational environments may use substantially similar agent runtime infrastructure. The infrastructure itself does not need to be duplicated merely because the organizational context changes.

The critical boundary is identity, policy, credentials, model/provider selection, and resource access. A shared runtime therefore needs explicit profiles without allowing one organization's identity or policy to bleed into another.

## Decision

Agent runtime infrastructure SHALL be reusable across organizational contexts, while organizational identity and policy SHALL be isolated through explicit runtime profiles.

A runtime profile represents an organizational/security context. A profile MAY define:

- identity provider and identity namespace;
- groups and roles;
- allowed model providers;
- allowed models;
- credential references;
- MCP endpoints and capability allowlists;
- repository/resource boundaries;
- quotas and budgets; and
- organization-specific policy.

The runtime implementation SHALL NOT infer organizational identity from whichever credentials happen to be present in the environment.

### Shared infrastructure

The following SHOULD remain reusable across profiles where technically appropriate:

- agent runtime;
- MCP client/server framework;
- tool framework;
- LSP integration;
- skills;
- shell integration;
- logging and telemetry;
- provider adapters; and
- configuration schema and validation.

### Profile isolation

Profiles SHALL be explicitly selected or established by an authenticated identity context.

A process running under one profile SHALL NOT silently fall back to another profile's credentials, models, repositories, MCP endpoints, or authorization policy.

Profile switching SHALL establish a new authenticated context rather than mutating credentials in place without validation.

### Organizational separation

Personal FlossWare infrastructure SHALL remain independent of employer-controlled identity, credentials, repositories, and proprietary resources.

Likewise, employer-controlled environments SHALL NOT depend on personal FlossWare identity, credentials, repositories, or services.

Shared open-source concepts, generic tooling, and public standards MAY be used in both environments provided doing so does not transfer restricted material or credentials across the boundary.

## Consequences

### Positive

- Agent infrastructure can be reused without mixing organizational contexts.
- Model and provider policy can differ without maintaining separate runtimes.
- Credential isolation becomes explicit and auditable.
- The architecture remains independent of a specific identity product.

### Negative

- Profile selection and validation become security-sensitive operations.
- Shared runtime components must avoid cross-profile state leakage.
- Configuration and identity systems require explicit isolation tests.

## Alternatives Considered

### Separate agent installations for every organization

Rejected as the default. Duplication does not itself guarantee credential isolation.

### One global identity and credential namespace

Rejected. It creates unnecessary organizational coupling and increases the blast radius of credential mistakes.

### LDAP as the architectural requirement

Rejected. Identity isolation is the architectural requirement; LDAP, FreeIPA, OIDC, SAML, or another suitable provider is an implementation choice.

### Shared runtime with explicit identity profiles

Chosen. It provides reuse while preserving organizational boundaries.

## Related ADRs

- ADR-0016 — Configuration as Source of Truth
- ADR-0017 — Agent-Neutral Architecture
- ADR-0019 — Agent Tool Security and Authorization
- ADR-0028 — Standalone AI Components
- ADR-0030 — Provider Credential and Model Policy Isolation
