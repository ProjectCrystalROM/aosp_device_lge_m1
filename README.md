# Project Crystal AOSP5.1.1 — LG K7/MS330

Device product for the MetroPCS LG K7 MS330 (MSM8909), based on official
`android-5.1.1_r38` / API22. This repository's current build is `aosp_m1-user`.
Other K7 variants are not qualified.

## Get the complete source

Use the [Project Crystal AOSP manifest](https://github.com/ProjectCrystalROM/aosp_manifest)
on branch `aosp-5.1.1-ms330`. This product tree is one component, not a standalone ROM.
The manifest supplies matching device/common/vendor/kernel and platform repositories.

The supported build uses Trusty14.04/Java7 for Android and a Debian host worker for
source-built Chromium95. See [release integration](AOSP_RELEASE.md) and
[M95 build setup](webview/README.md) for the actual workspace/toolchain layout.
From the documented workspace:

```sh
bash aosp511/device/lge/m1/webview/sync-source.sh
bash aosp511/device/lge/m1/webview/build-rom.sh
```

Default profile: `user-release`, SELinux enforcing, authenticated ADB, MTP default,
no early diagnostic USB and no root integration. Preserve the simplified LG USB
profiles. TWRP is the supported recovery and is preserved by full OTA packaging.
Raw build outputs use test keys until the separate release-signing step.

## Included configuration

- Source-built Linux3.10.108 kernel at `kernel/lge/m1`; archived stock DT retained.
- Source-built WebView95.0.4638.74 using GN/Ninja as a ROM dependency.
- microG framework/libc/Binder/GPS adaptations and original-signed microG packages.
- Release-signed CrystalGram and receive-only BasicSmsReceiver; no voice Dialer or
  full SMS-sending app selected.
- Hardware video codecs, stock LG HALs/firmware and matched CAF userspace providers.
- Project Crystal boot still and default wallpaper; dock defaults to CrystalGram,
  Contacts, All apps, Camera and Browser. Existing personal layouts are preserved.

## Validation and limits

Owner regression checks passed Wi-Fi, Bluetooth, cellular data, applicable reboot
persistence, camera photo/video and audio input/output. Browser confirms WebView95;
manual incoming SMS is accepted for verification-code use. CrystalGram release
login/chat/push and appearance were confirmed. User/permissive and user/enforcing
stages passed hardware validation; final USB/artwork image acceptance is separate.

SIM changes require reboot. CSIM and voice/VoLTE remain outside this profile; USB
OTG and other device variants are not qualified. No later complete ASB coverage is
claimed: platform patch label remains2016-07-05. Inherited build helpers and history
are not alternative supported products; AndroidProducts.mk registers only aosp_m1.

[Current changelog](CHANGELOG.md) · [Release signing](release/README.md)
