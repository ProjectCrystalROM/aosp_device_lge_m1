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
