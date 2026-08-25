# NCRRA Prototype Enhancement Tasks

- [x] Review the current mobile-screen state model and existing ticket views.
- [x] Add new-member welcome, profile setup, and consent screens with a completion handoff to Home.
- [x] Add ticket status filters, service filters, search, and sort controls to the member ticket dashboard.
- [x] Verify onboarding, consent, filtering, sorting, and mobile responsiveness in the running prototype.
- [x] Prepare the exact Figma reproduction prompt, including visual tokens, font hierarchy, icon mapping, frame details, and interaction states.
- [x] Save a delivery checkpoint after verification.

## Production implementation foundation

- [x] Create a Flutter-ready design-system, navigation and screen specification using the React prototype as the visual source of truth.
- [x] Scaffold service-owned .NET and Go boundaries with API and event contract placeholders.
- [x] Add VPS-first Docker Compose, CI security gates, secret-management, observability and deployment baseline files.
- [x] Link the mobile contract client and service API boundaries without embedding tenant or provider secrets in the client.
- [x] Verify the prototype remains visually consistent and the foundation is structurally coherent.
- [x] Save an implementation-foundation checkpoint and deliver the repository handoff.

## Local platform enablement

- [x] Inspect legal, credential and runtime prerequisites for toolchain installation, Keycloak, database migrations and provider adapters.
- [x] Install and validate Flutter, .NET, Go and Docker locally.
- [x] Compile the Flutter, .NET and Go scaffolds and correct implementation errors.
- [x] Add Keycloak realm/client configuration and service-owned PostgreSQL migration projects.
- [x] Start the local platform dependencies only with non-production credentials and seed no member data.
- [x] Add an agreement-gated provider adapter registry, readiness checks and disabled-by-default integration configuration.
- [x] Verify the local platform foundation and save a checkpoint.

## Secure activation and native authentication

- [x] Define agreement approval, adapter-readiness, tenant-session/RLS, and native redirect acceptance criteria.
- [x] Implement an auditable provider agreement record with approval, revocation, and readiness-gate evaluation.
- [x] Add and execute tenant-session and PostgreSQL RLS integration tests for cross-tenant denial.
- [x] Add Android and iOS native callback configuration for Keycloak Authorization Code + PKCE.
- [x] Add protected device token storage and connect it to the Keycloak session implementation.
- [x] Verify source builds, activation safety, isolation tests and native authentication configuration.
- [x] Save a secure implementation checkpoint and deliver the result.
- [x] Repair the post-upgrade React server dependency/runtime regression and reverify the prototype.
- [x] Exercise synthetic KPLC, SGR and Jambojet approval records without treating them as real approvals.
- [ ] Install the compiled APK on the connected ADB Android device and run the available authentication checks.
- [x] Verify CI RLS workflow configuration and document any test-environment limits.
- [x] Provision a lightweight Android emulator/AVD inside the sandbox for non-production auth testing (AVD created; launch requires host KVM).
- [ ] Install the NCRRA APK on the emulator and record callback/session test evidence.
- [x] Validate and deliver the compiled NCRRA debug APK for local installation (uploaded as a downloadable artifact).
- [x] Document host or nested-VM KVM enablement steps and the sandbox limitation.
- [x] Diagnose the staging APK installation rejection using manifest, ABI, SDK and signing metadata.
- [x] Produce and validate a phone-compatible signed APK, then document the installation path.
- [ ] Capture the exact Android 11 package-manager error for the tap-to-install failure.
- [ ] Resolve the Android 11 sideload, signature, package or installer compatibility issue and revalidate the APK.
- [ ] Provide Windows Platform Tools setup instructions and verify ADB can see the Android phone.
- [ ] Run the clean NCRRA uninstall/install command from Windows and capture the exact package-manager result.
- [x] Authorize the Windows computer on the Android phone and confirm ADB status changes from unauthorized to device.
- [ ] Install the NCRRA staging APK after authorization and capture the package-manager result.
- [ ] Resolve the confirmed Android package-manager storage failure with safe cleanup guidance.
- [ ] Build and deliver a smaller ABI-specific APK for the Android 11 phone.
- [ ] Capture successful phone installation and launch evidence.
- [ ] Capture the Android 11 logcat crash evidence for the installed NCRRA APK.
- [ ] Correct the runtime crash and rebuild the matching ABI APK.
- [ ] Reinstall and verify the app launches successfully on the Android phone.
- [ ] Correct the Android MainActivity package/manifest mismatch reported by logcat.
- [ ] Rebuild, install and launch-test the corrected ARM64 APK on the Android 11 phone.
- [ ] Profile the Flutter navigation and interaction bottlenecks reported on Android 11.
- [ ] Optimize screen transition and rebuild scope without changing the approved NCRRA visual design.
- [ ] Build, install and measure the optimized APK on the Android phone.
- [ ] Measure available internal storage and package-cache state on the Android phone.
- [ ] Free safe temporary space or remove the old NCRRA package, then retry the optimized APK.
- [ ] Verify the optimized build is installed before measuring navigation responsiveness.
- [ ] Wait for the rebooted phone to reconnect and confirm `adb devices` reports `device`.
- [ ] Retry the optimized ARM64 APK installation with the confirmed 1.6 GB free space.
- [x] Audit the Flutter bottom navigation and Home quick-action callbacks.
- [x] Implement working Services, Community, Benefits, Account and quick-action destinations.
- [ ] Build, install and validate all updated Android navigation paths.
- [x] Correct the ticket-dashboard navigation callback, Lucide icon name and account-list tile construction errors.
- [x] Re-run Flutter analysis, tests and ARM64 release build after corrections.
- [x] Research banking and member-service UI patterns and save source-backed findings.
- [x] Define a non-green NCRRA palette that still respects the supplied original screen and brand mark.
- [x] Add intentional animations and refine Flutter hierarchy, surfaces, buttons and navigation.
- [ ] Build, install and review the redesigned Android APK on the phone.
- [x] Update the Flutter design-system test to assert the researched non-green NCRRA action palette.
- [x] Audit every Flutter button and tappable control for labels, callbacks, destinations and user feedback.
- [x] Repair missing button labels and the View membership action.
- [x] Replace remaining no-op actions with safe prototype outcomes or explicit disabled/coming-soon feedback.
- [x] Improve the member payment and membership screens for readable hierarchy and human-centered interaction.
- [x] Refine billing and membership experiences with clearer hierarchy, due-state emphasis, grouping, and explicit success/empty/error/prototype states.
- [x] Add explicit billing and membership success, failure/error, and empty/no-data states reachable from user actions.
- [x] Add widget tests covering billing and membership success, error and empty/prototype states.
- [x] Add explicit membership success and failure/error states reachable from member actions.
- [x] Add an explicit billing no-payable-contribution empty state and a safe entry point.
- [x] Extend widget coverage for the full billing and membership state matrix.
