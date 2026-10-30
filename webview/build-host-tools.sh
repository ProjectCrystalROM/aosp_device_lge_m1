#!/bin/bash
# Pin generated-source semantics; gperf3.2 emits annotations M95 also injects.
set -euo pipefail
here=$(cd -- "$(dirname -- "$0")" && pwd)
workspace=$(cd "$here/../../../../.." && pwd)
prefix="$workspace/webview-m95/host-tools"
mkdir -p "$prefix/src"
archive="$prefix/src/gperf-3.1.tar.gz"
if [[ ! -f "$archive" ]]; then
 curl -fLsS --retry 2 https://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz -o "$archive"
fi
printf '%s  %s\n' 588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2 "$archive" | sha256sum -c -
if [[ -x "$prefix/bin/gperf" ]] && [[ $("$prefix/bin/gperf" --version | head -n 1) == 'GNU gperf 3.1' ]]; then exit 0; fi
tar -xzf "$archive" -C "$prefix/src"
cd "$prefix/src/gperf-3.1"
./configure --prefix="$prefix"
make -j4
make install
