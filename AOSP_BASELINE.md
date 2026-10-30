# Historical first-baseline notes

These notes describe the initial bringup, not the current release. See
[AOSP_RELEASE.md](AOSP_RELEASE.md) for the maintained state.

# AOSP MS330 first hardware baseline

Select `lunch aosp_m1-userdebug` in the independent AOSP android-5.1.1_r38 tree.
A full system/boot/target-files/OTA build now passes in Trusty with Java7.
Signed deliverables: checkpoints/aosp511/20261028-first-baseline in the workspace.
No phone was accessed. This is not hardware acceptance: RIL/data failure is an
owner-accepted known issue while the remaining hardware is established.

Kernel is source-built from kernel/lge/m1 at accepted 25012611, Linux3.10.108,
using m1_mpcs_us-perf_defconfig and AOSP ARM GCC4.8. No kernel binary fallback.
All 17 modules match source outputs and pass vermagic/imported-CRC validation.
The archived stock DT is explicitly packaged in boot images and target-files.

CAF msm8916 display/audio/media sources are selected for MSM8909. Focused
Qualcomm HWC/audio interfaces, BLIT/fence/damage handling and compiler flags
are carried without replacing generic AOSP framework code with CM. Both ARM
header sets match and native compatibility tests pass. Optional CM-only EGL
GPU performance hints/BFQ priority calls are omitted. QPNP lights are built
from source. Evidence: audit/aosp511/caf-integration.

MicroG signature spoofing, requested-permission API22 behavior, libc exports,
LG Binder readuInt64, XTRA callback layout and AGPS fallback are applied.
Original-signed GmsCore/Phonesky/GsfProxy plus separate ARM JNI are retained;
release signing preserves their certificates/payloads. No-dialer profile,
K7Provision, original ROM WebView and nxtgenphone APN selection remain.
Source helpers for WCNSS, CNE, BSON and curl are retained from qualified CM
repositories; legacy AudioParameter and shared XML providers use AOSP source.
The stock Bluetooth helper receives the selected persistent controller address.

Init is generated from current AOSP core init with reviewed device adaptations,
no CM init dependency, correct radio/media groups and no recovery-replacement
service. qcom_diag is GID3009. Ueventd honors the platform device base and creates
bootdevice aliases for the correct controller, including SELinux best-match
paths. Lollipop storage, mounts, classpaths and vold completion are retained.
Qualcomm vendor policy compiles against unchanged AOSP platform policy and
passes context checks; no new vendor permissive domains were added.
Evidence: audit/aosp511/init-usb and audit/aosp511/policy.

Eng/userdebug expose diagnostic ADB before mount_all, without authentication,
with SELinux still enabled/permissive and standard ro.secure=1. User selection
retains enforcing/authenticated configuration. LG simplified device-mode USB
IDs are retained: MTP631C, MTP+ADB61F9, PTP631E, PTP+ADB631D, adb_only631F,
all VID1004 and class0/0/0. Generic/legacy composite USB scripts are not imported.
Actual host enumeration and runtime acceptance remain pending.

The OTA preserves TWRP: no recovery image/write/restoration payload and no
requested data format. Two-step recovery-replacing OTAs are rejected. Existing
Peridot signing identities are reused. CM-to-AOSP userdata/dirty-flash behavior
is not qualified. Packaging may generate an internal recovery for metadata;
it is not the intended or delivered recovery. Root integration is excluded.
Evidence: audit/aosp511/packaging; that directory records local commits,
artifact checksums and validation scope. AOSP branches/additional repositories
are local and have not been published in a remote AOSP manifest. Original CM12,
CM13 and custom-kernel trees remain unchanged. No new SPL is claimed; this
baseline retains r38's 2016-07-05 source declaration.
