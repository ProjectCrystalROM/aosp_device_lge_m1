# CM12.1 hardware-qualified MS330 baseline — 2026-10-26

The cm12.1 branch is separate from CM13. Owner validated the signed DSI-fix
ROM: normal boot, home screen and sleep/wake; Wi-Fi/browser access; Bluetooth
pairing, notification audio and reboot persistence; front/rear photo and video
capture; Gallery recorded-video playback with audio; GPS (~20 satellites, ~6m
reported accuracy); GSM SIM recognition; LTE browser access and YouTube
streaming after reboot with the correct nxtgenphone APN.

The missing stock /system/etc/data/dsi_config.xml was the shared CM12/CM13 data
initialization blocker. Vendor source18bc953 restores it; CM13 live test and
CM12 signed-ROM runtime test passed. Source APN defaults were edited later and
are not part of this hardware-qualified ROM; saved owner APN was used.

CM12 Cyanogen recovery is BROKEN: Finding recovery package... followed by
bootloader. TWRP is the intended installed recovery. Full OTA preserves it;
separate CM recovery retest failed and must not be presented as working.
SIM changes require reboot; CSIM and voice/VoLTE remain outside this profile.
MicroG account/push and the WebView95 candidate are not newly qualified.

Reproduction uses Java7/Trusty; kernel/lge/m1-custom points to the independent
custom kernel on cm12.1, published in airi-kozume/cyanogenmod_kernel_lge_m1
cm12.1 (different kernel history from the CM13 branch). Original custom kernel
source remains unchanged. Common-tree platform/cm12.1 contains exact platform
patches, hashes and source pins, including Gallery and libc changes.

Hardware-qualified ROM SHA256:
8ba5854e5c7b92757cd652fcd750d85e9430afe77f27ac5ee4a43a03a14d9e26
ROM filename: cm-12.1-20261027-UNOFFICIAL-m1-peridot-data-fix.zip
(UTC build date; local qualification October26.) Offline release-signature,
81 APK, 17 kernel-module, DSI ext4 metadata, OTA block and recovery-preservation
checks passed. Keys, generated images and private raw logs are not published.

Earlier entries below retain their original chronological status.

# CM12.1 bring-up branch — experimental

This branch targets Android 5.1.1/API22 on the LG K7. It derives from the
qualified CM13 hardware/configuration baseline but has no CM12 hardware
acceptance yet. Build product: `cm_m1-userdebug`. Keep the ROM WebView and
original K7 radio/camera/JPEG/peripheral/GPS libraries where their Lollipop
interfaces fit. microG APK inputs retain their pinned upstream signatures.

Apply the CM12 platform patches documented in
`device/lge/m1-common/platform/cm12.1/README.md`; do not apply CM13 framework
or Bluetooth patches to this tree. Compile with period-correct Trusty/Java7.
The build launcher and offline audits live in the bring-up workspace tools/.

The existing sections below document the earlier CM13 release, not a qualified
CM12 build. No flash or migration operation is automatic.

---

# LG K7 MS330 — CyanogenMod 13

**Status: 2026-10-25. The standard `cm_m1-userdebug` product builds and boots on
MetroPCS MS330, with SELinux enforcing.** Android 6.0.1; other K7 variants have
not been qualified. The former build-failure and SELinux-disabled status is obsolete.

Development history: [dated changelog](CHANGELOG.md).

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
changes and pinned APK staging. Apply the tested microG framework patch supplied in
`platform/frameworks-base-microg.patch` in the common tree; its exact base and
commit are documented in `platform/README.md`.
The Bluetooth address handoff needs the matching `system/bt` change supplied as
`bluetooth/system-bt-address-handoff.patch` in the common repository. Stage vendor
APKs using `microg/stage.py`; do not re-sign them. Select `lunch cm_m1-userdebug`.
Legacy `cm_m1_radio*` profiles remain diagnostic history, not the current product.

## Preserved GPS rollback

Owner-qualified GPS build, with prior USB/wireless/camera fixes included:

`cm-13.0-20261025-UNOFFICIAL-m1.zip`

SHA-256: `eed9f07beabab5c7c3f2589f999b1a9ac44986b1a74866d9086e0e9947005cf2`

Workspace location: `checkpoints/gps/stock-hal-cm13-adapter/`.
Image geometry, installed payloads, ELF dependency names, 18 kernel modules,
target-files, APK signatures, signed OTA and actual system payload preservation
checks pass. Runtime claims above come from device testing, not static checks.
Workspace `audit/` evidence and immutable rollback ZIPs are kept outside this
repository. Raw location logs and host crash dumps are private evidence.

## Future-build owner preference: cellular tablet

The standard `cm_m1` source keeps normal phone wording/layout, with voice
capability disabled and SMS capability enabled. Dialer is omitted; cellular
RIL/data services, messaging, SIM toolkit and cell broadcasts remain selected.
The small screen's density, navigation and other hardware settings are retained.
Legacy diagnostic product selections are unchanged.

This customization is included in the latest owner-booted build below; the
earlier GPS ZIP above remains a preserved phone-profile rollback.
The focused package-graph/resource checks verify the selection; SMS delivery
still needs an active SIM. When reusing output staging, remove only the
identity-verified stale `priv-app/Dialer/Dialer.apk` before system packaging;
the workspace build helper handles this for the normal product. Merely removing
Dialer from PRODUCT_PACKAGES does not clean an old installed APK automatically.

Latest behavior-only build, 2026-10-25; normal phone wording retained.
SHA-256: `aabcf34c5f20ccf92683232d6134177b75a468f3df163710bef92a18a40bf805`. Owner confirms boot after reoptimization and no regressions in a quick check.
A new overnight check with Wi-Fi, Bluetooth and cellular registration enabled
passed; GPS and photos with/without flash work after wake. Battery 97% to 78%
over approximately 04:41–12:00 (7h19m), about 2.6 percentage points/hour.
This is an approximate idle observation, not active-use endurance validation.
Active-SIM data and active-use endurance remain pending; deeper review will
follow when convenient. Inactive-SIM LTE/Home registration was confirmed on
the earlier GPS build, not a substitute for active-data testing.

## Peridot release signing

A separately signed release of the same qualified build is available in the
development workspace. Public certificate identity, fingerprints, key mapping
and first-install requirements: [release signing notes](release/README.md).
Release ZIP SHA-256: `cabd413563e4f8445fd0676903b58714c91855908eacebdbb7959f7577d91a53`.
Signing/payload audits pass. Owner confirms Android boot and hardware checks on
this signed release. The matching Cyanogen recovery also passes boot, signed-ZIP
verification and ADB sideload installation in a separate reflash test. Earlier
test-key builds remain preserved rollback/source-baseline artifacts.
