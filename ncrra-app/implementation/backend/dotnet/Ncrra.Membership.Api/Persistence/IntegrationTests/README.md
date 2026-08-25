# Membership tenant-session and RLS integration test

`membership_rls_integration.sql` validates the initial Membership migration with the service database user. It verifies profile insertion for tenant A, denial of unscoped reads, denial of tenant B reads and cross-tenant writes, and permitted reads for tenant A. The test uses synthetic identifiers only and must run against an ephemeral PostgreSQL instance.
