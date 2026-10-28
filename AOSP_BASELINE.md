# AOSP MS330 product bootstrap

Select: lunch aosp_m1-userdebug (AOSP 5.1.1_r38/API22).
Independent source tree; original CM device/vendor/kernel sources unchanged.
Device geometry, stock firmware selection, no-dialer cellular/SMS profile,
original-signed microG APKs and K7Provision are inherited from the qualified
CM12.1 integration, with AOSP product composition and explicit APN selection.

Kernel is built from source at kernel/lge/m1 using
m1_mpcs_us-perf_defconfig and AOSP's ARM GCC4.8 toolchain. The independent
source checkout starts at accepted cm-12.1 merge 25012611 (same source tree
as hardware-tested afe9f369); source changes are handled by Kbuild on each
invocation. No kernel binary fallback is configured. kernel.mk compiles zImage
and all 17 matching modules into PRODUCT_OUT/obj/KERNEL_OBJ, installs kernel
at PRODUCT_OUT/kernel and modules at system/lib/modules, and registers the
modules in the system image dependency graph. Use `make -j8 kernel` after lunch.
Stock DT, init and recovery-preserving OTA integration remain later milestones;
this product is NOT yet a flashable image or completed hardware port.

Trusty Java7 product selection and dumpvars PASS. Integrated `make -j8 kernel`
PASS (2m10s), generating 3.10.108-g2501261 and 17 modules. All installed files
match generated outputs; vermagic/imported CRC checks PASS; enabled config
options identical to accepted hardware configuration. Evidence: workspace
audit/aosp511/source-kernel/validation.json. Resolved packages include
GmsCore, Phonesky, GsfProxy, K7Provision, Mms and TeleService, exclude Dialer.
All 705 resolved copy-file sources exist. Evaluation does not prove every
module exists, builds or links. Qualcomm CAF audio/display/media providers are now imported locally; the
focused HAL, SurfaceFlinger and media-service build is validated as described
below. Qualcomm policy integration remains pending. MicroG signature reporting, permission API entries, Cronet libc compatibility,
LG Binder exports, XTRA layout and AGPS fallback are now applied on AOSP-only
branches. MicroG location-provider allowlisting lives in the device overlay.
Full affected framework/resources/native-library build PASS. Ten extracted-Java
signature cases, seven 32-bit ASAN AGPS cases, XTRA ABI and actual ARM32 Parcel/
libc QEMU regression checks PASS. Binder IPC/destruction and hardware/microG
runtime acceptance remain untested. Evidence: audit/aosp511/compatibility.
Board-provided RIL library/daemon ownership guards have been applied so full
Android makefile evaluation can reach the source-kernel target.
TARGET_PROVIDES_INIT_RC, stock DT and recovery-preservation build hooks still
need AOSP implementation. Preserve TWRP; no ROM should be flashed at this stage.
Root functionality/integration is outside this milestone's scope.

Local independent repos: device/lge/m1, device/lge/m1-common,
device/lge/msm8909-common, vendor/lge/m1 and kernel/lge/m1;
aosp-5.1.1-ms330 branches.
These are currently local additions, not published AOSP manifest projects.

CAF integration (2026-10-28): tested CM12.1 msm8916 audio/display/media source
repositories are selected for MSM8909 via caf.mk. QPNP lights remain source-built.
Focused AOSP HWC/SurfaceFlinger and audio header adaptations preserve matching
Qualcomm interface layouts. Board ABI compiler flags apply after toolchain
initialization for GCC and Clang. Optional CM-only BFQ priority and EGL GPU
performance hints are omitted; ordinary display priority/composition remain.
The kernel exports its own headers before concurrent HAL/kernel compilation.

Eng/userdebug use boot-time ADB without authentication and SELinux permissive
for first-boot logging, with SELinux still enabled and standard ro.secure=1.
User builds retain enforcing command line and authenticated ADB configuration.
These are diagnostic settings pending device testing, not production acceptance.
Evidence, exact validation scope and local commits:
audit/aosp511/caf-integration/README.md and validation.json.
No recovery image or flashable AOSP ZIP has been produced by this stage.
