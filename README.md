# LG K7 MS330 — CyanogenMod 13

**Status: 2026-10-25. The standard `cm_m1-userdebug` product builds and boots on
MetroPCS MS330, with SELinux enforcing.** Android 6.0.1; other K7 variants have
not been qualified. The former build-failure and SELinux-disabled status is obsolete.

## Hardware status

✅ Working · ⏳ Awaiting testing · ➖ Outside scope / unsupported

| Feature | Status |
| --- | --- |
| Display, touch, backlight, Home and Recents | ✅ |
| Wi-Fi Internet access and saved-network persistence | ✅ |
| Bluetooth pairing, persistent bonds, automatic reconnect and A2DP | ✅ |
| Simultaneous Wi-Fi streaming and Bluetooth audio | ✅ |
| Speaker/media audio | ✅ |
| Front/rear photos and video recording with audio | ✅ |
| Rear flash and responsive tap focus | ✅ |
| Screen rotation and saved-photo orientation | ✅ |
| Hardware H.264 playback in the stock player | ✅ |
| MTP, PTP, MTP+ADB and PTP+ADB | ✅ |
| GPS / Maps location | ✅ |
| Overnight idle without observed problems | ✅ |
| SIM detection, IMEI and baseband | ✅ |
| Cellular data with an active SIM | ⏳ |
| Battery endurance during normal use | ⏳ |
| Cellular calls and call audio | ➖ No VoLTE support; the owner's local networks require VoLTE |
| USB OTG | ➖ Unsupported on this device |

GPS is confirmed on the latest persistent build; Maps locks and GPS Toolbox sees
20 satellites. Detailed satellite fix-status reporting, assistance downloads and
extended navigation accuracy remain developer follow-ups, not a claim that the
Maps location test failed. Overnight idle is an observation, not measured suspend
residency. Tap focus responding does not establish exhaustive autofocus quality.

## System integration

- SELinux boots enforcing with the existing userdebug domain exceptions
  (`su`, `sudaemon`, `qti-testscripts`); no blanket permissive system policy.
- Normal CM USB defaults: MTP, authenticated ADB when enabled by the owner.
  Simplified USB functions use matching LG identities, avoiding modem-driver
  binding against PTP and the prior Windows crashes.
- Backup & reset works. No Setup Wizard; the AOSP-based Provision activity sets
  Android provisioning flags and CM's separate setup-completed flag for Home.
- Bundled upstream microG Services 0.3.17.252432, Companion 0.3.17.40226 and
  GsfProxy 0.1.0, preserving upstream signatures. Self-check entries and account
  login have been confirmed during bring-up.
- Bundled WebView 107.0.5304.36; system-provider login confirmed.

## Matching branches and build dependencies

| Repository | Branch | CM13 checkout path |
| --- | --- | --- |
| [Product](https://github.com/airi-kozume/cyanogenmod_device_lge_m1/tree/bringup/cm13-m1) | `bringup/cm13-m1` | `device/lge/m1` |
| [Common](https://github.com/airi-kozume/android_device_lge_m1-common/tree/resurrection/cm13-static-audit) | `resurrection/cm13-static-audit` | `device/lge/m1-common` |
| [SoC common](https://github.com/airi-kozume/android_device_lge_msm8909-common/tree/bringup/cm13-m1) | `bringup/cm13-m1` | `device/lge/msm8909-common` |
| [Vendor](https://github.com/airi-kozume/proprietary_vendor_lge_m1/tree/bringup/cm13-m1) | `bringup/cm13-m1` | `vendor/lge/m1` |
| [Kernel](https://github.com/airi-kozume/cyanogenmod_kernel_lge_m1/tree/bringup/cm13-m1) | `bringup/cm13-m1` | `kernel/lge/m1` |

These are component repositories, not a standalone manifest. The qualified build
uses the existing CM13 checkout and Java 7 / Trusty environment, reviewed platform
changes and pinned APK staging. Apply the microG framework patch separately.
The Bluetooth address handoff needs the matching `system/bt` change supplied as
`bluetooth/system-bt-address-handoff.patch` in the common repository. Stage vendor
APKs using `microg/stage.py`; do not re-sign them. Select `lunch cm_m1-userdebug`.
Legacy `cm_m1_radio*` profiles remain diagnostic history, not the current product.

## Qualified checkpoint

Latest owner-flashed GPS build, with prior USB/wireless/camera fixes included:

`cm-13.0-20261025-UNOFFICIAL-m1.zip`

SHA-256: `eed9f07beabab5c7c3f2589f999b1a9ac44986b1a74866d9086e0e9947005cf2`

Workspace location: `checkpoints/gps/stock-hal-cm13-adapter/`.
Image geometry, installed payloads, ELF dependency names, 18 kernel modules,
target-files, APK signatures, signed OTA and actual system payload preservation
checks pass. Runtime claims above come from device testing, not static checks.
Workspace `audit/` evidence and immutable rollback ZIPs are kept outside this
repository. Raw location logs and host crash dumps are private evidence.
