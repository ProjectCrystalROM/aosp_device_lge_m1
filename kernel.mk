# Source-only MS330 kernel integration. Also usable for an isolated kernel build
# by supplying PRODUCT_OUT and TARGET_OUT to this same makefile.
M1_KERNEL_DEVICE_PATH := device/lge/m1
TARGET_KERNEL_SOURCE ?= kernel/lge/m1
TARGET_KERNEL_CONFIG ?= m1_mpcs_us-perf_defconfig
M1_KERNEL_OUT := $(PRODUCT_OUT)/obj/KERNEL_OBJ
M1_KERNEL_CONFIG := $(M1_KERNEL_OUT)/.config
M1_KERNEL_STAMP := $(M1_KERNEL_OUT)/.built
M1_KERNEL_IMAGE := $(M1_KERNEL_OUT)/arch/arm/boot/zImage
M1_KERNEL_CROSS_COMPILE := $(abspath prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-)
M1_KERNEL_MAKE = $(MAKE) -C $(TARGET_KERNEL_SOURCE) O=$(abspath $(M1_KERNEL_OUT)) ARCH=arm CROSS_COMPILE=$(M1_KERNEL_CROSS_COMPILE)

ifeq ($(wildcard $(TARGET_KERNEL_SOURCE)/Makefile),)
$(error MS330 kernel source missing at $(TARGET_KERNEL_SOURCE); no binary fallback is supported)
endif
ifeq ($(wildcard $(TARGET_KERNEL_SOURCE)/arch/arm/configs/$(TARGET_KERNEL_CONFIG)),)
$(error MS330 kernel configuration missing: $(TARGET_KERNEL_CONFIG))
endif

include $(M1_KERNEL_DEVICE_PATH)/kernel-modules.mk
M1_KERNEL_BUILT_MODULES := $(addprefix $(M1_KERNEL_OUT)/,$(M1_KERNEL_MODULE_PATHS))
M1_KERNEL_INSTALLED_MODULES := $(addprefix $(TARGET_OUT)/lib/modules/,$(notdir $(M1_KERNEL_MODULE_PATHS)))

$(M1_KERNEL_CONFIG): $(TARGET_KERNEL_SOURCE)/arch/arm/configs/$(TARGET_KERNEL_CONFIG)
	@mkdir -p $(M1_KERNEL_OUT)
	+$(M1_KERNEL_MAKE) $(TARGET_KERNEL_CONFIG)

# Re-enter Kbuild on each invocation so edits, removed objects and Git release
# identifiers are noticed. Kbuild handles incremental compilation internally.
.PHONY: m1-kernel-check
$(M1_KERNEL_STAMP): m1-kernel-check $(M1_KERNEL_CONFIG) $(M1_KERNEL_OUT)/usr
	+$(M1_KERNEL_MAKE) zImage modules
	@touch $@

$(M1_KERNEL_IMAGE) $(M1_KERNEL_BUILT_MODULES): $(M1_KERNEL_STAMP)
	@test -s $@

$(PRODUCT_OUT)/kernel: $(M1_KERNEL_IMAGE)
	@mkdir -p $(dir $@)
	cp $< $@

define m1-install-kernel-module
$(TARGET_OUT)/lib/modules/$(notdir $(1)): $(M1_KERNEL_OUT)/$(1)
	@mkdir -p $$(dir $$@)
	cp $$< $$@
endef
$(foreach module,$(M1_KERNEL_MODULE_PATHS),$(eval $(call m1-install-kernel-module,$(module))))

# Register generated modules before core/main.mk computes the system image's
# installed-file set. Image and target-files builds therefore depend on them.
ALL_DEFAULT_INSTALLED_MODULES += $(M1_KERNEL_INSTALLED_MODULES)

.PHONY: kernel
kernel: $(PRODUCT_OUT)/kernel $(M1_KERNEL_INSTALLED_MODULES)

.PHONY: m1-kernel-headers-check
$(M1_KERNEL_OUT)/usr: m1-kernel-headers-check $(M1_KERNEL_CONFIG)
	+$(M1_KERNEL_MAKE) headers_install
