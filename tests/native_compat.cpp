#include <binder/Parcel.h>
#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

#undef assert
#define assert(condition) do { if (!(condition)) { fprintf(stderr, "FAIL line %d: %s\n", __LINE__, #condition); abort(); } } while (0)

extern "C" ssize_t __pread_chk(int, void*, size_t, off_t, size_t);
extern "C" char* __gnu_strerror_r(int, char*, size_t);
extern "C" int __register_atfork(void (*)(), void (*)(), void (*)(), void*);
extern "C" void __cxa_finalize(void*);

static char calls[16];
static size_t call_count;
static void removed_prepare() { calls[call_count++] = 'a'; }
static void removed_parent() { calls[call_count++] = 'A'; }
static void live_prepare() { calls[call_count++] = 'b'; }
static void live_parent() { calls[call_count++] = 'B'; }
static void public_prepare() { calls[call_count++] = 'c'; }
static void public_parent() { calls[call_count++] = 'C'; }

int main() {
    // These call the actual LG ABI exports in the freshly linked libbinder.
    android::Parcel parcel;
    const uint64_t expected = UINT64_C(0xfedcba9876543210);
    assert(parcel.writeInt64(static_cast<int64_t>(expected)) == android::NO_ERROR);
    parcel.setDataPosition(0);
    uint64_t value = 0;
    assert(parcel.readuInt64(&value) == android::NO_ERROR && value == expected);
    parcel.setDataPosition(0);
    assert(static_cast<uint64_t>(parcel.readInt64()) == expected);
    parcel.setDataPosition(0);
    int64_t signed_value = 0;
    assert(parcel.readInt64(&signed_value) == android::NO_ERROR);
    assert(static_cast<uint64_t>(signed_value) == expected);

    android::Parcel short_parcel;
    assert(short_parcel.writeInt32(42) == android::NO_ERROR);
    short_parcel.setDataPosition(0);
    value = expected;
    assert(short_parcel.readuInt64(&value) != android::NO_ERROR);
    assert(value == expected); // Failed pointer reads leave the caller value unchanged.

    char path[] = "/tmp/m1-aosp-compat-XXXXXX";
    int fd = mkstemp(path);
    assert(fd >= 0);
    unlink(path);
    assert(write(fd, "abcdef", 6) == 6);
    char buffer[4] = {};
    assert(__pread_chk(fd, buffer, 3, 2, sizeof(buffer)) == 3);
    assert(memcmp(buffer, "cde", 3) == 0);
    close(fd);
    char error[128];
    assert(strcmp(__gnu_strerror_r(EINVAL, error, sizeof(error)), strerror(EINVAL)) == 0);

    // Finalizing one DSO must remove only its handlers, retaining POSIX order
    // for surviving registrations and legacy public pthread_atfork users.
    int removed_dso, live_dso;
    assert(__register_atfork(removed_prepare, removed_parent, NULL, &removed_dso) == 0);
    assert(__register_atfork(live_prepare, live_parent, NULL, &live_dso) == 0);
    assert(pthread_atfork(public_prepare, public_parent, NULL) == 0);
    __cxa_finalize(&removed_dso);
    pid_t child = fork();
    assert(child >= 0);
    if (child == 0) _exit(0);
    int status;
    assert(waitpid(child, &status, 0) == child && WIFEXITED(status) && WEXITSTATUS(status) == 0);
    assert(call_count == 4 && memcmp(calls, "cbBC", 4) == 0);
    __cxa_finalize(&live_dso);
    puts("PASS: actual ARM32 Parcel LG exports, checked pread, GNU strerror and DSO atfork cleanup");
    fflush(stdout);
    // Local QEMU has no Android Binder driver. Avoid Parcel destruction, which
    // initializes IPCThreadState; serialization and explicit libc cleanup above
    // still execute against production libraries without substituting them.
    _exit(0);
}
