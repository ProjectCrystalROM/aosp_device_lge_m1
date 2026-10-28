LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := m1_aosp_compat_test
LOCAL_MODULE_TAGS := tests
LOCAL_SRC_FILES := native_compat.cpp
LOCAL_CFLAGS := -DNEEDS_LGE_RIL_SYMBOLS -Wall -Werror
LOCAL_SHARED_LIBRARIES := libbinder libutils libc libdl
LOCAL_MODULE_PATH := $(TARGET_OUT_DATA_NATIVE_TESTS)/$(LOCAL_MODULE)
include $(BUILD_EXECUTABLE)
