-- NCRRA membership integration test: RLS keeps profiles and consent records within the server-derived tenant session.
\set ON_ERROR_STOP on

BEGIN;
SELECT set_config('app.tenant_id', '33333333-3333-3333-3333-333333333333', true);
INSERT INTO member_profiles ("Id", "TenantId", "SubjectId", "DisplayName", "Email", "Phone", "Area", "MembershipStatus", "CreatedAt", "UpdatedAt")
VALUES ('cccccccc-cccc-cccc-cccc-cccccccccccc', '33333333-3333-3333-3333-333333333333', 'oidc-subject-test-member', 'Test Member', 'member@example.invalid', '0700000000', 'Test Area', 'active', now(), now());
COMMIT;

DO $$
BEGIN
  IF (SELECT COUNT(*) FROM member_profiles) <> 0 THEN
    RAISE EXCEPTION 'unscoped session unexpectedly read a member profile';
  END IF;
END $$;

BEGIN;
SELECT set_config('app.tenant_id', '44444444-4444-4444-4444-444444444444', true);
DO $$
BEGIN
  IF (SELECT COUNT(*) FROM member_profiles) <> 0 THEN
    RAISE EXCEPTION 'second tenant unexpectedly read first tenant member profile';
  END IF;
  BEGIN
    INSERT INTO member_profiles ("Id", "TenantId", "SubjectId", "DisplayName", "Email", "Phone", "Area", "MembershipStatus", "CreatedAt", "UpdatedAt")
    VALUES ('dddddddd-dddd-dddd-dddd-dddddddddddd', '33333333-3333-3333-3333-333333333333', 'cross-tenant-subject', 'Cross Tenant', 'cross@example.invalid', '0700000001', 'Test Area', 'active', now(), now());
    RAISE EXCEPTION 'cross-tenant member-profile insert was not rejected';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END $$;
COMMIT;

BEGIN;
SELECT set_config('app.tenant_id', '33333333-3333-3333-3333-333333333333', true);
DO $$
BEGIN
  IF (SELECT COUNT(*) FROM member_profiles) <> 1 THEN
    RAISE EXCEPTION 'first tenant could not read its own member profile';
  END IF;
END $$;
COMMIT;
