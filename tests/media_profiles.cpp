#include <media/MediaProfiles.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#define CHECK_TEST(x) do { if (!(x)) { fprintf(stderr, "FAIL: %s\n", #x); abort(); } } while (0)
int main() {
    android::MediaProfiles* profiles = android::MediaProfiles::getInstance();
    CHECK_TEST(profiles != NULL);
    CHECK_TEST(profiles->getAudioEncoders().size() == 3);
    for (int camera = 0; camera < 2; ++camera) {
        CHECK_TEST(profiles->hasCamcorderProfile(camera, android::CAMCORDER_QUALITY_720P));
        CHECK_TEST(profiles->getCamcorderProfileParamByName("aud.codec", camera,
                android::CAMCORDER_QUALITY_720P) == android::AUDIO_ENCODER_AAC);
    }
    puts("PASS: actual ARM32 MediaProfiles parser loads both cameras and AAC recording without aborting");
    fflush(stdout);
    _exit(0);
}
