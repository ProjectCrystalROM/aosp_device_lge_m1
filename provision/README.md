# AOSP first boot without a SetupWizard

K7Provision initializes DEVICE_PROVISIONED and USER_SETUP_COMPLETE, disables its
own DefaultActivity and exits so the launcher is available immediately. microG
and account setup take place afterward. It is selected by aosp_m1 and replaces
the stock Provision package; no full SetupWizard is shipped.

Keep the ProGuard keep rule and LOCAL_PROGUARD_FLAG_FILES reference. Earlier
bringup exposed an empty-DEX/launch-loop failure when that rule was missing.
Validate the actual class/onCreate in the built APK, not just its manifest.

Do not copy old wizard packages back into system staging. Existing user setup
state is not automatically erased. This AOSP implementation sets the two Android
setup flags; historical CyanogenMod setup behavior is not the current product.
