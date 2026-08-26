# Cross-track preview and APK alignment

**Prepared by Maurice Osoro**

## Purpose

The NCRRA project has two executable tracks: the React web preview in `client/` and the Flutter mobile application in `implementation/mobile/flutter/ncrra_member_app/`. They are not the same binary and they do not share compiled UI code. The Flutter application is the source of truth for member-facing mobile behavior; the React preview is a browser-based review surface that mirrors the approved mobile information architecture and visual direction.

The installed phone version can therefore diverge from the preview when an older APK remains installed. This occurred during the August 2026 handoff: the phone had previously installed the ARM64 artifact with checksum `b0c72b78d287e98c9911af5a38fb9a049ef0218b51d6dc842156e19f399c7cb0`, while the later Flutter navigation/icon correction produced a new ARM64 artifact with checksum `ba79b0ef8e3e476cb4962fdf84e12bd0690a93c13082bbe13bb16099e2d9aa00`. The newer artifact must be installed before comparing the phone UI with the current preview.

## Ownership rule

The Flutter track owns the mobile interaction contract. A mobile behavior is considered aligned when the same member intent, destination, label, navigation ownership and feedback state exist in both tracks. React may use browser-native presentation details, while Flutter may use native widgets, snackbars and device capabilities. Those implementation differences must not change the information architecture or the meaning of an action.

| Surface | Flutter mobile source of truth | React preview counterpart | Alignment status |
|---|---|---|---|
| Home header | `HomeScreen` with Home-only menu trigger, NCRRA mark and notification affordance | `screen === "home"` branch with the same Home-only trigger and mark | Aligned in ownership and visible structure |
| Membership summary | Native loading state before opening membership | `MembershipSummary` with the same short loading state and visible `Opening membership…` label | Aligned in intent and feedback; rendering is platform-native |
| Quick actions | Report an issue, My tickets, Pay contribution and My connections | Same four rows and destinations | Aligned |
| Primary navigation | Home, Services, Community, Benefits and Account | Same five bottom-navigation keys and labels | Aligned |
| Services icon | Service-specific plug icon | Service-specific plug icon | Aligned; hamburger is reserved for the drawer |
| Utility drawer | Cross-cutting records, receipts, notifications, privacy, security, help and contact | Same utility-only groups and destinations | Aligned; no duplicate primary tabs |
| Drawer trigger | Visible on the authenticated Home root only | Visible when `drawerTriggerVisible` is true, currently `screen === "home"` | Aligned |
| Detail and utility screens | Back navigation through the app shell | `Header` with `onBack`, no drawer mount | Aligned |
| Notification affordance | Native prototype feedback message | Browser toast feedback message | Intent aligned; feedback primitive differs |

## Why the phone looked different

The preview is hot-reloaded from the current React source. The phone is not hot-reloaded; it displays whichever signed APK was last installed. A successful `adb install` only proves that the selected file was accepted by Android. It does not prove that the phone has the latest artifact unless the checksum is compared and the installation command points to the newly rebuilt file.

The source-aligned ARM64 artifact is the file whose SHA-256 is `ba79b0ef8e3e476cb4962fdf84e12bd0690a93c13082bbe13bb16099e2d9aa00`. The package remains `org.ncrra.memberapp`, and the launcher activity remains `com.example.ncrra_member_app.MainActivity`. The React preview and the latest Flutter source now reflect the same drawer ownership and contextual menu rule; an old APK will not.

## Verification procedure

For a meaningful comparison, first install the newly rebuilt ARM64 APK, then launch it and capture the package and activity evidence. On Windows:

```bat
cd C:\Android\platform-tools
adb install -r -d "C:\Users\osoro\Downloads\app-arm64-v8a-release.apk"
adb shell am force-stop org.ncrra.memberapp
adb logcat -c
adb shell monkey -p org.ncrra.memberapp 1
adb shell pidof org.ncrra.memberapp
adb shell dumpsys activity activities | findstr /I "mResumedActivity org.ncrra.memberapp"
adb logcat -d -v time -t 300 | findstr /I "FATAL EXCEPTION AndroidRuntime org.ncrra.memberapp MainActivity"
```

Compare the phone against the current preview using the following checkpoints:

| Checkpoint | Expected behavior |
|---|---|
| Home | Menu icon is visible next to the NCRRA mark; it opens utility-only destinations. |
| Services | Plug/service icon is used; no hamburger icon is presented as a second path to the drawer. |
| Community, Benefits and Account | Bottom navigation owns these destinations; no drawer trigger is shown. |
| Utility/detail screen | A back affordance is shown; the Home-only drawer trigger is absent. |
| Drawer contents | Member ID & association, receipts, notifications, privacy, security, help and contact only. |
| Membership button | The label remains visible and changes to a short opening/loading state before navigation. |

## Maintainer rule

Do not make the React preview a second source of truth for mobile behavior. When a mobile interaction changes, update the Flutter implementation first, then update the React preview to mirror the same intent and verify the row in the alignment table. When an APK is delivered, record its checksum in `docs/mobile/android-11-install-evidence.md` and do not describe an older installation as evidence for the new source state.

## References

[1]: https://developer.android.com/tools/releases/platform-tools "Android Developers — SDK Platform-Tools"
[2]: https://developer.android.com/studio/command-line/adb "Android Developers — Android Debug Bridge"


## Final source verification

After the React drawer-trigger regression was added, the repository verification completed successfully. React Vitest passed with 2 test files and 3 tests; TypeScript completed with no errors; and the production web build completed successfully. Flutter analysis reported no issues, the Flutter widget suite passed all 13 tests, and the ARM64 release APK rebuilt successfully.

The source-aligned ARM64 APK checksum remains `ba79b0ef8e3e476cb4962fdf84e12bd0690a93c13082bbe13bb16099e2d9aa00`. This verification proves source and build integrity. Direct visual comparison of the final APK still requires the user’s Android 11 device because the sandbox cannot capture that phone’s rendered UI.
