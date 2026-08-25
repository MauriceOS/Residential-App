# NCRRA secure activation verification

The provider adapter is now gated by two independent controls: `NCRRA_PROVIDER_INTEGRATION_ENABLED=true` and a reference-only agreement ledger containing at least one approved, unexpired record for an allowed action. Unit tests cover approved, revoked, expired and uncovered-action paths. A synthetic `sandbox-provider` ledger record was used to verify that readiness returns `200`; it does not represent KPLC, SGR, Jambojet or another live provider agreement.

The Ticketing and Membership migrations were each applied to a fresh ephemeral PostgreSQL instance, using the relevant service database account. The executable tests confirmed that an unscoped session cannot read tenant rows, that a second tenant cannot read or write the first tenant’s records, and that the original tenant can read its own record. Each test container was removed after execution and only synthetic identifiers were used.

Flutter analysis and tests pass. The Android and iOS projects now register the `ncrra://auth` callback used by Keycloak Authorization Code + PKCE, and refresh/access/id tokens use platform-protected storage. A local APK build could not be completed because this sandbox has no Android SDK; the Dart and native configuration files were statically verified. Real-device Android and iOS sign-in, refresh and sign-out testing remains a release prerequisite.
