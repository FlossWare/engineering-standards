# ADR-0022: Provider Credential and Model Policy Isolation

## Status

Accepted

## Date

2026-08-08

## Context

FlossWare agent infrastructure may consume multiple AI providers and models. Different organizational profiles may use different providers, model allowlists, quotas, and credentials while sharing the same runtime and provider adapter implementations.

Credentials are security material and must not become the mechanism by which organizational policy is inferred. Model selection is also policy, not merely an incidental consequence of which API keys happen to exist on a machine.

## Decision

Provider credentials, provider endpoints, model policy, and runtime identity SHALL be represented as separate concerns.

### Credential references

Configuration SHALL reference credentials by logical identity rather than embedding secret values.

Example:

```yaml
provider: anthropic
credential: flossware-anthropic
```

The credential reference identifies a secret managed by an appropriate secret store or credential mechanism. The actual secret SHALL NOT be committed to source-controlled configuration.

### Credential isolation

Credentials SHALL be scoped to an explicit organizational profile.

A Red Hat credential SHALL NOT be usable by a FlossWare profile, and a FlossWare credential SHALL NOT be usable by a Red Hat profile, unless a separate explicitly authorized trust relationship exists.

Credential lookup SHALL fail closed when the requested profile does not have access.

### Model policy

Model availability SHALL be controlled by profile policy rather than by credential presence.

For example:

```yaml
profile: redhat
allowed_providers:
  - anthropic
```

and:

```yaml
profile: flossware
allowed_providers:
  - anthropic
  - openai
  - google
```

The existence of an API key SHALL NOT imply that its provider or models are approved for the current profile.

### Provider adapters

Provider adapters SHOULD remain shared and reusable. They SHALL receive credentials and policy through explicit dependency/configuration injection.

Provider adapters SHALL NOT contain organization-specific credentials or hardcoded organizational policy.

### Model selection

Model selection remains subject to the existing adaptive model-selection and dynamic-discovery architecture ([ADR-0013](ADR-0013-bandit-based-model-selection.md), [ADR-0015](ADR-0015-dynamic-service-discovery-ai-models.md)).

Those mechanisms SHALL operate only over the models permitted by the active profile's policy.

The effective selection pipeline is therefore:

```text
Identity
   ↓
Profile
   ↓
Provider/model policy
   ↓
Verified inventory
   ↓
Adaptive selection
   ↓
Credential resolution
   ↓
Provider call
```

### Secret handling

- Secrets SHALL NOT be written to logs, telemetry, model prompts, MCP tool results, or generated configuration.
- Credential identifiers MAY be logged where useful for audit, provided they do not disclose secret material.
- Credential rotation SHOULD NOT require changes to application code or model-selection logic.

## Consequences

### Positive

- The same runtime can serve multiple organizational profiles safely.
- Model policy is explicit and reviewable.
- API-key presence cannot accidentally broaden model access.
- Credentials can be rotated independently of application code.
- Provider adapters remain organization-neutral.

### Negative

- Credential and profile policy must be maintained explicitly.
- Secret-store integration adds operational infrastructure.
- Isolation must be tested, particularly when runtime processes can switch profiles.

## Alternatives Considered

### Credentials determine available providers

Rejected — creates accidental policy and makes credential leakage equivalent to policy escalation.

### Hardcode provider/model policy in provider adapters

Rejected — couples reusable adapters to organizations and environments.

### Separate runtime for each provider/profile

Rejected — unnecessary duplication and does not solve policy modeling cleanly.

### Explicit profile policy plus isolated credential references (chosen)

Provides reusable infrastructure while keeping organizational identity, authorization, and secrets separate.

## Related ADRs

- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
- [ADR-0003](ADR-0003-no-local-inference-default.md) — No Local Inference by Default
- [ADR-0008](ADR-0008-free-first-modular-platform.md) — Free-First Modular Platform
- [ADR-0013](ADR-0013-bandit-based-model-selection.md) — Adaptive Model Selection
- [ADR-0015](ADR-0015-dynamic-service-discovery-ai-models.md) — Dynamic Service Discovery for AI Models
- [ADR-0016](ADR-0016-configuration-as-source-of-truth.md) — Configuration as Source of Truth
- [ADR-0019](ADR-0019-agent-tool-security-and-authorization.md) — Agent Tool Security and Authorization
- [ADR-0021](ADR-0021-agent-runtime-identity-and-profile-separation.md) — Agent Runtime Identity and Profile Separation
