# Focused compatibility helpers for the tested msm8916 CAF HALs.
BOARD_USES_QCOM_HARDWARE := true
QCOM_BOARD_PLATFORMS := msm8909
TARGET_USES_QCOM_BSP := true
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
TARGET_PROVIDES_LIBLIGHT := true
M1_CAF_PATH_qcom-audio := hardware/qcom/audio-caf/msm8916
M1_CAF_PATH_qcom-display := hardware/qcom/display-caf/msm8916
M1_CAF_PATH_qcom-media := hardware/qcom/media-caf/msm8916
project-path-for = $(strip $(foreach project,$(1),$(M1_CAF_PATH_$(project))))
is-board-platform-in-list = $(if $(filter $(TARGET_BOARD_PLATFORM),$(1)),true)
is-vendor-board-platform = $(if $(and $(filter QCOM,$(1)),$(filter msm8909,$(TARGET_BOARD_PLATFORM))),true)
is-chipset-in-board-platform = $(if $(filter $(1) $(1)_%,$(TARGET_BOARD_PLATFORM)),true)
is-platform-sdk-version-at-least = $(if $(filter 1,$(shell echo "$$(( $(PLATFORM_SDK_VERSION) >= $(1) ))")),true)
BOARD_TARGET_GLOBAL_CFLAGS := -DQCOM_HARDWARE -DQCOM_BSP
BOARD_TARGET_GLOBAL_CPPFLAGS := -DQCOM_HARDWARE -DQCOM_BSP
TARGET_USES_EXTERNAL_QCOM_DISPLAY := true
