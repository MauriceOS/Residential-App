# NCRRA Flutter Keycloak setup

The mobile app uses a **public** Keycloak client with Authorization Code + PKCE, never a client secret. The development realm imports `ncrra-mobile-dev` with the redirect URI `ncrra://auth/*` and `S256` PKCE. Android declares the `ncrra://auth` intent filter and `appAuthRedirectScheme`; iOS declares the `ncrra` URL scheme in `CFBundleURLTypes`. Use a real HTTPS issuer in every non-development environment; no mobile binary should trust an internal-only Keycloak host name.

`KeycloakOidcSession` now persists token material using `flutter_secure_storage`, configured for Android Keystore-backed encryption and iOS Keychain accessibility restricted to the originating device after first unlock. The app disables Android backups for this package. Add biometric/device policy according to the finalized NCRRA security decision and test token refresh and sign-out on real devices before enabling member login. Build configuration may carry public discovery and API base URLs, but never tenant IDs, provider credentials, private client keys or service secrets.

The server is responsible for translating the authenticated subject into tenant membership and role/purpose context. The Flutter client may display membership context, but it cannot grant itself a tenant or role.
