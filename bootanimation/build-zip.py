#!/usr/bin/env python
"""Build an uncompressed, single-frame Android boot animation without editing PNG."""
from __future__ import print_function
import struct
import sys
from zipfile import ZipFile, ZipInfo, ZIP_STORED
with open(sys.argv[1], 'rb') as stream:
    png = stream.read()
assert png[:8] == b'\x89PNG\r\n\x1a\n'
assert struct.unpack('>II', png[16:24]) == (481, 854)
with ZipFile(sys.argv[2], 'w', compression=ZIP_STORED) as archive:
    for name, data in [('desc.txt', b'480 854 1\np 0 0 part0\n'),
                       ('part0/00000.png', png)]:
        entry = ZipInfo(name, date_time=(2026, 10, 30, 0, 0, 0))
        entry.compress_type = ZIP_STORED
        entry.external_attr = 0o100644 << 16
        archive.writestr(entry, data)
