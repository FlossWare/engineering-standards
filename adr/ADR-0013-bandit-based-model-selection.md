# ADR-0013: Bandit-Based Model Selection

## Status
Accepted

## Date
2026-08-05

## Context

With hundreds of AI models available across free and paid providers, static model assignment (hardcoded routing tables, fixed priority lists) cannot adapt to:

- Models that degrade or go offline without notice.
- New models that appear in provider catalogs.
- Task-type-specific strengths (some models excel at math, others at code generation).
- Provider rate limits and availability that shift throughout the day.

A routing strategy is needed that balances **exploitation** (use the best known model) with **exploration** (try lesser-known models to discover if they are better), while adapting to real-time performance signals.

Internal FlossWare evaluations of multi-model routing observed that Thompson Sampling (Beta priors) performed well relative to simpler heuristics (e.g. epsilon-greedy), that modest exploration and observation caps helped adapt to drift, and that single-lineage pools were more prone to correlated failure modes. These are **internal operational observations**, not externally published reproducible research; specific hyperparameter values below are starting points, not universal optima.

## Decision

Model selection for AI workloads SHOULD use a multi-armed bandit strategy, specifically Thompson Sampling with Beta priors.

### Core mechanism

- Each model maintains a Beta(alpha, beta) distribution representing observed success/failure.
- On each request, sample from each model's distribution; select the highest sample.
- An epsilon parameter (a value of 0.10 SHOULD be used as a starting point) forces random exploration to prevent premature convergence.
- An observation cap — the maximum combined alpha + beta before rescaling — SHOULD be set to approximately 50 as a starting point. This decays old observations so the bandit adapts to model drift rather than being dominated by historical performance.

### Reward signal

- Reward SHALL be based on objective, mechanically verifiable criteria when possible (correct answer, successful API call, response within latency budget).
- Subjective quality scores MAY supplement but SHALL NOT replace objective signals.
- Failed API calls (timeouts, errors) SHALL receive a penalty greater than an incorrect response to accelerate disabling of dead models.

### Integration with health checking

- Models entering the routing pool SHOULD be health-checked before receiving production traffic (see [ADR-0015](ADR-0015-dynamic-service-discovery-ai-models.md)).
- Models that fail health checks SHALL be removed from the routing pool and their bandit state frozen (not reset).
- Models that recover from failure SHOULD re-enter with decayed priors, not fresh priors, to preserve learned performance history.

### Task-type specialization

- Bandit state SHOULD be maintained per task type (e.g., code generation, summarization, math, general knowledge).
- A model that excels at one task type SHALL NOT be assumed to excel at others.

### Fallback behavior

- When all models in the primary pool are unavailable, the system SHALL fall back to a curated list of known-reliable models.
- Fallback lists SHOULD be filtered through the verified model set when available.

## Consequences

### Positive
- Automatically discovers and promotes the best-performing models without manual curation.
- Adapts to model degradation, rate limits, and provider outages in real time.
- Exploration prevents lock-in to a single model that may not be globally optimal.
- Per-task-type specialization captures model strengths that static routing misses.

### Negative
- Exploration budget means some requests intentionally go to suboptimal models.
- Bandit convergence requires sufficient traffic volume; low-traffic task types may never converge.
- Observation cap introduces a recency bias that may discard valid long-term performance data.
- Requires persistent state for bandit parameters (alpha/beta per model per task type).

## Alternatives Considered

### Static routing table (hardcoded model priorities)
Rejected — cannot adapt to model availability changes or discover new top performers.

### Round-robin across all models
Rejected — treats all models as equal; wastes calls on known-poor performers.

### Epsilon-greedy without Thompson Sampling
Rejected as default — internal evaluations favored Thompson Sampling’s confidence-weighted exploration/exploitation balance.

### Thompson Sampling with Beta priors (chosen)
Practical default for adaptive routing under uncertainty and changing model quality.

## Related ADRs
- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
- [ADR-0012](ADR-0012-multi-model-consensus-quality-gates.md) — Multi-Model Consensus for Quality Gates
- [ADR-0015](ADR-0015-dynamic-service-discovery-ai-models.md) — Dynamic Service Discovery for AI Models
