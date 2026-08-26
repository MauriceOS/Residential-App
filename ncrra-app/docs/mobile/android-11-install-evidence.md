# Android 11 installation evidence and handoff

**Prepared by Maurice Osoro**

## Scope

This note records the Android 11 installation evidence supplied during NCRRA physical-device testing. It contains no passwords, API keys, PINs, refresh tokens or private documents. The physical phone remains the source of truth for final installation and launch validation.

## Windows Platform Tools setup

On Windows, download **Android SDK Platform-Tools** from the official Android Developers site, extract the folder to a stable path such as `C:\Android\platform-tools`, and open Command Prompt in that folder. The expected commands are:

```bat
cd C:\Android\platform-tools
adb version
adb devices
```

On the phone, enable Developer options and USB debugging, connect the phone by USB, unlock it, and accept the RSA authorization prompt. The expected ADB state is `device`; `unauthorized` means the prompt has not been accepted, and an empty list means the host is not currently connected to the phone.

## Recorded Android 11 installation result

The phone was previously authorized and reported the NCRRA package as installed. A subsequent clean installation attempt was:

```bat
adb install -r -d "C:\Users\osoro\Downloads\app-arm64-v8a-release.apk"
```

The package manager returned:

```text
Performing Streamed Install
adb.exe: failed to install C:\Users\osoro\Downloads\app-arm64-v8a-release.apk:
Exception occurred while executing 'install':
android.os.ParcelableException: java.io.IOException: Requested internal only, but not enough space
        at com.android.server.pm.PackageInstallerService.createSession(PackageInstallerService.java:625)
        at com.android.server.pm.PackageManagerShellCommand.doCreateSession(PackageManagerShellCommand.java:3139)
```

The accompanying storage check reported:

```text
Filesystem       Size  Used Avail Use% Mounted on
/dev/block/sda32 110G  109G  1.6G  99% /data/user/0
```

The evidence identifies **internal-storage exhaustion**, not a confirmed APK ABI, signing or manifest failure. The package path and third-party package listing also confirmed that `org.ncrra.memberapp` was present at the time of the check.

## Signing continuity finding

After the source-aligned ARM64 rebuild, Android rejected an in-place update with `INSTALL_FAILED_UPDATE_INCOMPATIBLE` because the new APK certificate did not match the certificate of the previously installed `org.ncrra.memberapp` package. This is a staging-signing continuity issue, not evidence of a Dart, Flutter, manifest or activity failure. The later PID and resumed-activity output therefore proves that the older installed package continued to launch; it does not prove that the newly rebuilt checksum was installed.

For a staging build where the previous signing key is unavailable, the safe resolution is to uninstall the old NCRRA package and then install the new APK. Uninstalling removes that staging installation’s application data, so any locally stored session or prototype state must be considered disposable before proceeding. A production release must instead use one protected, persistent NCRRA release keystore and must never solve update failures by uninstalling member data.

## Safe recovery sequence

Before retrying, preserve any required phone data and avoid deleting user files. Use the following sequence on the authorized Windows host:

```bat
adb shell pm list packages -3 | findstr /I ncrra
adb uninstall org.ncrra.memberapp
adb shell pm clear org.ncrra.memberapp
adb shell df -h /data
adb reboot
```

`pm clear` is only useful while the package remains installed; `pm uninstall` is the relevant space-recovery step for the old staging package. If storage is still near full, remove unused applications or user-approved media on the phone, then confirm at least several hundred megabytes of additional internal space before installing the 18 MB ARM64 artifact. Do not use broad recursive deletion commands against `/data`.

After reboot, wait for the device to return:

```bat
adb wait-for-device
adb devices
adb install -r -d "C:\Users\osoro\Downloads\app-arm64-v8a-release.apk"
adb shell pm path org.ncrra.memberapp
adb shell am start -n org.ncrra.memberapp/com.example.ncrra_member_app.MainActivity
```

If installation or launch fails after adequate storage is available, capture the complete output and then collect focused logs:

```bat
adb logcat -c
adb shell am force-stop org.ncrra.memberapp
adb shell monkey -p org.ncrra.memberapp 1
adb logcat -d -t 300 | findstr /I "AndroidRuntime FATAL EXCEPTION org.ncrra.memberapp MainActivity"
```

Do not paste credentials or private provider data into the issue report.

## Stable post-launch evidence

A successful `monkey` event proves that Android accepted the launch request, but it does not by itself prove that the process remained open. To capture stable evidence on Windows, run the following from `C:\Android\platform-tools` after installation:

```bat
adb logcat -c
adb shell am force-stop org.ncrra.memberapp
adb shell monkey -p org.ncrra.memberapp 1
adb shell pidof org.ncrra.memberapp
adb shell dumpsys activity activities | findstr /I "mResumedActivity org.ncrra.memberapp"
adb logcat -d -v time -t 300 | findstr /I "FATAL EXCEPTION AndroidRuntime org.ncrra.memberapp MainActivity"
```

A non-empty PID, a resumed activity containing `org.ncrra.memberapp`, and no matching fatal-exception lines provide focused evidence that the app remained open immediately after launch. If the final command prints a crash, preserve the complete output and do not paste tokens, passwords, PINs or private provider data into the report.

## Current artifact

The screenshots exposed an artifact-selection error. The command `flutter build apk --release --target-platform android-arm64` produced the current source-aligned APK at `build/app/outputs/flutter-apk/app-release.apk`; the older `app-arm64-v8a-release.apk` file retained an earlier build and was the file distributed in the previous handoff. That explains why the phone still showed uppercase section eyebrows and lightning icons even though the source had already been corrected.

The correct current artifact is `app-release.apk`, package `org.ncrra.memberapp`, version `0.1.0`, compile SDK 37, signed with the local non-debug staging key. Its SHA-256 is:

```text
9e7bd99891d12c190f8bf01ca3c2d0bc668b59226a6c354ef759dd0e700b43dd
```

The verified current artifact is uploaded at `/manus-storage/app-release_892f8f85.apk`. The older split file with SHA-256 `ba79b0ef8e3e476cb4962fdf84e12bd0690a93c13082bbe13bb16099e2d9aa00` must not be used for this visual review. Production distribution must use NCRRA’s protected release keystore.

## Package and activity verification

The source metadata was rechecked after the successful installation. The Android `applicationId` and Gradle namespace are `org.ncrra.memberapp`. The manifest launcher activity is `com.example.ncrra_member_app.MainActivity`, implemented by `MainActivity : FlutterActivity` at the matching Kotlin package path. The Windows command `adb shell am start -n org.ncrra.memberapp/com.example.ncrra_member_app.MainActivity` was accepted by the phone, and no MainActivity/package mismatch is currently evidenced. The latest `app-release.apk` rebuild is source-aligned with this verified package/activity wiring.

## Validation status

The user-supplied Windows evidence confirms that the ARM64 artifact installed and launched successfully on the Android 11 phone:

```text
C:\Android\platform-tools>adb install -r -d "C:\Users\osoro\Downloads\app-arm64-v8a-release.apk"
Performing Streamed Install
Success

C:\Android\platform-tools>adb shell monkey -p org.ncrra.memberapp 1
Events injected: 1
```

This closes the storage-blocked installation and basic launch checks for the previously delivered artifact only. A fresh clean installation is required for the current `app-release.apk` checksum above. The subsequent focused stability capture supplied by the user reported PID `11485`, a resumed `org.ncrra.memberapp/com.example.ncrra_member_app.MainActivity`, and no matching `FATAL EXCEPTION`, `AndroidRuntime` or NCRRA crash line. The unrelated `AppsEdge.Badge` line is not an NCRRA failure.

The sandbox still reports no connected ADB device and has no `/dev/kvm`, so it cannot independently complete navigation-speed, Keycloak authentication-session or emulator checks. Those items remain open until the user supplies the corresponding device evidence.

## References

[1]: https://developer.android.com/tools/releases/platform-tools "Android Developers — SDK Platform-Tools"
[2]: https://developer.android.com/studio/command-line/adb "Android Developers — Android Debug Bridge"
