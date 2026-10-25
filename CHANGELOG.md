# LG K7 MS330 / CM13 development changelog

October 21–25, 2026. These are bring-up milestones, not separately numbered
public releases. Dates follow the owner's local development timeline; generated
ZIP names sometimes carry the following day's date. Failed experiments and
superseded diagnostic ZIPs are not recommended downloads.

## 2026-10-21 — First boot

- Reconstructed the CM13 build and resolved source/prebuilt provider conflicts.
- Repaired the graphics/crypto startup failure that prevented SurfaceFlinger
  from loading the retained Adreno stack.
- Reached boot animation, app optimization, Setup Wizard and the launcher.
- Established the initial diagnostic baseline. Touch/audio/wireless/radio,
  wake behavior and battery reporting still needed integration or repair.

## 2026-10-22 — Usable device baseline

- Integrated the MS330 source kernel and repaired touch and battery-reporting
  behavior, including the false-zero charge condition.
- Restored usable navigation, display/backlight/wake and speaker/media audio.
- Confirmed SIM detection, IMEI and baseband with the retained stock radio stack.
- Reached a usable home-screen/offline-app baseline; Wi-Fi/Bluetooth were still
  outstanding. The preserved build is labeled October 22; associated source
  milestones were subsequently committed October 23.

## 2026-10-23 — Wireless, cameras and rotation

- Corrected WCNSS firmware/startup ordering and Wi-Fi firmware reload handling;
  resolved the wireless-startup watchdog failure.
- Qualified Wi-Fi Internet access, Bluetooth pairing/A2DP, and simultaneous
  Wi-Fi streaming with Bluetooth audio.
- Restored camera HAL discovery and focused stock camera-daemon startup.
- Integrated matched H631 sensor/JPEG compatibility adapters without replacing
  CM13 platform camera libraries; both cameras save photos.
- Restored the stock sensor HAL, screen rotation and photo orientation.
- Restored suitable Dalvik heap limits so stock Camera2 can process full-size
  captures. Qualified the combined camera/sensor/heap build after a clean wipe.

## 2026-10-24 — Video, system integration and enforcing SELinux

- Restored H.264/AAC recording using the matched stock K7 Venus firmware and
  recording profiles; qualified front/rear video with sound during regression.
- Registered Qualcomm hardware H.264 decoding, fixing the stock player's
  front-camera clip freeze and avoiding the former software-only decode path.
- Integrated the supplied WebView107 APK; confirmed system-provider login.
- Added microG framework support and pinned upstream microG components;
  Services Framework Proxy followed after self-check validation.
- Replaced Setup Wizard with direct-to-home Provision and corrected its initial
  activity-stripping/build issue. The separate CM Home gate was completed later.
- Backported required kernel policy/ioctl compatibility and rootfs labeling;
  progressed from permissive diagnostics to boot-time enforcing SELinux with
  scoped device rules and existing userdebug-domain exceptions.
- Fixed the Bluetooth address handoff so controller identity and saved bonds
  persist across boots; confirmed automatic headset reconnection.

## 2026-10-25 — Standard product, USB, GPS and final profile

- Promoted the qualified integration to normal `cm_m1-userdebug`, retaining
  enforcing SELinux and authenticated CM USB/ADB defaults.
- Made Wi-Fi HAL/config dependencies explicit, fixing the missing-payload
  regression exposed by the product switch.
- Completed CM's provisioning flag for Home and restored Backup Manager,
  fixing the Settings Backup & reset crash.
- Restored Android's USB service/notification selector and corrected LG
  FunctionFS startup ordering.
- Matched simplified USB functions to LG's corresponding identities, avoiding
  erroneous Windows modem-driver binding and the observed host crashes.
  Qualified MTP, PTP, MTP+ADB and PTP+ADB.
- Restored GPS HAL selection with a narrow CM13 XTRA callback adapter; confirmed
  Maps location and satellite visibility on the persistent build.
- Retained cellular data/SMS services while removing Dialer and disabling voice
  capability. Normal phone wording, display layout and navigation are retained;
  this is behavior-only customization, not tablet branding.
- Confirmed inactive-SIM LTE registration on the earlier GPS build; active data
  service is still untested. The final profile boots and passes the owner's
  quick regression check after app reoptimization.
- Repeated overnight idle testing on the final build with Wi-Fi, Bluetooth and
  cellular registration enabled. GPS and photos with/without flash work after
  wake. Battery dropped 97% to 78% over approximately 7h19m on the original battery
  (about 2.6 percentage points/hour); active-use endurance remains unqualified.
- Published the component fixes and exact platform patches with reproducible
  bases, README updates and preserved rollback checkpoints.

## Current build

`cm-13.0-20261025-UNOFFICIAL-m1.zip`

SHA-256: `aabcf34c5f20ccf92683232d6134177b75a468f3df163710bef92a18a40bf805`

Workspace checkpoint: `checkpoints/cellular-tablet/sms-data-no-dialer/`.
The filename is shared by several development checkpoints; identify the current
build by its SHA-256, not the basename alone. This source repository does not
host the flashable ZIP. Owner performs flashing; preserved GPS/USB packages
remain available as rollback artifacts in the development workspace.

## Remaining scope

- Active-SIM cellular data; SMS capability is retained but delivery is untested.
- Active-use battery endurance and longer workloads.
- Detailed GPS fix-status/assistance behavior remains a developer follow-up;
  ordinary Maps location is confirmed working.
- Cellular calls/call audio are outside scope: this port lacks VoLTE support
  and the owner's local networks require VoLTE. USB OTG is unsupported.
- Results apply to MetroPCS MS330; other K7 variants are not qualified.

Hardware claims come from owner testing and local runtime evidence. Image,
module/linkage, target-files, signature and actual signed-payload audits support
packaging integrity; static checks alone are not hardware qualification.

## 2026-10-25 — Peridot release signing

- Added distinct release/platform/shared/media signing keys under the Peridot
  Release Signing Authority identity; published public certificates only.
- Re-signed the qualified build and changed OTA/recovery trust to Peridot.
- Kept upstream microG and WebView APKs byte-identical and preserved application
  code, native components, kernel, policy and hardware configuration.
- Release signature and exact payload audits pass. Initial clean install after
  switching away from test keys remains pending.

Signed ZIP SHA-256: `cabd413563e4f8445fd0676903b58714c91855908eacebdbb7959f7577d91a53`. See [signing notes](release/README.md).
