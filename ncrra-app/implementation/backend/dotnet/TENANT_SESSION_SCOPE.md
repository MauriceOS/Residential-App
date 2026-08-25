# Required tenant session scope for service-owned PostgreSQL access

The initial Ticketing and Membership migrations enforce PostgreSQL row-level security with the server session setting `app.tenant_id`. Both service scaffolds now provide a `TenantSessionScope` that derives this UUID from the trusted `tenant_id` identity claim, begins a database transaction, and executes `SELECT set_config('app.tenant_id', :tenantId, true)` **inside that transaction** before accessing tenant rows. The client must never submit the tenant ID as an authorization input.

The current scaffold includes the migrations and OIDC claim requirement but does not yet expose any data-mutating endpoint. The next service increment must add a scoped tenant-context abstraction, transaction boundary, integration test proving cross-tenant denial, and an audited platform-support grant flow before it permits queries against these tables.
