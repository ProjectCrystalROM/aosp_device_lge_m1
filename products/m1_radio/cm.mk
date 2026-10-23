# CM13 derives CM_BUILD=m1_radio from lunch and searches */m1_radio/cm.mk.
# Keep TARGET_DEVICE=m1; the real board/kernel configuration stays in m1.
$(call inherit-product, device/lge/m1/cm_m1_radio.mk)
