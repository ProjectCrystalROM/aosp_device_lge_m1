# Experimental radio integration product. The boot-only cm_m1 remains separate.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, device/common/gps/gps_us_supl.mk)
$(call inherit-product, device/lge/m1-common/boot.mk)
$(call inherit-product, device/lge/m1-common/wireless.mk)
$(call inherit-product, device/lge/m1-common/ril/radio.mk)
$(call inherit-product, vendor/lge/m1/radio-stock/m1-radio-vendor.mk)

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_RELEASE_NAME := m1
PRODUCT_DEVICE := m1
PRODUCT_NAME := cm_m1_radio
PRODUCT_BRAND := lge
PRODUCT_MODEL := m1
PRODUCT_MANUFACTURER := lge

# The K7 has no physical navigation keys. Keep this radio/diagnostic fix
# isolated from the baseline cm_m1 product.
PRODUCT_PACKAGE_OVERLAYS += device/lge/m1/overlay-radio

# Experimental display bring-up: pinned CAF modules use the exported K7 UAPI.
PRODUCT_PACKAGES += gralloc.msm8909 hwcomposer.msm8909 copybit.msm8909 memtrack.msm8909

# Source-built backlight control for the K7's QPNP sysfs interface.
PRODUCT_PACKAGES += lights.msm8909

# Owner-tested standalone WebView; replaces the old webview package.
PRODUCT_PACKAGES += K7WebView

# The three routing files are byte-identical to the archived stock K7 system.
PRODUCT_PACKAGES += \
    audio.primary.msm8909 \
    libaudiopolicymanager \
    audio.a2dp.default \
    audio.r_submix.default \
    audio.usb.default

# K7 recording profiles and the existing Qualcomm AVC encoder; keep software
# playback includes and avoid inheriting unrelated legacy HALs/services.
# The primary audio HAL and routing now use the K7/CAF selection above.
PRODUCT_COPY_FILES += \
    device/lge/m1-common/configs/media_profiles.xml:system/etc/media_profiles.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
    device/lge/m1-common/configs/media_codecs_recording.xml:system/etc/media_codecs.xml \
    device/lge/m1-common/audio/audio_policy.conf:system/etc/audio_policy.conf \
    device/lge/m1-common/audio/mixer_paths.xml:system/etc/mixer_paths.xml \
    device/lge/m1-common/audio/audio_platform_info.xml:system/etc/audio_platform_info.xml

# Reach the launcher before microG registration/account setup.
PRODUCT_PACKAGES += K7Provision

# Upstream microG Services and Companion, with original release signatures.
PRODUCT_PACKAGES += GmsCore Phonesky
