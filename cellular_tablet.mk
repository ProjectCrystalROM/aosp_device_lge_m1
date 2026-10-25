# Keep the AOSP telephony product's cellular/SMS services without its Dialer.
# Mirrors full_base_telephony.mk + aosp_base_telephony.mk, omitting only Dialer
# from build/target/product/telephony.mk. CM telephony.mk still supplies APNs,
# messaging, SIM toolkit and cell-broadcast support via common_full_phone.mk.
PRODUCT_PROPERTY_OVERRIDES += keyguard.no_require_sim=true
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)
PRODUCT_PACKAGES += CarrierConfig CallLogBackup InCallUI Mms rild messaging
# Retain normal phone wording/layout; only voice/SMS capabilities change.
PRODUCT_CHARACTERISTICS := default
PRODUCT_PACKAGE_OVERLAYS += device/lge/m1/overlay-tablet
