# Explicit first-boot diagnostic product; the normal radio product keeps SELinux.
ifeq ($(filter userdebug eng,$(TARGET_BUILD_VARIANT)),)
$(error cm_m1_radio_noselinux requires userdebug or eng; CM user init cannot skip policy loading)
endif
$(call inherit-product, device/lge/m1/cm_m1_radio.mk)
PRODUCT_NAME := cm_m1_radio_noselinux

# A UI-less diagnostic boot cannot authorize a new ADB host. Start the
# supported adb-only gadget with authentication disabled for this product.
ADDITIONAL_DEFAULT_PROPERTIES := $(filter-out ro.adb.secure=1,$(ADDITIONAL_DEFAULT_PROPERTIES)) ro.adb.secure=0
PRODUCT_DEFAULT_PROPERTY_OVERRIDES := persist.sys.usb.config=adb $(PRODUCT_DEFAULT_PROPERTY_OVERRIDES)
