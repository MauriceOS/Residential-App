# Ticketing tenant-session and RLS integration test

`ticketing_rls_integration.sql` is an executable PostgreSQL integration test for the initial Ticketing migration. It writes one row under tenant A, verifies that an unscoped database session sees no tenant records, verifies tenant B cannot read or insert tenant A data, then verifies tenant A can read its own record.

Run this test against an ephemeral PostgreSQL database created specifically for the test. The connection must use the service database user, not a PostgreSQL superuser, because superusers bypass RLS. The application service must execute `set_config('app.tenant_id', trustedTenantId, true)` inside the same transaction used for every tenant-scoped query or write.
