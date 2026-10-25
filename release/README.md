# Peridot release signing

Public identity:

- CN: Peridot Release Signing Authority
- O: Homeworld Device Engineering
- OU: Crystal Gem ROM Division
- L/ST/C: Beach City / Texas / US
- emailAddress: alexis@estherose.online

`public-keys/` contains only public certificates and SHA-256 fingerprints.
Four distinct RSA 2048 keys use SHA-256 self-signed certificates: releasekey,
platform, shared and media. Private keys are passwordless PKCS8, stored outside
all component Git repositories with directory 0700/key 0600 permissions. They
are not included here, in target-files or in the OTA. Preserve the original
private key set for subsequent releases; generating new keys changes app/update
identity again. Workspace-private location is recorded in local handoff notes.

## Release process

Build the qualified target-files normally, then use CM13 releasetools in the
working Java 7/Trusty environment. Sign a separate output; preserve the unsigned
qualified package as rollback. With paths chosen for that environment:

```sh
python build/tools/releasetools/sign_target_files_apks \
  -p "$HOST_TOOLS" -o -d "$KEY_DIR" \
  -k "build/target/product/security/cm=$KEY_DIR/releasekey" \
  -k "build/target/product/security/cm-devkey=$KEY_DIR/releasekey" \
  "$INPUT_TARGET_FILES" "$SIGNED_TARGET_FILES"

python build/tools/releasetools/ota_from_target_files \
  -p "$HOST_TOOLS" -k "$KEY_DIR/releasekey" --block \
  "$SIGNED_TARGET_FILES" "$OUTPUT_OTA"
```

The two explicit CM-key mappings remove the old CM recovery-only trust keys.
The release-key fallback handles this product's empty META/otakeys.txt.
CM13's signer can duplicate META/releasekey.txt if it already exists: before
OTA creation retain only the final regenerated occurrence, after verifying no
other duplicate member exists and all other payload bytes remain unchanged.
The development workspace records this bounded normalization and its audit.

PRESIGNED upstream GmsCore, Companion, GsfProxy and WebView retain their exact
original APK bytes and signing identities. Source-built ROM apps use the
appropriate Peridot key. Signing also updates build tags/fingerprints,
certificate references in MAC/permission XML, OTA trust and recovery metadata.
It does not rebuild application code or replace hardware libraries/firmware.

Current signed release: `cm-13.0-20261025-UNOFFICIAL-m1.zip`

SHA-256: `cabd413563e4f8445fd0676903b58714c91855908eacebdbb7959f7577d91a53`

## First install and validation

The test-key to Peridot-key transition is treated as factory-reset-required:
PackageManager retains package/shared-UID signing identities in /data. Future
releases must reuse these keys for normal update compatibility. The owner
performs reset/flashing manually; no migration of old package-signature state
is attempted automatically. A recovery configured to enforce the old stock/test
trust keys will not automatically trust the new OTA certificate.

Release checks verify each re-signed APK's certificate and v1 payload digests,
original code/resources/manifests, byte-identical upstream APKs, unchanged native
payload/kernel/DT/policy, release-only recovery trust, geometry, OTA signature
pinned to releasekey, actual system.new.dat against signed system.img, and
partition-write scope. Signing is not a substitute for clean-install hardware
acceptance. Detailed audit and private device evidence stay outside Git.
