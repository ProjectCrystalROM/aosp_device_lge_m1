#!/bin/bash
# Fetch only the pinned M95 revision and its DEPS; never repo-sync the ROM.
set -euo pipefail
here=$(cd -- "$(dirname -- "$0")" && pwd)
workspace=$(cd "$here/../../../../.." && pwd)
checkout="$workspace/webview-m95"
mkdir -p "$checkout"
if [[ ! -d "$checkout/depot_tools/.git" ]]; then
 git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git "$checkout/depot_tools"
fi
# Freeze tooling as well as Chromium; avoid an implicit depot_tools update.
git -C "$checkout/depot_tools" fetch --depth 1 origin aebf6247c9f293c8461e22a6145649bc3d797b35
git -C "$checkout/depot_tools" checkout --detach aebf6247c9f293c8461e22a6145649bc3d797b35
if [[ ! -d "$checkout/src/.git" ]]; then
 git clone --depth 1 --branch 95.0.4638.74 https://chromium.googlesource.com/chromium/src.git "$checkout/src"
fi
[[ -f "$checkout/src/chrome/VERSION" ]] || { echo 'Incomplete source checkout; finish the clone first.' >&2; exit 1; }
[[ $(git -C "$checkout/src" rev-parse HEAD) == $(git -C "$checkout/src" rev-parse '95.0.4638.74^{commit}') ]]
export DEPOT_TOOLS_UPDATE=0
export DEPOT_TOOLS_BOOTSTRAP_PYTHON3=0
export GCLIENT_PY3=1
"$checkout/depot_tools/cipd" ensure -root "$checkout/python-2021" -ensure-file "$here/python.ensure"
export PATH="$checkout/python-2021/python/bin:$checkout/python-2021/python3/bin:$checkout/depot_tools:$PATH"
cd "$checkout"
cat > .gclient <<'EOF'
solutions = [{
  "name": "src",
  "url": "https://chromium.googlesource.com/chromium/src.git",
  "managed": False,
  "custom_deps": {},
  "custom_vars": {
    "checkout_pgo_profiles": False,
    # Optional developer auditor; its historical prebuilt is no longer available.
    "checkout_traffic_annotation_tools": False,
  },
}]
target_os = ["android"]
EOF
gclient sync --no-history --nohooks -j8
gclient runhooks
bash "$here/build-host-tools.sh"
