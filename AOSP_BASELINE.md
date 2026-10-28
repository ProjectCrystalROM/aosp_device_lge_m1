# AOSP MS330 product bootstrap

Select: lunch aosp_m1-userdebug (AOSP 5.1.1_r38/API22).
Independent source tree; original CM device/vendor/kernel sources unchanged.
Device geometry, stock firmware selection, no-dialer cellular/SMS profile,
original-signed microG APKs and K7Provision are inherited from the qualified
CM12.1 integration, with AOSP product composition and explicit APN selection.

Board uses accepted kernel snapshot at prebuilt/zImage (ignored binary).
Snapshot extracted from cleanup-fixed signed test boot: source afe9f369edee,
merged kernel baseline 25012611. Exact SHA256/source in workspace
 audit/aosp511/product-bootstrap/prebuilt-kernel.json.
Matching modules/DT/boot packaging must be integrated in the boot milestone;
this bootstrap is NOT a flashable image or a completed hardware port.

Trusty Java7 product selection and dumpvars PASS. Resolved packages include
GmsCore, Phonesky, GsfProxy, K7Provision, Mms and TeleService, exclude Dialer.
All 705 resolved copy-file sources exist. Evaluation does not prove every
module exists, builds or links. Qualcomm CAF providers/policy are not yet
imported. Binder/GPS/libc/signature-spoof patches are not applied to AOSP yet.
TARGET_PROVIDES_INIT_RC, stock DT and recovery-preservation build hooks still
need AOSP implementation. Preserve TWRP; no ROM should be flashed at this stage.
Root functionality/integration is outside this milestone's scope.

Local independent repos: device/lge/m1, device/lge/m1-common,
device/lge/msm8909-common and vendor/lge/m1; aosp-5.1.1-ms330 branches.
These are currently local additions, not published AOSP manifest projects.
