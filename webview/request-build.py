#!/usr/bin/env python
"""Python 2/3 client for the fixed-purpose host Chromium build worker."""
from __future__ import print_function
import os
import socket
import sys

workspace = os.path.realpath(os.path.join(os.path.dirname(__file__), "../../../../.."))
endpoint = os.path.join(workspace, "webview-m95", "build.sock")
s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
try:
    s.connect(endpoint)
except socket.error:
    sys.exit("M95 host worker unavailable. Start the ROM build through "
             "device/lge/m1/webview/with-host-builder.py on the WSL host.")
s.sendall(b"build-m95\n")
s.shutdown(socket.SHUT_WR)
stream = s.makefile("rb")
status = None
for line in stream:
    if line.startswith(b"M95-EXIT "):
        status = int(line.split()[1])
    else:
        sys.stdout.write(line.decode("utf-8", "replace"))
        sys.stdout.flush()
s.close()
sys.exit(status if status is not None else 1)
