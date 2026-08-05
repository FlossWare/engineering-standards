# ADR-0012: Multi-Model Consensus for Quality Gates

## Status
Accepted

## Date
2026-08-05

## Context

AI-assisted code review, design evaluation, and decision-making can use a single model or multiple models. Single-model review is fast and cheap but blind to that model's systematic biases. Multi-model consensus introduces diverse perspectives at the cost of latency and API calls.

Empirical testing across 12 rounds of experiments with 500+ models revealed:

- Multi-model review caught 3 real bugs in a production router that single-model review and unit tests missed (race condition on shared state, instruction ordering error, insufficient validation).
- For simple factual tasks (math, lookup, logic), consensus did NOT outperform the single best model (consensus accuracy 87.5% vs individual 90%).
- Approximately 30% of model-reported "failures" in code review were hallucinations caused by truncated context, not real defects.

The value of consensus is highest when the task is subjective, multi-dimensional, or when correctness is hard to verify mechanically.

## Decision

Multi-model consensus SHALL be used as a quality gate for the following categories:

- **Design reviews** — before implementation begins, not after.
- **Code reviews** — for changes affecting shared infrastructure, routing logic, or security boundaries.
- **Architecture decisions** — when multiple valid approaches exist.

Single-model evaluation SHOULD be preferred for:

- Simple factual queries with mechanically verifiable answers.
- Tasks where latency matters more than thoroughness.
- Exploratory or brainstorming phases where diversity of thought comes from iteration, not parallel voting.

### Consensus panel composition

- Panels SHOULD include models from at least 3 distinct providers to maximize perspective diversity.
- Panels SHOULD use a minimum of 3 voters; 5-7 SHOULD be used for quality gates.
- The same model SHALL NOT serve as both generator and sole evaluator of an output (see anti-self-referential safeguards).

### Handling disagreement

- Majority vote is sufficient for binary decisions (accept/reject).
- For multi-dimensional reviews (correctness, security, performance), each dimension SHOULD be scored independently.
- Contested findings (near 50/50 split) SHOULD be flagged for human review rather than auto-resolved.

### False positive mitigation

- Review prompts SHALL include sufficient context for the model to evaluate (full imports, type signatures, surrounding code).
- Findings SHOULD be adversarially verified: a different model from a different provider attempts to reproduce or refute each finding before it is reported.
- Findings that cannot be reproduced by at least one independent verifier SHOULD be discarded.

## Consequences

### Positive
- Catches real defects that single-model review misses.
- Reduces systematic bias from any single model vendor.
- Review-before-build (design phase) saves 6:1 rework vs review-after-build.
- Adversarial verification filters hallucinated findings.

### Negative
- Higher latency and API cost per review cycle.
- Consensus can converge on a wrong answer when models share training data biases.
- Requires infrastructure to fan out prompts and collect votes.
- Rate limits across providers can cause partial panel failures; retry logic is necessary.

## Alternatives Considered

### Single-model review only
Rejected — misses real bugs due to systematic blind spots; empirically demonstrated.

### All decisions by consensus (no single-model path)
Rejected — overkill for simple factual tasks where one good model suffices; wastes API budget.

### Multi-model consensus with task-appropriate scope (chosen)
Balances thoroughness for high-stakes decisions with efficiency for routine operations.

## Related ADRs
- [ADR-0001](ADR-0001-explicit-opt-in-cross-cutting-behavior.md) — Explicit Opt-In Cross-Cutting Behavior
- [ADR-0002](ADR-0002-ai-provider-abstraction.md) — AI Provider Abstraction
- [ADR-0008](ADR-0008-free-first-modular-platform.md) — Free-First Modular Platform
- [ADR-0013](ADR-0013-bandit-based-model-selection.md) — Bandit-Based Model Selection
- [ADR-0015](ADR-0015-dynamic-service-discovery-ai-models.md) — Dynamic Service Discovery for AI Models
