# Project Crystal AOSP5.1.1 — LG K7/MS330

Foundation: official android-5.1.1_r38 (API22 / LMY49M). Security patch label remains
2016-07-05; no later complete ASB coverage is claimed. Source kernel is the accepted
Linux3.10.108 MS330 kernel; boot packaging retains the archived stock DT. There is
no prebuilt kernel fallback. CAF msm8916 hardware stack supports this MSM8909 device.

## Current release profile

Use `webview/build-rom.sh`; default M1_BUILD_PROFILE=user-release builds a user ROM,
SELinux enforcing, ro.secure1, ro.debuggable0, authenticated ADB and MTP default.
The early diagnostic USB fragment is absent and not imported. Standard ADB is
available through Developer options and requires host authorization. Keep the
simplified LG USB descriptors; do not restore OEM composite/serial profiles that
caused host-driver failures. No root integration is selected.

TWRP is the supported recovery. Full OTA preserves installed recovery and does not
request a data wipe. Native AOSP recovery is an internal build artifact, not a
supported deliverable. Build boot.img from the source kernel and generated ramdisk;
OTA's 'prebuilt boot.img from IMAGES' message refers to that finished build output.

## Included functionality

- Source-built Chromium95.0.4638.74 through GN/Ninja as a dependency of normal Make;
  original small V8/ICU subset retained for the proxy resolver.
- microG signature-spoofing adaptation, libc/LG Binder compatibility and GPS ABI fixes.
- Original-signed pinned microG packages with API22-compatible native installation.
- Presigned CrystalGram0.29.1.1820 and source-built BasicSmsReceiver; no Dialer/Mms UI.
- Qualcomm hardware video codecs restored through named V4L device aliases.
- AOSP HWC sentinel fix, supported media profiles/fonts, storage/platform init fixes.
- SIM/APN configuration includes nxtgenphone. SIM swaps require reboot; CSIM remains
  an inherited out-of-scope limitation.

Hardware regression passed on M95/messaging, user/permissive and user/enforcing
stages: Wi-Fi, Bluetooth, cellular data and applicable reboot persistence, camera
photo/video and audio input/output. Browser reports active WebView95. Incoming SMS
accepted for verification codes. CrystalGram release install/login/chat/colors/
strings and real push delivery through microG confirmed. Final diagnostic-USB-removal
image still needs its own boot/USB acceptance; do not conflate prior stage results.

Stock Android fallback boot logo is 512px wide on a 480px screen and clips at the
sides. Custom bootanimation.zip can replace it; no artwork selected yet.

## Build prerequisites

See webview/README.md for Trusty14.04/Java7 ROM toolchain, Debian host runtimes and
pinned M95/depot_tools/Python/gperf setup. AOSP source folder must be named aosp511
under the shared workspace with the documented chroot mounts/user. Sync-source.sh
prepares Chromium outside the ROM source scan. Restore chroot mounts after WSL restart.

Provision ignored microG inputs with vendor/lge/m1/microg/stage.py --fetch
--extract-arm-jni. Provision the exact CrystalGram ARMv7 APK from its published
GitHub release using vendor/lge/m1/crystalgram/stage.py --apk /path/to/release.apk;
release.json pins the hash/signer. Build wrapper verifies and stages these inputs.
No API/Firebase source config, private release keys or signing passwords belong in
this source tree or system image. Supply private ROM release keys separately for
final OTA signing; do not distribute raw test-key build outputs as the signed ROM.

Earlier stage profiles remain explicit for debugging; do not ship them as user-release.
The long-term goal is build-time compilation of all components whose source permits
it. CrystalGram and microG are currently pinned signed APK inputs; proprietary LG
HALs/firmware and archived DT remain binary inputs. This is the current scope.
