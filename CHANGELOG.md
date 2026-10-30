# Project Crystal AOSP5.1.1 changelog

## 2026-10-30

- Qualified user variant and SELinux enforcing stages after hardware regression.
- Added final user-release profile: authenticated ADB, MTP default and no early
  diagnostic USB fragment/import; supported simplified LG descriptors retained.
- Added supplied Project Crystal boot still, JPEG wallpaper and a populated
  CrystalGram/Contacts/All-apps/Camera/Browser default dock through device overlays.
- Published dedicated AOSP repositories and tracking/pinned manifests.

## 2026-10-28 to 2026-10-29

- Brought up official Android5.1.1_r38 on the source-built Linux3.10.108 kernel.
- Integrated CAF providers, storage/init fixes, HWC sentinel handling and supported
  media profiles/fonts. Restored hardware video via named V4L device aliases.
- Added source-built WebView95 through the ROM's GN/Ninja dependency bridge with
  pinned period-correct tooling and 32bit host runtime dependencies.
- Integrated release-signed CrystalGram and receive-only BasicSmsReceiver.
- Preserved TWRP and original upstream/application signing identities.

Earlier CM milestones are retained only in [historical changelog](docs/history/CM_CHANGELOG.md).
They are not the current product, build target or AOSP validation matrix.
