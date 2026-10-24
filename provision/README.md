# K7 first boot without SetupWizard

**Boot-tested, 2026-10-24:** the owner reaches the launcher immediately and
Recents works. ADB confirms `DEVICE_PROVISIONED=1`, `USER_SETUP_COMPLETE=1` and
that `DefaultActivity` disables itself after running.

`K7Provision` overrides Provision/CyanogenSetupWizard/SetupWizard only in the
focused K7 radio products. The manifest, Java activity and ProGuard keep rule
come from CM13/AOSP Provision. It sets the normal setup-complete flags, disables
its own activity and finishes. microG/account configuration happens afterward.
No framework or global CM package-list modification is required.

## Regression checks

Keep `proguard.flags` and its `LOCAL_PROGUARD_FLAG_FILES` reference. Omitting
them produced a 140-byte empty DEX and a `DefaultActivity` launch loop. The fixed
APK has the actual class/onCreate and is byte-identical to original AOSP
Provision. Package checks must inspect DEX class definitions, not just manifests.

Incremental packaging must remove verified stale copies of overridden setup
APKs and assert that only K7Provision remains. External installers can add their
own wizard independently. Neither this activity nor CM13's SetupWizard reads
`ro.setupwizard.mode`; that property alone does not implement this path.

This CM13 tree rejects platform-signed APK updates under `/data`, so installing
an app update was not a viable test/recovery path; the corrected ROM was flashed
and first boot verified.
