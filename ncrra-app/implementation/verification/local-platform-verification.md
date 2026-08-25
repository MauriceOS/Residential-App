# NCRRA local platform verification

The local development host now has Flutter 3.47.1/Dart 3.13.1, .NET SDK 10.0.111, Go 1.27.0, Docker Engine 29.7.2 and Docker Compose v5.5.0 installed. `flutter analyze` is clean; the Flutter mobile scaffold, both .NET 10 services and the Go provider adapter build successfully. The Go provider-adapter image builds using Docker host networking because this sandbox’s Docker bridge is prevented from adding its raw-table firewall rule.

The isolated PostgreSQL and Keycloak containers were started with fresh, process-only, non-production values. The Keycloak `ncrra-dev` realm import completed and internal OIDC discovery returned the realm issuer. The ticketing and membership database migrations applied successfully with no member data seeded. Service-owned tables exist in the respective databases and their initial migrations enable and force PostgreSQL row-level security using the `app.tenant_id` server session setting.

The local adapter’s `/healthz` endpoint returns 200. `/readyz` returns 503 while the agreement gate remains disabled, which is the intended safe configuration. No live KPLC, SGR, Jambojet, payment or other provider call has been attempted.

| Area | Verified result | Remaining production prerequisite |
|---|---|---|
| Flutter / OIDC | PKCE code path compiles and public Keycloak client configuration exists | Android/iOS redirect configuration, protected token storage, HTTPS issuer and real device test |
| .NET / Keycloak | JWT authority/audience configuration and tenant/role claim policy compile | Explicit tenant-session transaction interceptor and authorization integration tests |
| PostgreSQL | Service-owned tables and initial RLS policies applied in isolated local database | Separate managed secrets, service migrations CI job, restore rehearsal and production backup evidence |
| Provider adapter | Go port and container build work; readiness remains gated | Signed/provider-approved agreement, documented interface or managed-handoff procedure, vault secret, scope and security approval |
| Docker | Engine and Compose run the isolated dependencies | Normal host with supported bridge firewall rules, hardened network policy and monitored deployment |
