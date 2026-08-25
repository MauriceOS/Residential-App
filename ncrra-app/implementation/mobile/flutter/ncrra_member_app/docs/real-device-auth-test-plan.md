# NCRRA real-device Keycloak authentication test plan

The APK now compiles. Execution of real sign-in and token-refresh tests requires a connected Android device or emulator and a reachable HTTPS Keycloak issuer; the current sandbox exposes only a Linux Flutter device and therefore cannot complete those device tests here.

## Android run

Set the production-like, non-secret build values through the local run environment: `NCRRA_OIDC_DISCOVERY_URL`, `NCRRA_OIDC_CLIENT_ID` and `NCRRA_OIDC_REDIRECT_URL=ncrra://auth`. Install the debug APK on an approved test device, confirm `adb devices` shows exactly the intended device, and run the app. Verify that the browser returns to the app through `ncrra://auth`, the authorization-code exchange completes with PKCE, and no client secret is present in the APK or logs.

With the device clock correct, force the access token near expiry or use a short-lived test token policy. Trigger a protected NCRRA API request and verify the session refreshes with the refresh token from Android Keystore-backed storage. Disable network access during a request and confirm the app fails closed without exposing the token. Sign out and verify the secure-storage record is deleted and the Keycloak end-session callback returns to the app.

## iOS run

Open the Flutter project in Xcode on an approved macOS build host. Confirm the `ncrra` URL scheme is registered in `Runner/Info.plist`, the bundle identifier is the approved NCRRA identifier, and Keychain access is restricted to the originating device. Run the same browser return, PKCE, protected request, refresh, network-failure, sign-out and token-deletion checks on a real iPhone or approved simulator.

## Release gates

The test is not complete until both platforms have evidence for successful sign-in, refresh, sign-out, callback cancellation, expired-session failure, invalid-state rejection, no secret in the binary/logs, and no token persistence in backups. Record device model, OS version, app build hash, Keycloak realm/client, test timestamp and result in the release evidence store; do not commit tokens, user passwords or personal data.
