# Explicit boot-only inheritance; legacy HAL board fragments are not implicit.
include device/lge/msm8909-common/BoardConfigBoot.mk
include device/lge/m1-common/BoardConfigBoot.mk

# The baseline products retain their audited prebuilt kernel.
# CM13 kernel.mk uses directory existence to choose a source build; an explicitly
# empty source prevents the populated kernel repository from silently changing it.
TARGET_KERNEL_SOURCE :=
TARGET_PREBUILT_KERNEL := device/lge/m1/kernel
TARGET_KERNEL_ARCH := arm
USE_CAMERA_STUB := false
BOARD_HAS_NO_SELECT_BUTTON := true

# Paths and filesystem types verified against stock boot/recovery and GPT,
# following the initial TWRP-based repair. This is CM/fs_mgr syntax.
TARGET_RECOVERY_FSTAB := device/lge/m1/recovery.fstab

# Qualified hardware integration for the standard product and legacy profiles.
ifneq ($(filter cm_m1 cm_m1_radio cm_m1_radio_noselinux,$(TARGET_PRODUCT)),)
include device/lge/m1-common/ril/BoardConfigRadio.mk
include device/lge/m1-common/BoardConfigWireless.mk
# Existing MSM8909 display fragment uses the C2D path with the retained GPU blobs.
TARGET_USES_C2D_COMPOSITION := true
USE_OPENGL_RENDERER := true
# CM's QPNP lights HAL uses the K7 stock LCD backlight sysfs path.
BOARD_LIGHTS_VARIANT := qpnp
# Existing CM12 LG Binder export; no radio shim.
BOARD_NEEDS_LGE_RIL_SYMBOLS := true
BOARD_GPS_XTRA_THREE_CALLBACKS := true
# Enable the pinned Qualcomm audio HAL/policy for the experimental products.
include device/lge/msm8909-common/board/qcom-audio.mk
endif

# Standard product is always enforcing.
ifeq ($(TARGET_PRODUCT),cm_m1)
BOARD_KERNEL_CMDLINE += security=selinux enforcing=1 androidboot.selinux=enforcing
TARGET_KERNEL_SOURCE := kernel/lge/m1
TARGET_KERNEL_CONFIG := m1_mpcs_us-perf_defconfig
TARGET_PREBUILT_KERNEL :=
endif

# Legacy diagnostic selectors.
ifeq ($(TARGET_PRODUCT),cm_m1_radio_noselinux)
ifeq ($(K7_SELINUX_PERMISSIVE),true)
include device/lge/m1-common/ril/BoardConfigPermissive.mk
else
include device/lge/m1-common/ril/BoardConfigNoSELinux.mk
endif
# Build the matching LGMS330 kernel only for the diagnostic product.
# Its stock DT image and no-SELinux boot arguments remain separately selected.
TARGET_KERNEL_SOURCE := kernel/lge/m1
TARGET_KERNEL_CONFIG := m1_mpcs_us-perf_defconfig
TARGET_PREBUILT_KERNEL :=
endif

# Custom CM12 core init adds the required rild net_raw group.
TARGET_PROVIDES_INIT_RC := true
