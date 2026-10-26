# Standard K7 product: the hardware-qualified integration profile.
$(call inherit-product, device/lge/m1/cm_m1_radio.mk)
PRODUCT_NAME := cm_m1
PRODUCT_DEVICE := m1
PRODUCT_RELEASE_NAME := m1
# Retain the qualified core-init rild net_raw group; no diagnostic USB override.

# Use standard CM USB/ADB defaults; no diagnostic property overrides.
