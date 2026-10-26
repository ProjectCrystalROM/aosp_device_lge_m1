# 2026-10-26 — GPS owner validation

- Owner reports CM13-equivalent GPS: GPS Toolbox sees 20 satellites and
  approximately 6 m reported accuracy. Basic GPS operation is owner-validated.

# 2026-10-26 — Recorded-video playback with audio confirmed

- Gallery revision1 failed because its guard matched an earlier protected block.
  Revision2 source774b3a12c guards the actual asynchronous title setter. Final
  APK DEX confirms both null checks; platform signature and code-only change pass.
- Owner confirms recorded-video playback succeeds, including recorded voice/audio.
  Candidate metadata and hardware notes updated; other formats remain unqualified.

# 2026-10-26 — First native CM12 home screen and hardware checks

- Owner confirms home screen after UI feature declaration hotfix; Wi-Fi connect
  and Google page load, Bluetooth pairing/connection and notification audio,
  front/rear photo/video capture, sleep/wake, SIM recognition and standard GSM SIM.
  Existing CSIM issue remains out of scope; active service/data not qualified.
- Recorded-video Gallery failure is a null ActionBar in MovieActivity title
  callback. Gallery2 cm12.1 commit41fd9d78d adds the missing guard. Trusty build
  and Peridot platform APK signature checks pass; only DEX payload changes.
- Signed app update ready at checkpoints/cm12.1/gallery-video-fix-20261026;
  agent has not installed it, playback retest pending. Preserve original system
  APK via normal app update. Full release remains unqualified/TWRP only.

# 2026-10-26 — Native CM12 boot completed; UI feature fix prepared

- Independent custom_kernel_cm12 fork preserves FenomenalMOD reference; only
  touch/BMS fallbacks ported. Kernel/modules built in Trusty; hardware testing
  uses native CM12 ramdisk with early ADB and TWRP safeguards.
- Live evidence identified missing bootdevice aliases. msm8909-common b32b7ba
  restores TARGET_PLATFORM_DEVICE_BASE; rebuilt init reaches animation/ADB.
- m1-common d541544/dafbd47 restore Lollipop storage environment/layout/FUSE.
  Product b485a40 supplies emulated-volume framework overlay. Signed minimal
  framework hotfix installed by owner; readback matches expected APK hash.
- sys.boot_completed=1, bootanim stopped; owner confirms sleep/wake. UI still
  loops: missing camera.flash/app_widgets features suppress torch/appwidget
  services. m1-common b07db9d fixes declarations; signed one-XML TWRP hotfix
  and guarded rollback checked, hardware test pending.
- Latest artifacts: checkpoints/cm12.1/ui-feature-fix-20261026. Continue with
  storage-layout-fix temporary boot image. No additional phone writes by agent.
- QMI errors remain, but modem firmware boots and some transactions succeed.
  tcp_htcp RAM bind is enforcing-denied; proper module deployment remains pending.
  Full release packaging still blocked until TWRP-only flow is implemented.

# 2026-10-26 — First hybrid unchanged; classpath-only CM13-base probe

- Owner temporary-booted the first hybrid for about90seconds: LG splash/dim
  display, no animation or ADB. No kernel-only resolution demonstrated.
- Prepared a second probe retaining complete CM13 boot base, correcting only
  BOOTCLASSPATH for CM12 and disabling CM recovery replacement for TWRP.
- Exact component/ramdisk/header checks pass. Second probe is not hardware tested.
  No agent device action, system modification or new recovery image.

# 2026-10-26 — Controlled hybrid boot experiment prepared

- Prepared exact archived CM13 kernel/DT with CM12 ramdisk and correct CM12
  boot classpath; only ramdisk edit disables CM recovery replacement for TWRP.
- Offline component/header/ramdisk audits pass.18 CM12 modules match donor
  symbol CRCs and vermagic suffixes. No force-load or module replacement.
- Temporary boot image is untested; no device action performed. Outcome must
  precede any claim that kernel versus ramdisk failure has been isolated.

# 2026-10-26 — Boot failure; TWRP-only recovery policy

- Owner reports native CM12.1 boot stalls at LG splash/dim display without ADB.
- Complete CM13 boot image reaches animation/ADB with CM12 system, then Zygote
  fails loading Policy. Offline artifact defines that class; CM13 boot classpath
  omits CM12 android.policy.jar. Kernel versus ramdisk cause remains unisolated.
- CM recovery is rejected permanently: LG reset prompt acts like stock, performs
  a reset and attempts the broken OS. The same LG entry sequence works correctly
  with TWRP; the problem is CM recovery interpretation. TWRP is the ONLY recovery.
- Removed CM recovery-replacement service/trigger from active core init; source
  change is unbuilt. TWRP-only OTA packaging still requires adaptation/audit.
- Old ROM/recovery artifacts are deprecated evidence, not recommended installs.

# 2026-10-26 — CM12.1 recovery hardware failure

- Owner marks CM12.1 recovery broken: ADB sideload fails immediately and red
  error text disappears before it can be read.
- Current cache logs mix CM13/CM12.1 sessions; diagnosis awaits a fresh log pull.
- No cause established or repair applied. Offline checks do not qualify runtime.
- ROM Android boot/hardware/microG acceptance remains unreported.

# CM12.1 first-build candidate — 2026-10-26

- Android 5.1.1/API22 cm_m1-userdebug builds in Trusty with Java7.
- Retains qualified K7 kernel fixes, stock DT/partition layout, heap and routing.
- Uses original K7 peripheral client, camera sensor/JPEG libraries and direct GPS
  HAL with a device-scoped callback correction; removes the CM13 RIL/GPS shims.
- Includes source signature reporting, three pinned upstream microG APKs with
  original signatures and API22 JNI layout, and the ROM's default WebView.
- Backports three real libc entry points required by bundled Cronet; ARM tests cover
  checked pread, strerror/errno, fork ordering, DSO cleanup and actual Cronet load.
- Offline native closure, boot/recovery and kernel-module checks pass.
- First CM12.1 boot, hardware regression and microG runtime acceptance pending.
- Peridot-signed first test ZIP and matching recovery completed; all 81 APK
  signatures/payloads, actual OTA system blocks and embedded recovery trust pass.
- Exact artifact hashes and the pre-hardware checklist are recorded in
  release/CM12.1_FIRST_TEST.md. No hardware acceptance or remote publication yet.

Earlier sections below describe the separate CM13 release.

---

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
- Release signature and exact payload audits pass. Owner confirms Android boot
  and hardware checks pass on the Peridot-signed release.
- Separately hardware-tested the matching Peridot-key Cyanogen recovery:
  recovery boot, verification of the signed release ZIP, and ADB sideload
  installation pass. This was a second flash specifically to validate recovery.

Signed ZIP SHA-256: `cabd413563e4f8445fd0676903b58714c91855908eacebdbb7959f7577d91a53`. See [signing notes](release/README.md).
