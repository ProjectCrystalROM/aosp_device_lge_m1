$(call inherit-product, $(SRC_TARGET_DIR)/product/full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

$(call inherit-product, device/lge/m1-common/boot.mk)
$(call inherit-product, vendor/lge/m1/m1-vendor.mk)

# CM13 core/tasks/kernel.mk installs TARGET_PREBUILT_KERNEL exactly once.

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := full_m1
PRODUCT_DEVICE := m1
