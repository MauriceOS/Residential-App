# NCRRA implementation handoff

The project now has two coordinated tracks. The existing React application remains the **visual review source of truth**; it contains the approved mobile flows and provides an immediately reviewable implementation of the designed screens. The `implementation/mobile/flutter/ncrra_member_app` directory is the production mobile track, translating the same warm-ivory, navy and teal design system, Lucide icon system, spacing, onboarding/consent flow and ticket-dashboard behaviour into Flutter code.

The `backend`, `contracts` and `ops` directories establish the intended production architecture. They do not turn the current static prototype into a live association platform. Instead, they provide service boundaries, a .NET ticketing/membership foundation, a Go provider-adapter boundary, an initial OpenAPI ticket contract, a versioned event schema, Docker Compose service segmentation, an Ansible hardening baseline, CI checks, telemetry/alerting configuration and backup/recovery operating procedures.

| Deliverable | Location | Status in this workspace |
|---|---|---|
| Approved visual source | `client/src/pages/Home.tsx` | Running and type-checked; screenshots revalidated |
| Exact Figma reproduction specification | `figma_reproduction_prompt.md` | Available for editable Figma reconstruction |
| Flutter mobile foundation | `mobile/flutter/ncrra_member_app` | Authored; awaiting Flutter/Dart SDK and approved brand asset to compile |
| .NET service boundaries | `backend/dotnet` | Authored; awaiting .NET SDK, persistence and OIDC environment to compile/run |
| Go provider boundary | `backend/go/provider-adapter` | Authored; awaiting Go toolchain and formal provider integration agreement |
| API/event contracts | `contracts` | First ticket-search OpenAPI contract and `ticket-created.v1` event schema included |
| DevSecOps / VPS foundation | `ops` | Authored; awaiting Docker, Ansible collections, managed secrets, target host and restore test |

## Deliberate safeguards

The code deliberately does not contain live provider endpoints, payment details, tenant IDs, connection references, password material, OIDC client secrets, database credentials or production `.env` files. The Flutter client only defines an authenticated API boundary. Tenant scope must be derived from OIDC identity by the server, re-enforced in each service’s data query, and backed by database policy where appropriate. Provider adapters must remain disabled until NCRRA has an approved provider agreement and documented interface or official handoff.

## Next engineering increment

Install the Flutter, .NET 10, Go, Docker and Ansible toolchains in the intended engineering environment. Copy the approved NCRRA mark into the Flutter asset path, generate API clients from the OpenAPI contract, add the service-owned PostgreSQL migrations and Keycloak realm configuration, then wire the Flutter ticket repository to the authenticated BFF. Before real association data is introduced, complete threat modelling, test restore evidence, migration rollback rehearsal and provider-integration approval.
