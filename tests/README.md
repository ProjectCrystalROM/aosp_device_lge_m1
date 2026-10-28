# AOSP MS330 native compatibility regression

Build m1_aosp_compat_test explicitly; this tests-tagged executable is not added
to PRODUCT_PACKAGES. Uses actual source-built AOSP libbinder/libc, without
substitute platform providers. Exercises high-bit 64-bit Parcel reads through
LG and standard exports, short-buffer error behavior, checked pread, GNU
strerror return semantics, and DSO-specific atfork handler removal plus ordering.

Local QEMU execution ends via _exit after assertions to avoid Parcel destruction,
which initializes Android Binder IPCThreadState and requires /dev/binder.
Therefore this is serialization/ABI and libc validation, not Binder IPC or
Parcel destruction qualification. Explicit __cxa_finalize tests DSO cleanup
before that exit. No phone operation or root integration is involved.
