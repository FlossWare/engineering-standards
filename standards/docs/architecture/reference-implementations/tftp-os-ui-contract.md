# Reference implementation: flossware-tftp-os ↔ ADR-0007

Validates [ADR-0007 Unified Client-Service Contract](../../../adr/ADR-0007-unified-client-service-contract.md) against [FlossWare/flossware-tftp-os](https://github.com/FlossWare/flossware-tftp-os).

**Scope of this sample:** operator / application clients over REST (and in-process library use). It does **not** validate MCP agent exposure ([ADR-0018](../../../adr/ADR-0018-mcp-capability-exposure.md)); agent paths are out of scope for this reference implementation.

## Verdict

**Mostly conforms** for remote/operator clients. Nuance: in-process Python frontends call the `tftpos` library directly rather than REST.

| Check | Result |
|-------|--------|
| Stable service API for clients | **Pass** — FastAPI `/api/v1/*` |
| Multiple frontends, one contract | **Pass** — Java TUI, Swing, Android, iOS via REST |
| Clients do not access DB directly | **Pass** — no client DB usage observed |
| All UIs forced through REST | **Partial** — Python TUI/GUI import library in-process |
| Documented as reference pattern | **Pass** — this document + ADR-0007 link |

## Frontends

| Frontend | Directory | Integration |
|----------|-----------|-------------|
| REST API / Web | `flossware-tftp-os-web/` | **Defines** `/api/v1` contract |
| Python TUI | `flossware-tftp-os-tui/` | Direct `tftpos` library |
| Python GUI | `flossware-tftp-os-gui/` | Direct `tftpos` library |
| Java TUI | `flossware-tftp-os-java/` | HTTP → REST API |
| Java Swing | `flossware-tftp-os-swing/` | HTTP → REST API |
| Android | `flossware-tftp-os-android/` | HTTP → REST API |
| iOS | `flossware-tftp-os-ios/` | HTTP → REST API |

Interpretation for ADR-0007:

- **SHALL integrate through stable service APIs** applies to independently deployed / cross-language clients (Java, mobile).
- **Same-process library use** (Python TUI/GUI) is acceptable when the library *is* the service implementation boundary and does not embed a second copy of business rules per UI. Prefer REST when the client is remote or polyglot.

## REST API surface (`/api/v1`)

Source: [`flossware-tftp-os-web/.../app.py`](https://github.com/FlossWare/flossware-tftp-os/blob/main/flossware-tftp-os-web/flossware_tftp_os_web/app.py)

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/health` | GET | Health check |
| `/api/v1/plugins` | GET | List OS family plugins |
| `/api/v1/rules` | GET | List host matching rules |
| `/api/v1/resolve` | POST | Resolve MAC → firmware path |
| `/api/v1/stage` | POST | Stage firmware for TFTP |
| `/api/v1/state` | GET | List provision states |
| `/api/v1/state/{mac}` | GET | State for one MAC |
| `/api/v1/register` | POST | Register device |
| `/api/v1/transition` | POST | Transition provision state |
| `/api/v1/config` | GET | Server configuration snapshot |

### Representative request models

- `ResolveRequest` / `StageRequest`: `{ "mac": string }`
- `RegisterRequest`: `{ "mac", "profile", "os_family", "os_version" }`
- `TransitionRequest`: `{ "mac", "state", "error_message?" }`

### Config response fields

`server_host`, `server_port`, `tftp_root`, `distro_root`, `data_dir`, `auth_enabled`, `service_name`

## Alignment with ADR-0010

- REST is the external synchronous contract for non-Python clients.
- Business capability sits behind the web service / engine, not in each UI.
- Async events are not required for this control-plane API; when added, they should follow ADR-0005 and opt-in ADR-0001.

## Sibling projects

| Repo | Status |
|------|--------|
| [pxe-os](https://github.com/FlossWare/pxe-os) | Exists — should be checked for the same REST-vs-embedded pattern in a follow-up |
| [virt-os](https://github.com/FlossWare/virt-os) | Exists — primarily provisioning/OS image concerns; apply ADR-0007 if/when operator UIs appear |

## Recommendations

1. Treat **tftp-os `/api/v1`** as the reference operator API style for similar provisioning tools.
2. Prefer publishing OpenAPI from FastAPI (`/docs`) as the shared machine-readable contract.
3. For new polyglot clients, consume REST only; reserve direct library imports for same-language, same-process tools.
4. Optionally track pxe-os/virt-os conformance as separate issues on those repos.
