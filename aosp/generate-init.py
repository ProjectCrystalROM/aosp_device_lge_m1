#!/usr/bin/env python
"""Derive MS330 init from current AOSP input so upstream fixes are retained."""
from __future__ import print_function
import re
import sys

def replace_once(text, old, new):
    if text.count(old) != 1:
        raise ValueError('AOSP init input drifted; review adaptation: ' + old)
    return text.replace(old, new, 1)

source = open(sys.argv[1]).read()
source = replace_once(source, 'import /init.usb.rc',
    '# MS330 owns simplified USB through /init.m1.rc; do not import generic USB.')
source = replace_once(source, '    group radio cache inet misc audio log\n',
    '    group radio cache inet misc audio sdcard_rw qcom_diag log net_raw\n')
source = replace_once(source,
    '    group audio camera inet net_bt net_bt_admin net_bw_acct drmrpc mediadrm\n',
    '    group audio camera inet net_bt net_bt_admin net_bw_acct drmrpc mediadrm qcom_diag\n')
# First-boot recovery protection. OTA/target-files preservation is a separate gate.
pattern = r'^service flash_recovery [^\n]+\n(?:[ \t]+[^\n]*\n|\n)*'
source, count = re.subn(pattern,
    '# TWRP is the only supported recovery; no automatic recovery replacement.\n\n',
    source, flags=re.MULTILINE)
if count != 1:
    raise ValueError('Review changed AOSP recovery service before generating init')
open(sys.argv[2], 'w').write(source)
