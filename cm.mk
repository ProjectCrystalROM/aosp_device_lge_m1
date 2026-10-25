# Standard K7 product: the hardware-qualified integration profile.
$(call inherit-product, device/lge/m1/cm_m1_radio.mk)
PRODUCT_NAME := cm_m1
PRODUCT_DEVICE := m1
PRODUCT_RELEASE_NAME := m1
# Retain the qualified core-init rild net_raw group; no diagnostic USB override.
PRODUCT_COPY_FILES += device/lge/m1/ril/init.m1.core.rc:root/init.rc

# Use standard CM USB/ADB defaults; no diagnostic property overrides.
