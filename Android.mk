LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_PRODUCT),aosp_m1)
include $(LOCAL_PATH)/kernel.mk
include $(call all-makefiles-under,$(LOCAL_PATH))
endif
