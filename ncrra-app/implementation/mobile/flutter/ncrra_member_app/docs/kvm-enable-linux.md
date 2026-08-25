# Android Emulator KVM enablement

The NCRRA APK is compiled. The Android emulator cannot start in the current sandbox because `/dev/kvm` is absent; this is a host or nested-virtualization setting, not an application setting. The sandbox cannot enable BIOS virtualization, load the host kernel module, or change the hypervisor configuration from inside the project.

## Ubuntu host with direct hardware access

On the Ubuntu machine that will run the emulator, enable Intel VT-x or AMD-V/SVM in firmware, reboot, then run:

```bash
sudo apt update
sudo apt install -y cpu-checker qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
kvm-ok
sudo usermod -aG kvm,libvirt "$USER"
```

Log out and back in, or reboot. Confirm:

```bash
ls -l /dev/kvm
stat -c '%U %G %a' /dev/kvm
adb version
emulator -accel-check
```

The expected result is a readable `/dev/kvm` device and an emulator acceleration message showing KVM is usable. Do not loosen `/dev/kvm` permissions globally; use group membership and the host’s normal device policy.

## Nested VM or cloud host

If the sandbox is itself a VM, the outer hypervisor must expose nested virtualization. Enable the provider’s nested-virtualization option, power-cycle the guest, then verify `egrep -c '(vmx|svm)' /proc/cpuinfo` returns a value greater than zero and that `sudo modprobe kvm_intel` or `sudo modprobe kvm_amd` succeeds. For a managed cloud runner, use a VM size/family that explicitly supports nested virtualization; if the provider does not expose it, move the Android test job to a dedicated CI runner or physical Android device.

## NCRRA AVD launch after KVM is available

```bash
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

emulator -accel-check
emulator -avd ncrra_api35_lightweight -no-snapshot -no-boot-anim -gpu swiftshader_indirect -no-audio &
adb wait-for-device
adb shell getprop sys.boot_completed
```

Install the APK and inspect the callback registration:

```bash
adb uninstall org.ncrra.memberapp || true
adb shell getprop ro.product.cpu.abilist
adb install app-arm64-v8a-release.apk
adb shell dumpsys package org.ncrra.memberapp | grep -A 6 -B 2 'ncrra'
```

Run the app with an approved non-production HTTPS Keycloak discovery URL and public client ID. Record sign-in, PKCE callback, refresh, cancellation, sign-out and secure-storage deletion evidence. Never place passwords, refresh tokens or client secrets in this repository or CI logs.

## Current NCRRA artifact

The current final redesigned ARM64 split release APK is `app-arm64-v8a-release.apk`, package `org.ncrra.memberapp`, version `0.1.0`, compile SDK 37, and SHA-256 `4d1e6abffac2aceed8c044d6584e4d813943ccfdcd2df12a30393cee0a932c7e`. It includes the fully-qualified MainActivity fix, cached theme creation, single-pass ticket filtering, explicit top-level crossfade/slide motion, corrected bottom-navigation destinations, working Home quick actions, explicit labels on primary actions, safe feedback for prototype-only actions, a dedicated membership-details screen, clearer renewal/due-state hierarchy, explicit payment success, unavailable-card error and no-contribution-due empty screens, membership details-saved success and refresh-error screens, a receipts empty state, and the researched navy/dusted-blue/warm-sand palette. It is signed with a local non-debug staging key; production distribution must use NCRRA’s protected release keystore. If an older debug build is installed, uninstall it first because Android will reject an update signed by a different key.

## References

[1]: https://developer.android.com/studio/run/emulator-acceleration "Android Developers — Configure hardware acceleration for the emulator"
[2]: https://www.kernel.org/doc/html/latest/virt/kvm/index.html "Linux Kernel Documentation — KVM"
