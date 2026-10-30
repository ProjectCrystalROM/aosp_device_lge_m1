#!/bin/bash
# One host command: the Android Make graph invokes the M95 source builder.
set -euo pipefail
here=$(cd -- "$(dirname -- "$0")" && pwd)
workspace=$(cd "$here/../../../../.." && pwd)
python3 "$workspace/aosp511/vendor/lge/m1/microg/stage.py" --cache "$workspace/audit/microg/packages" --extract-arm-jni
python3 "$workspace/aosp511/vendor/lge/m1/crystalgram/stage.py"
# Advance these stages only after the operator validates the previous image.
profile=${M1_BUILD_PROFILE:-user-release}
case "$profile" in
 user-permissive) variant=user; output=out-trusty-ms330-user-permissive; permissive=true; diagnostic=true ;;
 user-enforcing) variant=user; output=out-trusty-ms330-user-enforcing; permissive=false; diagnostic=true ;;
 user-release) variant=user; output=out-trusty-ms330-user; permissive=false; diagnostic=false ;;
 userdebug) variant=userdebug; output=out-trusty-ms330-m95; permissive=true; diagnostic=true ;;
 *) echo "Unknown M1_BUILD_PROFILE: $profile" >&2; exit 1 ;;
esac
if [[ $# == 0 ]]; then set -- droid otapackage k7-cm12-config; fi
exec python3 "$here/with-host-builder.py" -- \
 sudo -n chroot /srv/chroots/trusty /usr/bin/env -i \
 HOME=/home/airi USER=airi LOGNAME=airi LANG=C LC_ALL=C \
 M1_VARIANT="$variant" M1_OUT="$output" M1_PERMISSIVE="$permissive" M1_DIAGNOSTIC="$diagnostic" \
 PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
 /bin/su -s /bin/bash airi -c '
 set -e
 cd /work/LG_K7/aosp511
 export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
 export PATH="$JAVA_HOME/bin:$PATH"
 export OUT_DIR="$M1_OUT"
 source build/envsetup.sh
 lunch "aosp_m1-$M1_VARIANT"
 make -k -j8 M1_SELINUX_PERMISSIVE="$M1_PERMISSIVE" M1_DIAGNOSTIC_USB="$M1_DIAGNOSTIC" "$@"
 ' build-rom "$@"
