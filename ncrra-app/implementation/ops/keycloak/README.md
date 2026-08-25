# NCRRA Keycloak local development setup

The local realm is deliberately separate from production. It creates a public Flutter development client with Authorization Code + PKCE (`S256`) and no client secret. The `tenant_id` mapper exists only to exercise server-derived request context in local development. In production, the platform must issue tenant membership/role context from a controlled membership relationship and not permit a member to self-edit a tenant attribute.

Start local dependencies with explicitly supplied, non-production values. For example, export `POSTGRES_PASSWORD`, `KEYCLOAK_ADMIN`, `KEYCLOAK_ADMIN_PASSWORD`, `RABBITMQ_DEFAULT_USER`, `RABBITMQ_DEFAULT_PASS`, and `GRAFANA_ADMIN_PASSWORD`, then run Docker Compose with `compose.yaml` and `compose.local.yaml`. The local Keycloak admin endpoint binds to `127.0.0.1:8081`; it must not be exposed publicly.

The service policies still make the final authorization decision. A `platform_support` realm role alone is insufficient for sensitive access: the application must require a time-bound support grant, declared purpose and audit event.
