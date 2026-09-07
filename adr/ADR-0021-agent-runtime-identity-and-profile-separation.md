# ADR-0021: Agent Runtime Identity and Profile Separation

## Status

Accepted

## Date

2026-08-08

## Context

FlossWare and other organizational environments may use substantially similar agent runtime infrastructure: MCP clients, tool frameworks, LSP integrations, skills, shell integration, logging, and provider adapters.

The infrastructure itself does not need to be duplicated merely because the organizational context changes. The critical boundary is identity, policy, credentials, model/provider selection, and resource access.

A shared runtime must therefore support multiple explicit profiles without allowing one organization's identity or policy to bleed into another.

## Decision

Agent runtime infrastructure SHALL be reusable across organizational contexts, while organizational identity and policy SHALL be isolated through explicit runtime profiles.

A runtime profile represents an organizational/security context. At minimum, a profile MAY define:

- identity provider and identity namespace
- groups and roles
- allowed model providers
- allowed models
- credential references
- MCP endpoints and capability allowlists
- repository/resource boundaries
- quotas and budgets
- organization-specific policy

The runtime implementation SHALL NOT infer organizational identity from whichever credentials happen to be present in the environment.

### Shared infrastructure

The following SHOULD remain reusable across profiles where technically appropriate:

- agent runtime
- MCP client/server framework
- tool framework
- LSP integration
- skills
- shell integration
- logging and telemetry
- provider adapters
- configuration schema and validation mechanisms

### Profile isolation

Profiles SHALL be explicitly selected or established by an authenticated identity context.

A process running under one profile SHALL NOT silently fall back to another profile's credentials, models, repositories, MCP endpoints, or authorization policy.

Profile switching SHALL establish a new authenticated context rather than mutating credentials in place without validation.

### Organizational separation

Personal FlossWare infrastructure SHALL remain independent of employer-controlled identity, credentials, repositories, and proprietary resources.

Likewise, employer-controlled environments SHALL NOT depend on personal FlossWare identity, credentials, repositories, or services.

Shared open-source concepts, generic tooling, and public standards MAY be used in both environments provided doing so does not transfer restricted material or credentials across the boundary.

## Identity architecture

The architectural separation is:

```text
                   Common Agent Runtime
                           |
                  +--------+--------+
                  |                 |
             Red Hat Profile   FlossWare Profile
                  |                 |
             RH identity       Personal identity
             RH policy         FlossWare policy
             RH models         FlossWare models
             RH credentials   Personal credentials
```

The profile is the policy boundary. The runtime is not the organizational boundary.

## Identity provider

LDAP-compatible identity systems MAY be used to provide identity, groups, and role membership.

The architecture SHALL NOT require LDAP specifically. FreeIPA, OIDC, SAML, another directory service, or another standards-based identity provider MAY be used when appropriate.

Identity-provider selection is therefore an implementation/deployment decision, while identity isolation is an architectural requirement.

## Consequences

### Positive

- Agent infrastructure can be reused without mixing organizational contexts.
- Model and provider policy can differ without maintaining separate runtimes.
- Credential isolation becomes explicit and auditable.
- The architecture remains independent of a specific identity product.
- FlossWare can remain entirely independent of employer infrastructure.

### Negative

- Profile selection and validation become security-sensitive operations.
- Shared runtime components must be designed to avoid cross-profile state leakage.
- Configuration and identity systems require explicit testing for isolation.

## Alternatives Considered

### Separate agent installations for every organization

Rejected as the default — duplicates infrastructure and does not itself guarantee credential isolation.

### One global identity and credential namespace

Rejected — creates unacceptable organizational coupling and increases the blast radius of credential mistakes.

### LDAP as the architectural requirement

Rejected — LDAP is a suitable implementation option but the architecture should depend on identity and group semantics, not one product or protocol.

### Shared runtime with explicit identity profiles (chosen)

Provides reuse while preserving organizational boundaries.

## Related ADRs

- [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md) — Explicit Opt-In Cross-Cutting Behavior
- [ADR-0016](ADR-0016-configuration-as-source-of-truth.md) — Configuration as Source of Truth
- [ADR-0017](ADR-0017-agent-neutral-architecture.md) — Agent-Neutral Architecture
- [ADR-0019](ADR-0019-agent-tool-security-and-authorization.md) — Agent Tool Security and Authorization
