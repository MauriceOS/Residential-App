-- NCRRA ticketing integration test: the tenant scope is server-session derived and PostgreSQL RLS denies cross-tenant access.
\set ON_ERROR_STOP on

BEGIN;
SELECT set_config('app.tenant_id', '11111111-1111-1111-1111-111111111111', true);
INSERT INTO tickets ("Id", "TenantId", "MemberId", "PublicReference", "Title", "Service", "Status", "ConnectionReferenceToken", "CreatedAt", "UpdatedAt")
VALUES ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-1111-1111-1111-aaaaaaaaaaaa', 'NCRRA-TEST-001', 'RLS integration ticket', 'electricity', 'submitted', NULL, now(), now());
COMMIT;

-- A connection without a trusted tenant session sees no tenant rows.
DO $$
BEGIN
  IF (SELECT COUNT(*) FROM tickets) <> 0 THEN
    RAISE EXCEPTION 'unscoped session unexpectedly read tenant rows';
  END IF;
END $$;

BEGIN;
SELECT set_config('app.tenant_id', '22222222-2222-2222-2222-222222222222', true);
DO $$
BEGIN
  IF (SELECT COUNT(*) FROM tickets) <> 0 THEN
    RAISE EXCEPTION 'second tenant unexpectedly read first tenant rows';
  END IF;
  BEGIN
    INSERT INTO tickets ("Id", "TenantId", "MemberId", "PublicReference", "Title", "Service", "Status", "ConnectionReferenceToken", "CreatedAt", "UpdatedAt")
    VALUES ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', 'bbbbbbbb-2222-2222-2222-bbbbbbbbbbbb', 'NCRRA-TEST-002', 'Cross tenant attempt', 'electricity', 'submitted', NULL, now(), now());
    RAISE EXCEPTION 'cross-tenant insert was not rejected';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END $$;
COMMIT;

BEGIN;
SELECT set_config('app.tenant_id', '11111111-1111-1111-1111-111111111111', true);
DO $$
BEGIN
  IF (SELECT COUNT(*) FROM tickets) <> 1 THEN
    RAISE EXCEPTION 'first tenant could not read its own ticket';
  END IF;
END $$;
COMMIT;
