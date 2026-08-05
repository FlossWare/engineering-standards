# FlossWare Reference Architecture

This document is the visual and narrative companion to the ADRs under [`adr/`](../../adr/).

## Diagram (Mermaid)

```mermaid
flowchart TB
  subgraph Clients
    UI_TUI[Operator TUI]
    UI_GUI[Operator GUI]
    UI_WEB[Web / Mobile]
    AGENTS[AI Agents]
  end

  subgraph Edge
    REST["REST / OpenAPI\n/api/v1/*"]
    MCP[MCP Tool Contracts]
  end

  subgraph Services
    SVC[Service Layer\nbusiness capabilities]
  end

  subgraph Async
    BUS[Message Bus\nversioned events]
    PROD[Event Producers]
    CONS[Event Consumers]
  end

  subgraph Data
    SP[Stored Procedures\nselective]
    DB[(Database)]
  end

  CFG[(Configuration\nsource of truth)]

  UI_TUI --> REST
  UI_GUI --> REST
  UI_WEB --> REST
  AGENTS --> MCP

  REST --> SVC
  MCP --> SVC

  SVC --> SP
  SP --> DB
  SVC -.->|optional direct| DB

  SVC --> PROD
  PROD --> BUS
  BUS --> CONS
  CONS --> SVC

  CFG -.-> SVC
  CFG -.-> REST
  CFG -.-> BUS
```

## Layers

| Layer | Role | Governing ADRs |
|-------|------|----------------|
| Clients | Operator UIs and agents | [ADR-0007](../../adr/ADR-0007-unified-service-ui-contract.md), [ADR-0004](../../adr/ADR-0004-mcp-tool-contracts.md) |
| REST edge | Synchronous external contract | [ADR-0010](../../adr/ADR-0010-rest-service-boundaries.md) |
| MCP edge | Agent tool discovery/invocation | [ADR-0004](../../adr/ADR-0004-mcp-tool-contracts.md) |
| Service layer | Business capabilities; no client DB access | [ADR-0010](../../adr/ADR-0010-rest-service-boundaries.md) |
| Message bus | Async integration; opt-in publish | [ADR-0005](../../adr/ADR-0005-event-driven-internal-bus.md), [ADR-0001](../../adr/ADR-0001-explicit-opt-in-cross-cutting-behavior.md) |
| Stored procedures | Selective data-centric logic | [ADR-0011](../../adr/ADR-0011-stored-procedure-database-access.md) |
| Database | Persistence | [ADR-0011](../../adr/ADR-0011-stored-procedure-database-access.md) |
| Configuration | Source of truth for runtime behavior | [ADR-0009](../../adr/ADR-0009-core-architecture-principles.md) |

## Cross-cutting rules

- Cross-cutting behaviors (events, audit, metrics, tracing) are **explicit opt-in** — [ADR-0001](../../adr/ADR-0001-explicit-opt-in-cross-cutting-behavior.md).
- Preferred mechanism when opted in: decorators / interceptors / middleware — [ADR-0006](../../adr/ADR-0006-cross-cutting-decorators.md).
- AI access goes through provider abstractions; local inference is not the default — [ADR-0002](../../adr/ADR-0002-ai-provider-abstraction.md), [ADR-0003](../../adr/ADR-0003-no-local-inference-default.md).
- Prefer free/open modular components — [ADR-0008](../../adr/ADR-0008-free-first-modular-platform.md).

## Maintainability

- Primary format: **Mermaid** in this Markdown file (renders on GitHub, editable in PRs).
- Optional: export to Draw.io / SVG for slide decks; keep this file as source of truth.

## Reference implementations

- [tftp-os UI contract validation](reference-implementations/tftp-os-ui-contract.md)
