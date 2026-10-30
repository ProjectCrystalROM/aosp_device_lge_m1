#!/usr/bin/env python3
"""Run a ROM build with a same-user, fixed-purpose M95 host build worker.

Only the literal build-m95 request is accepted; no shell command or path is
accepted from clients. The socket is private and exists only during this build.
"""
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import socket
import struct
import subprocess
import threading
import zipfile

HERE = Path(__file__).resolve().parent
WORKSPACE = HERE.parents[4]
CHROMIUM = WORKSPACE / 'webview-m95'
SRC = CHROMIUM / 'src'
OUT = SRC / 'out' / 'MS330'
ARTIFACTS = CHROMIUM / 'artifacts'


def build(log):
    env = os.environ.copy()
    env['DEPOT_TOOLS_UPDATE'] = '0'
    env['DEPOT_TOOLS_BOOTSTRAP_PYTHON3'] = '0'
    env['GCLIENT_PY3'] = '1'
    env['PATH'] = ':'.join(str(CHROMIUM / part) for part in
                           ['host-tools/bin', 'python-2021/python/bin', 'python-2021/python3/bin', 'depot_tools']) + ':' + env['PATH']
    gperf_version = subprocess.check_output(['gperf', '--version'], env=env, text=True).splitlines()[0]
    if gperf_version != 'GNU gperf 3.1':
        raise RuntimeError('M95 requires pinned GNU gperf 3.1; run build-host-tools.sh')
    pinned = subprocess.check_output(['git', 'rev-parse', '95.0.4638.74^{commit}'], cwd=SRC).strip()
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=SRC).strip()
    if head != pinned:
        raise RuntimeError('Chromium HEAD differs from pinned 95.0.4638.74')
    OUT.mkdir(parents=True, exist_ok=True)
    args = (HERE / 'args.gn').read_bytes()
    if not (OUT / 'args.gn').exists() or (OUT / 'args.gn').read_bytes() != args:
        (OUT / 'args.gn').write_bytes(args)
    for command in ([str(SRC / 'buildtools/linux64/gn'), 'gen', str(OUT)],
                    ['ninja', '-C', str(OUT), '-j8', 'system_webview_apk']):
        proc = subprocess.Popen(command, cwd=SRC, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        for line in proc.stdout:
            log(line)
        if proc.wait():
            raise RuntimeError('M95 compilation failed: ' + command[0])
    apk = OUT / 'apks/SystemWebView.apk'
    with zipfile.ZipFile(apk) as z:
        libs = sorted(n for n in z.namelist() if n.endswith('.so'))
        if libs != ['lib/armeabi-v7a/libcrashpad_handler_trampoline.so',
                    'lib/armeabi-v7a/libwebviewchromium.so']:
            raise RuntimeError('Review JNI packaging before integration: ' + repr(libs))
        if z.testzip() is not None:
            raise RuntimeError('Corrupt generated WebView APK')
    ARTIFACTS.mkdir(exist_ok=True)
    data = apk.read_bytes()
    dest = ARTIFACTS / apk.name
    if not dest.exists() or dest.read_bytes() != data:
        tmp = dest.with_suffix('.apk.tmp')
        tmp.write_bytes(data)
        tmp.replace(dest)
    (ARTIFACTS / 'provenance.json').write_text(json.dumps({
        'chromium_commit': head.decode(), 'version': '95.0.4638.74',
        'args': args.decode(), 'apk_sha256': hashlib.sha256(data).hexdigest(),
        'depot_tools_commit': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=CHROMIUM/'depot_tools').decode().strip(),
    }, indent=2) + '\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--build-only', action='store_true')
    parser.add_argument('command', nargs=argparse.REMAINDER)
    opt = parser.parse_args()
    CHROMIUM.mkdir(exist_ok=True)
    with (CHROMIUM / 'build.lock').open('w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        if opt.build_only:
            build(lambda line: os.write(1, line))
            return 0
        command = opt.command
        if command and command[0] == '--':
            command = command[1:]
        if not command:
            parser.error('Pass the ROM build command after --, or use --build-only')
        endpoint = CHROMIUM / 'build.sock'
        if endpoint.exists():
            endpoint.unlink()
        server = socket.socket(socket.AF_UNIX)
        server.bind(str(endpoint))
        endpoint.chmod(0o600)
        server.listen(1)
        server.settimeout(0.5)
        stop = threading.Event()

        def serve():
            while not stop.is_set():
                try:
                    conn, _ = server.accept()
                except socket.timeout:
                    continue
                with conn:
                    _, uid, _ = struct.unpack('3i', conn.getsockopt(socket.SOL_SOCKET, socket.SO_PEERCRED, 12))
                    conn.settimeout(10)
                    request = b''
                    while len(request) < 64:
                        chunk = conn.recv(64 - len(request))
                        if not chunk:
                            break
                        request += chunk
                    if uid != os.getuid() or request != b'build-m95\n':
                        conn.sendall(b'M95-EXIT 1\n')
                        continue
                    conn.settimeout(None)
                    status = 0
                    try:
                        build(conn.sendall)
                    except Exception as error:
                        status = 1
                        conn.sendall(('M95: ' + str(error) + '\n').encode())
                    conn.sendall(('M95-EXIT %d\n' % status).encode())
        thread = threading.Thread(target=serve, daemon=True)
        thread.start()
        try:
            return subprocess.call(command, cwd=WORKSPACE)
        finally:
            stop.set()
            thread.join()
            server.close()
            endpoint.unlink(missing_ok=True)


if __name__ == '__main__':
    raise SystemExit(main())
