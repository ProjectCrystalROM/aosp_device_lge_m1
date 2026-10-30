# GN/Ninja owns Chromium compilation; Android Make owns ROM installation/signing.
LOCAL_PATH := $(call my-dir)
ifeq ($(M1_SOURCE_WEBVIEW_M95),true)
m1_webview_generated_apk := $(PRODUCT_OUT)/obj/M95_WEBVIEW/SystemWebView.apk
.PHONY: m1-webview-source-check
$(m1_webview_generated_apk): PRIVATE_M95_CLIENT := $(LOCAL_PATH)/request-build.py
$(m1_webview_generated_apk): PRIVATE_M95_ARTIFACT := ../webview-m95/artifacts/SystemWebView.apk
$(m1_webview_generated_apk): m1-webview-source-check $(LOCAL_PATH)/args.gn $(LOCAL_PATH)/request-build.py
	@echo "Build Chromium M95 WebView from source"
	$(hide) python $(PRIVATE_M95_CLIENT)
	@mkdir -p $(dir $@)
	$(hide) cmp -s $(PRIVATE_M95_ARTIFACT) $@ || cp $(PRIVATE_M95_ARTIFACT) $@

include $(CLEAR_VARS)
LOCAL_MODULE := webview
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_MODULE_TAGS := optional
LOCAL_PREBUILT_MODULE_FILE := $(m1_webview_generated_apk)
LOCAL_CERTIFICATE := $(DEFAULT_SYSTEM_DEV_CERTIFICATE)
LOCAL_DEX_PREOPT := false
LOCAL_MULTILIB := 32
LOCAL_PREBUILT_JNI_LIBS := \
    @lib/armeabi-v7a/libwebviewchromium.so \
    @lib/armeabi-v7a/libcrashpad_handler_trampoline.so
LOCAL_REQUIRED_MODULES := libwebviewchromium_loader libwebviewchromium_plat_support
include $(BUILD_PREBUILT)
endif
