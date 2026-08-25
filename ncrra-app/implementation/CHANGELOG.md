# NCRRA implementation changelog

## 2026-08-25 — Security, scale and integration hardening

The pasted engineering checklist was reviewed and translated into implementation rules. The project keeps the React application as the visual source of truth while treating Flutter, service boundaries and DevSecOps as the production track. No “Made with Manus” label or generated attribution is added to the product code.

| Concern | Decision | Why this matters |
|---|---|---|
| Tenant isolation | Derive tenant scope from trusted OIDC claims and bind `app.tenant_id` inside the same database transaction as the query; enforce PostgreSQL RLS | Prevents client-supplied tenant IDs and reduces cross-tenant leakage risk |
| Secrets | Keep provider credentials, OIDC secrets and database passwords outside source; use protected runtime injection and mobile platform secure storage | Limits blast radius from source exposure, logs and backups |
| Provider failure | Keep provider adapters behind a circuit-breaker/readiness boundary and permit graceful feature degradation | A failing utility or travel partner must not take down membership and ticketing |
| Duplicate work | Require idempotency keys for ticket creation, payment initiation and provider handoffs | Retries must not create duplicate tickets, charges or external requests |
| Concurrency | Use immutable event records, transaction boundaries, unique constraints and optimistic/concurrency checks around state transitions | Protects correctness under concurrent requests rather than optimizing only for the 250-member pilot |
| Database performance | Require indexes that match tenant, member, status, service and updated-at filters; review execution plans before high-volume launch | Prevents ORM convenience queries from becoming nested scans at scale |
| Asynchronous work | Keep provider calls, notifications, retries and reconciliation off the request thread through RabbitMQ-backed workers | Absorbs spikes and prevents slow external systems from blocking API threads |
| Observability | Emit structured logs, metrics and traces with tenant-safe correlation IDs and no raw provider references | Makes failures diagnosable without leaking personal or credential data |
| UI fidelity | Use Lucide icon names explicitly, Manrope for body, Plus Jakarta Sans for headings, and documented animation durations | Keeps the coded experience reproducible and avoids generic or AI-looking substitutions |
| Scale target | Stress-test the critical paths with concurrent users and transaction workloads representative of 100,000 registered users | Confirms capacity and failure behaviour before production claims are made |

### Current evidence

The React prototype type-checks and builds. The Flutter app passes analysis and tests, and the debug APK now compiles against Android SDK 37. Ticketing and Membership ephemeral PostgreSQL tests prove unscoped and cross-tenant reads/writes are denied. The Go agreement ledger unit tests pass, and a synthetic `sandbox-provider` agreement proves the readiness gate can return ready without enabling a real provider.

### Explicitly not completed

A real provider approval has not been recorded because no signed agreement reference, authorised approver or approved permitted-action list was supplied. No KPLC, SGR, Jambojet, payment or other live call is enabled. Real Android and iOS sign-in/refresh testing is not complete because the sandbox has no connected Android/iOS device; the device test plan is ready for an approved device and HTTPS Keycloak environment.
