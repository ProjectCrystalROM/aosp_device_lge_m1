# Source-built M95 WebView in the Lollipop ROM build

Version: Chromium 95.0.4638.74, ARMv7 standalone `system_webview_apk`,
`com.android.webview`, minimum API21 (our ROM is API22).

## Build

On the Debian WSL host, after the usual Trusty mounts are established:

```
bash aosp511/device/lge/m1/webview/sync-source.sh
bash aosp511/device/lge/m1/webview/build-rom.sh
```

The second command defaults to `droid otapackage k7-cm12-config`. It also accepts
individual Make targets, such as `webview`. It uses a separate ROM output tree,
`out-trusty-ms330-user`, for the final user/enforcing build. Explicit earlier
stage profiles retain their own output directories.
The normal release-signing process must still run before distributing a ROM.

The source checkout is the workspace sibling `webview-m95/src`, outside Android
Make's recursive scan. The tag and DEPS pin Chromium and its dependencies.
`sync-source.sh` also pins depot_tools; automatic tool updates are disabled.
M95 GN/Ninja runs on Debian, with pinned Python2.7.18/Python3.8.10 runtimes. Java7 and the
legacy ROM toolchain remain in Trusty.

## Dependency flow

`webview` depends on a generated APK. Its Make recipe always asks the worker to
run GN/Ninja, so Ninja checks changed sources and dependencies on every build.
Only changed APK bytes are copied. A failed source build fails the Make recipe;
there is no downloaded-APK or M39 fallback.

The wrapper starts a fixed-purpose same-UID Unix-socket worker in Debian, then
runs Make inside Trusty. The socket is visible through the workspace bind mount.
It accepts only `build-m95`, not commands or paths, and is removed when the
wrapper exits. Direct Trusty builds without the worker fail with an actionable
message if they reach WebView. One workspace lock prevents concurrent M95 output
writers.

Android's APK packaging rules sign the generated APK and extract both ARM JNI
libraries into the app's installed native-library directory. This matters for
Lollipop's WebViewFactory, which loads `libwebviewchromium.so` from that directory.
The framework loader and platform support libraries remain source-built against
the matching AOSP framework. Old Chromium's V8/ICU subset remains available for
libpac; the M39 WebView APK and engine are excluded when M95 is selected.

`args.gn` selects release settings, stable channel, no WebLayer, AAC/H264 codec
support and no PGO-profile dependency. It does not pretend the engine is newer
than M95. `webview-m95/artifacts/provenance.json` records the source/tool commits,
GN arguments and APK hash after a successful source build.

## Validation status

Source-built M95 passed full ROM signing/payload audits and the owner confirmed
version95 active in the built-in browser. User variant and enforcing stages passed
owner hardware regression. The final profile removes early diagnostic USB, selects
MTP by default and enables ADB host authentication; verify final USB behavior on
the device before claiming final-image acceptance.

Tooling pin: depot_tools aebf6247c9f293c8461e22a6145649bc3d797b35 (2021-11-01).
python.ensure pins both interpreter packages; system Python is not used by hooks.

The optional traffic annotation tool download is disabled through the upstream
checkout_traffic_annotation_tools custom variable; its historical storage object
is unavailable. This does not remove runtime traffic annotations or alter DEPS.

Host generator dependency: run build-host-tools.sh to install SHA256-pinned GNU
gperf3.1 under webview-m95/host-tools. Worker rejects other versions before building.
M95 injects fallthrough markers incompatible with gperf3.2 output.


## Release stages

Default `M1_BUILD_PROFILE=user-release`: user variant, enforcing SELinux, normal
MTP default and authenticated ADB enabled through Developer options. Earlier
operator-only stages `user-permissive`, `user-enforcing` and `userdebug` must be
selected explicitly. Final builds have no early unauthenticated USB fragment.

Host needs a Trusty14.04/Java7 chroot mounted at /srv/chroots/trusty, with this
workspace under /work/LG_K7 and user airi; build-rom.sh currently encodes that
local layout. Debian host additionally needs libc6-i386 and lib32gcc-s1 for V8's
32bit host generators, plus the pinned tools described above. This is not a
native Debian-only Android build.
