# Modules enabled by the hardware-qualified MS330 configuration.
M1_KERNEL_MODULE_PATHS := \
    arch/arm/oprofile/oprofile.ko \
    block/test-iosched.ko \
    crypto/ansi_cprng.ko \
    drivers/input/evbug.ko \
    drivers/input/misc/gpio_axis.ko \
    drivers/input/misc/gpio_event.ko \
    drivers/input/misc/gpio_input.ko \
    drivers/input/misc/gpio_matrix.ko \
    drivers/input/misc/gpio_output.ko \
    drivers/media/radio/radio-iris-transport.ko \
    drivers/mmc/card/mmc_block_test.ko \
    drivers/mmc/card/mmc_test.ko \
    drivers/platform/msm/msm_bus/msm-buspm-dev.ko \
    drivers/spi/spidev.ko \
    drivers/usb/host/ice40-hcd.ko \
    net/ipv4/tcp_htcp.ko \
    net/ipv4/tcp_westwood.ko
