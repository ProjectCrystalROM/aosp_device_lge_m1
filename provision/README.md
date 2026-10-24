# K7 first boot without SetupWizard

Owner requests direct launcher access because microG registration is disabled
by default and must be enabled before account login; SetupWizard blocks access
to those settings. K7Provision replaces Provision/CyanogenSetupWizard/SetupWizard
only in the focused K7 radio products, using standard package override rules.
The manifest and DefaultActivity.java are exact copies of CM13/AOSP Provision.
On first HOME launch it marks DEVICE_PROVISIONED and USER_SETUP_COMPLETE,
disables its own activity, then finishes so the launcher can open. It does not
configure accounts, enable microG registration or grant extra app permissions.

No global vendor/cm configuration or framework patch is required. Keep managed
work-profile provisioning separate. A later external GApps/microG installer
can introduce its own wizard; that is outside this ROM package selection.

Future incremental packaging must remove stale output copies of overridden
wizard APKs, and assert target-files contain K7Provision but no SetupWizard or
CyanogenSetupWizard. Compile and package checks precede owner cold-boot testing.

Correction: keep original proguard.flags and its Android.mk reference. Without
them Jack strips DefaultActivity and produces a 140-byte empty DEX. Package
audits must verify the class definition/onCreate, not just the manifest.
