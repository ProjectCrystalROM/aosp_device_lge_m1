# AOSP MS330 bootstrap. Known board geometry; HAL glue/policy port follows.
include device/lge/m1-common/BoardConfigBoot.mk
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := cortex-a7
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
TARGET_BOARD_PLATFORM := msm8909
TARGET_NO_BOOTLOADER := true
TARGET_KERNEL_SOURCE := kernel/lge/m1
TARGET_KERNEL_CONFIG := m1_mpcs_us-perf_defconfig
TARGET_KERNEL_ARCH := arm
USE_CAMERA_STUB := false
BOARD_HAS_NO_SELECT_BUTTON := true
TARGET_RECOVERY_FSTAB := device/lge/m1/recovery.fstab
# First-boot diagnostics retain SELinux policy loading and AVC logging.
ifneq ($(filter eng userdebug,$(TARGET_BUILD_VARIANT))$(filter true,$(M1_SELINUX_PERMISSIVE)),)
BOARD_KERNEL_CMDLINE += security=selinux enforcing=0 androidboot.selinux=permissive
else
BOARD_KERNEL_CMDLINE += security=selinux enforcing=1 androidboot.selinux=enforcing
endif
include device/lge/m1-common/ril/BoardConfigRadio.mk
include device/lge/m1-common/BoardConfigWireless.mk
include device/lge/msm8909-common/board/qcom-audio.mk
TARGET_USES_ION := true
TARGET_USES_C2D_COMPOSITION := true
USE_OPENGL_RENDERER := true
BOARD_LIGHTS_VARIANT := qpnp
BOARD_NEEDS_LGE_RIL_SYMBOLS := true
BOARD_GPS_XTRA_THREE_CALLBACKS := true
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/
# Device AndroidBoard.mk generates init from current AOSP core init.
# Recovery-preserving OTA packaging remains a separate build-system gate.
TARGET_PROVIDES_INIT_RC := true
TARGET_PRESERVE_INSTALLED_RECOVERY := true

include device/lge/m1/caf.mk

# Qualified Qualcomm vendor policy, compiled against AOSP's platform policy.
include device/qcom/sepolicy/sepolicy.mk

# Build the standalone API21+ WebView through the host GN/Ninja worker.
M1_SOURCE_WEBVIEW_M95 := true
