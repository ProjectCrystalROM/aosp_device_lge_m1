LOCAL_PATH := $(call my-dir)

# include the non-open-source counterpart to this file
-include vendor/lge/m1/AndroidBoardVendor.mk

# CAF userspace needs this kernel's exported UAPI even when boot uses a prebuilt.
# Keep TARGET_KERNEL_SOURCE empty so CM does not build/replace the kernel image.
ifeq ($(strip $(TARGET_KERNEL_SOURCE)),)
m1_kernel_headers_source := kernel/lge/m1
m1_kernel_headers_out := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
m1_kernel_headers_inputs := $(shell find $(m1_kernel_headers_source)/include $(m1_kernel_headers_source)/arch/arm/include $(m1_kernel_headers_source)/scripts -type f)
$(m1_kernel_headers_out)/usr: PRIVATE_M1_HEADERS_SOURCE := $(m1_kernel_headers_source)
$(m1_kernel_headers_out)/usr: PRIVATE_M1_HEADERS_OUT := $(abspath $(m1_kernel_headers_out))
$(m1_kernel_headers_out)/usr: $(m1_kernel_headers_inputs) $(m1_kernel_headers_source)/Makefile
	$(hide) mkdir -p $(PRIVATE_M1_HEADERS_OUT)
	+$(hide) $(MAKE) -C $(PRIVATE_M1_HEADERS_SOURCE) O=$(PRIVATE_M1_HEADERS_OUT) ARCH=arm headers_install
	$(hide) touch $@
endif

# Review the fully evaluated product graph before packaging a bring-up image.
.PHONY: k7-cm12-config
k7-cm12-config:
	@mkdir -p $(PRODUCT_OUT)
	@printf '%s\n' $(PRODUCT_COPY_FILES) > $(PRODUCT_OUT)/k7-product-copies.txt
	@printf '%s\n' $(sort $(product_MODULES)) > $(PRODUCT_OUT)/k7-product-packages.txt
	@printf '%s\n' $(sort $(filter-out $(ALL_MODULES),$(product_MODULES))) > $(PRODUCT_OUT)/k7-missing-packages.txt

# Own init.rc as a real module, preserving CM12's platform boot graph.
include $(CLEAR_VARS)
LOCAL_MODULE := init.rc
LOCAL_SRC_FILES := ril/init.m1.core.rc
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)
include $(BUILD_PREBUILT)
