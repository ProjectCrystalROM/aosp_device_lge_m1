# Peridot signing for Project Crystal AOSP5.1.1

The ROM retains its existing Peridot release/platform/shared/media signing
identities. Public certificates and fingerprints are in public-keys/. Private
keys and passwords live outside component repositories and are never published.
Do not generate replacement keys for routine updates.

Build aosp_m1-user in the documented Trusty14.04/Java7 environment, then sign a
separate target-files output with the AOSP5.1.1 releasetools:

```sh
python2.7 build/tools/releasetools/sign_target_files_apks \
  -p "$HOST_TOOLS" -d "$KEY_DIR" -o \
  "$INPUT_TARGET_FILES" "$SIGNED_TARGET_FILES"
python2.7 build/tools/releasetools/ota_from_target_files \
  -p "$HOST_TOOLS" --block -k "$KEY_DIR/releasekey" \
  "$SIGNED_TARGET_FILES" "$OUTPUT_OTA"
```

Generate fresh META/apkcerts.txt after package/certificate changes. PRESIGNED
microG and CrystalGram keep their original application signing identities.
WebView95 is source-built and signed as a ROM application; it is not the old
prebuilt WebView107. If release metadata needs ZIP duplicate normalization, retain
all member payloads and verify the resulting archive before OTA generation.

TWRP is the only supported recovery. TARGET_PRESERVE_INSTALLED_RECOVERY prevents
recovery replacement; no recovery image is a supported release deliverable.
The user/enforcing release has ro.secure1, ro.debuggable0, ro.adb.secure1, MTP default
and no early diagnostic USB. Separate explicit debug stages are not release builds.

Audit the whole-file OTA certificate, APK signatures, actual system block payload,
source-built kernel/DT/ramdisk, recovery preservation and absence of a data-format
request. Do not treat intermediate test-key OTAs as final signed releases.
Changing signing identity affects installed package/shared-UID state; any required
migration or reset is an operator action, never an automatic wipe by this recipe.
