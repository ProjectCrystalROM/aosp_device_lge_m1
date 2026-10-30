LOCAL_PATH := $(call my-dir)
ifeq ($(TARGET_PRODUCT),aosp_m1)
include $(CLEAR_VARS)
LOCAL_MODULE := bootanimation.zip
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT)/media
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE): PRIVATE_CRYSTAL_ZIP_BUILDER := $(LOCAL_PATH)/build-zip.py
$(LOCAL_BUILT_MODULE): $(LOCAL_PATH)/bootanimation.png $(LOCAL_PATH)/build-zip.py
	@mkdir -p $(dir $@)
	$(hide) python $(PRIVATE_CRYSTAL_ZIP_BUILDER) $< $@
endif
