# ADR-0014: Token Budget Management

## Status
Accepted

## Date
2026-08-05

## Context

AI model APIs charge per token (input and output) or enforce context window limits and rate limits. Without active token management:

- Paid model costs scale linearly with prompt verbosity, and long conversations or large code reviews can become expensive.
- Free-tier models hit rate limits (tokens per minute/day) faster with uncompressed prompts.
- Models with smaller context windows silently truncate inputs, producing degraded outputs without warning.

Token compression (reducing input token count while preserving semantic content) is a cross-cutting concern that affects all AI interactions but should not be mandated globally — some tasks require exact prompts (e.g., code generation with precise specifications), and compression overhead may exceed savings on short prompts.

Internal FlossWare evaluations of compression on typical prompts observed modest savings on structured/JSON-heavy inputs, little benefit on very short prompts, and the need to compress **before** framework augmentation so system instructions are not stripped. These are **internal operational observations**, not externally published benchmarks; thresholds below are starting points to tune per workload.

## Decision

Token budget management SHALL be an explicit, opt-in cross-cutting capability ([ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md)).

### Opt-in activation

- Compression SHALL NOT be applied by default.
- Call sites opt in via an explicit parameter (e.g., `compress=True`).
- The compression implementation SHOULD be injected as a decorator or middleware ([ADR-0006](ADR-0006-cross-cutting-decorators.md)), not embedded in business logic.

### Compression ordering

- Compression SHALL be applied to the raw user/application prompt BEFORE any framework-added augmentation (chain-of-thought prefixes, system instructions, tool descriptions).
- The compressed output SHALL be validated: it MUST retain at least 10% of the original content length as a safety floor. If compression produces degenerate output (empty or near-empty), the original prompt SHALL be used unchanged.

### Dual-context evaluation

When evaluating token management tools or strategies, teams SHALL score separately for:

- **Free-tier context** — value is context window utilization and rate limit headroom. Cost savings are zero.
- **Paid/metered context** — value includes all of the above PLUS direct cost reduction. Features that are marginal for free tiers (output compression, cache alignment, reversible compression) may be critical for paid models.

### Budget tracking

- Systems SHOULD track tokens_before, tokens_after, tokens_saved, and compression_ratio per request.
- Compression statistics SHOULD be included in observability and cost monitoring pipelines.
- Bandit-based routing ([ADR-0013](ADR-0013-bandit-based-model-selection.md)) MAY incorporate compression ratio as a secondary reward signal.

### Thread safety

- Compression configuration (thresholds, model mappings, strategy selection) SHALL be thread-safe.
- Shared configuration objects SHOULD use thread-safe initialization patterns appropriate to the language runtime (e.g., synchronized singletons, once-init primitives).

## Consequences

### Positive
- Reduces cost on paid/metered APIs proportional to compression ratio.
- Extends effective context window on models with smaller limits.
- Reduces rate limit pressure on free-tier providers.
- Opt-in design avoids degrading tasks that require exact prompts.
- Dual-context scoring prevents undervaluing compression tools in mixed (free + paid) environments.

### Negative
- Compression adds latency per request (typically small but measurable).
- Lossy compression may remove semantically important content in edge cases.
- Requires a compression library dependency (additional supply chain surface).
- Short prompts see no benefit but still pay the overhead if opt-in is too coarse-grained.

## Alternatives Considered

### Always-on compression for all prompts
Rejected — degrades exact-prompt tasks (code generation, structured output) and wastes overhead on short prompts.

### No compression; rely on model context limits
Rejected — leaves cost savings on the table for paid models and hits rate limits unnecessarily on free tiers.

### Opt-in compression with dual-context scoring (chosen)
Balances savings with precision; ensures tools are properly valued in both free and paid environments.

## Related ADRs
- [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md) — Explicit Opt-In Cross-Cutting Behavior
- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
- [ADR-0006](ADR-0006-cross-cutting-decorators.md) — Cross-Cutting Decorators
- [ADR-0008](ADR-0008-free-first-modular-platform.md) — Free-First Modular Platform
- [ADR-0013](ADR-0013-bandit-based-model-selection.md) — Bandit-Based Model Selection
