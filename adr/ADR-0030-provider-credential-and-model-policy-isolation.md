# ADR-0030: Provider Credential and Model Policy Isolation

## Status

Proposed

## Date

2026-09-29

## Scope

This ADR applies to agent runtimes and provider adapters that operate across multiple organizational profiles or AI providers.

## Non-goals

- It does not select specific providers.
- It does not define provider-specific API implementations.
- It does not replace adaptive model-selection or service-discovery architecture.

## Context

FlossWare agent infrastructure may consume multiple AI providers and models. Different profiles may use different providers, model allowlists, quotas, and credentials while sharing runtime and provider adapter implementations.

Credentials are security material and must not become the mechanism by which organizational policy is inferred. Model selection is also policy, not merely an incidental consequence of which API keys happen to exist on a machine.

## Decision

Provider credentials, provider endpoints, model policy, and runtime identity SHALL be represented as separate concerns.

### Credential references

Configuration SHALL reference credentials by logical identity rather than embedding secret values.

```yaml
provider: anthropic
credential: flossware-anthropic
```

The credential reference identifies a secret managed by an appropriate credential mechanism. The actual secret SHALL NOT be committed to source-controlled configuration.

### Credential isolation

Credentials SHALL be scoped to an explicit organizational profile.

A credential SHALL NOT be usable by a profile that is not authorized to use it. Credential lookup SHALL fail closed when the active profile does not have access.

### Model policy

Model availability SHALL be controlled by profile policy rather than credential presence.

The existence of an API key SHALL NOT imply that its provider or models are approved for the current profile.

### Provider adapters

Provider adapters SHOULD remain shared and reusable. They SHALL receive credentials and policy through explicit dependency/configuration injection.

Provider adapters SHALL NOT contain organization-specific credentials or hardcoded organizational policy.

### Model selection

Adaptive model selection and dynamic discovery SHALL operate only over models permitted by the active profile's policy.

The effective selection pipeline is:

```
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
- Credential rotation SHOULD NOT require application-code or model-selection changes.

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

Rejected. This turns credential presence into accidental policy.

### Hardcode provider/model policy in provider adapters

Rejected. This couples reusable adapters to organizations and environments.

### Separate runtime for each provider/profile

Rejected. It duplicates infrastructure and does not model policy cleanly.

### Explicit profile policy plus isolated credential references

Chosen. It preserves reusable infrastructure while keeping organizational identity, authorization, and secrets separate.

## Related ADRs

- ADR-0002 — AI Provider Abstraction
- ADR-0013 — Adaptive Model Selection
- ADR-0015 — Dynamic Service Discovery for AI Models
- ADR-0016 — Configuration as Source of Truth
- ADR-0019 — Agent Tool Security and Authorization
- ADR-0029 — Agent Runtime Identity and Profile Separation
