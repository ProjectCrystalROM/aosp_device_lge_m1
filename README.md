# LG K7 CM13 device tree

**Status, 2026-10-24: builds, boots, and runs on the LG K7 MetroPCS MS330.**
The old V8 build-failure report is obsolete. The qualified bring-up product is
`cm_m1_radio_noselinux-userdebug`, running Android 6.0.1 / CyanogenMod 13.
Other K7 variants have not been qualified by this work.

## Branches and dependencies

Use the matching bring-up branches together in a complete CM13 checkout:

| Repository | Branch | Checkout path |
| --- | --- | --- |
| [Product device tree](https://github.com/airi-kozume/cyanogenmod_device_lge_m1/tree/bringup/cm13-m1) | `bringup/cm13-m1` | `device/lge/m1` |
| [Common device tree](https://github.com/airi-kozume/android_device_lge_m1-common/tree/resurrection/cm13-static-audit) | `resurrection/cm13-static-audit` | `device/lge/m1-common` |
| [Vendor inputs](https://github.com/airi-kozume/proprietary_vendor_lge_m1/tree/bringup/cm13-m1) | `bringup/cm13-m1` | `vendor/lge/m1` |
| [Source kernel](https://github.com/airi-kozume/cyanogenmod_kernel_lge_m1/tree/bringup/cm13-m1) | `bringup/cm13-m1` | `kernel/lge/m1` |

These repositories are components of the port, not a standalone ROM manifest.
The successful build uses the existing CM13 checkout, Java 7 / Trusty build
environment, reviewed platform changes and pinned input-staging tools. The
microG permission framework patch is required in addition to these device repos.
Stage the vendor microG APKs using `microg/stage.py`; do not re-sign them.

## Hardware and runtime status

| Area | Confirmed behavior |
| --- | --- |
| Build / boot | Full ROM packaging, clean flash/factory reset, normal boot and launcher access |
| Display / input | Display, touchscreen, backlight, software navigation and Recents |
| Wi-Fi | Scan, association, DHCP and Internet access; connected during earlier Setup Wizard testing |
| Bluetooth / audio | Pairing, speaker/ringer output and A2DP playback; simultaneous Wi-Fi streaming and BT audio |
| Cellular | SIM detection, IMEI and baseband; live service/data not yet qualified |
| Cameras | Rear/front preview and still saving; flash works, tap autofocus responds |
| Video | Rear 720p H.264 recording saves and plays with AAC audio; playback also exercised with YouTube |
| Sensors | Seven sensors enumerate; screen auto-rotate and upright saved-photo orientation work |
| WebView | Bundled Google WebView 107.0.5304.36; clean-flash system-provider login confirmed |
| microG | Upstream Services 0.3.17.252432 and Companion 0.3.17.40226 self-check entries pass |
| First boot | No Setup Wizard; AOSP-based Provision completes, sets both setup flags and disables itself |

GsfProxy v0.1.0 was installed separately and its Services Framework self-check
entry now passes. It is selected in current source for future builds and its
prebuilt packaging/signature check passes. The latest flashed ROM checkpoint
contains Services/Companion plus the Provision fix; it does not yet contain that
third APK in `/system`. Google login was confirmed with the earlier WebView107
setup; login on the newest bundled-microG candidate has not been reported.

## Remaining work

- Test live cellular service/data with an active compatible SIM.
- Resolve SELinux integration. The booted diagnostic product has SELinux disabled;
  the policy/kernel version mismatch remains unresolved.
- Finish validation of GPS, suspend/battery endurance, front-camera video,
  autofocus quality, call audio/Bluetooth HFP and longer workloads. These are
  unqualified areas, not a list of demonstrated failures.

## Products and validation

`cm_m1` is the retained baseline product. `cm_m1_radio` contains the focused
radio integration, but its SELinux-enabled boot is not qualified.
`cm_m1_radio_noselinux` is the currently boot-tested diagnostic product.

Image, installed-system, ELF linkage, target-files, signed OTA payload,
partition-write and allowed-delta checks pass for the recorded candidates.
Provision checks now inspect the actual DEX activity, not only its manifest:
the original missing ProGuard keep rule was fixed and first boot retested.

The bring-up workspace holds detailed evidence under `audit/` and immutable
ZIPs under `checkpoints/`; those artifacts are not distributed by this source
repository. Latest flashed checkpoint:

`checkpoints/microg/upstream-prebuilt-provision-fix/cm-13.0-20261024-UNOFFICIAL-m1_radio_noselinux_upstream_microg_webview107_provision_fix.zip`

SHA-256: `8086bed2f1ca8aae5f7dfc9928992bcea73869b3e561d69b508c1ab34147eda7`.

Keep the qualified rollback packages. The earlier upstream-microG ZIP with
SHA-256 `de95315d18d0a10bb6d51fba82a82cd937afe02b5b3712ff7cc66933a85af235`
has a confirmed Provision launch failure and is superseded.
