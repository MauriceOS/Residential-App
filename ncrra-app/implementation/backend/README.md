# NCRRA modular backend foundation

This is a **service-owned foundation**, not a monolith. Each service owns its data, migrations, deployment lifecycle and APIs. Services communicate across service boundaries through versioned HTTP contracts and RabbitMQ events; direct cross-service SQL is prohibited.

| Boundary | Runtime | Owns | Initial public responsibility |
|---|---|---|---|
| Identity and access | Keycloak + .NET BFF integration | OIDC realm configuration, sessions, role claims | Issue and validate member/admin identity context |
| Membership | ASP.NET Core/.NET 10 | memberships, households, annual contribution eligibility | Membership status and member profile projection |
| Ticketing | ASP.NET Core/.NET 10 | tickets, workflow state, service request audit trail | Search, filter and track member service requests |
| Billing | ASP.NET Core/.NET 10 | invoices, payment intents, receipts, ledger references | Annual contribution payment orchestration |
| Provider adapter | Go | provider-specific queues, mapping and retry policy | Dispatch a formally approved provider action; no scraping |
| Notifications | ASP.NET Core/.NET 10 | notification preferences and delivery records | Deliver state-change notices |

The Flutter member client calls a platform BFF/API facade through an OIDC access token. It never derives tenant identity, connects to PostgreSQL, holds a provider credential, or invokes a provider adapter directly. The API derives tenant, actor, role, field visibility, purpose and workflow authorization server-side.
