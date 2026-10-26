# Existing AOSP no-screen first-boot provisioning for this K7 product only.
LOCAL_PATH := $(call my-dir)
ifneq ($(filter cm_m1 cm_m1_radio cm_m1_radio_noselinux,$(TARGET_PRODUCT)),)
ifeq ($(TARGET_DEVICE),m1)
include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $(call all-java-files-under, src)
LOCAL_PACKAGE_NAME := K7Provision
LOCAL_CERTIFICATE := platform
LOCAL_PROGUARD_FLAG_FILES := proguard.flags
LOCAL_OVERRIDES_PACKAGES := Provision CyanogenSetupWizard SetupWizard
include $(BUILD_PACKAGE)
endif
endif
