"""Read-only VM checks of an existing baseline ISO; never attach a host data disk."""
import json
import os
import pathlib
import re
import shutil
import subprocess
import time

root = pathlib.Path.cwd()
image = root / 'baseline/shoal-cachyos-baseline-x86_64.iso'
reports = root / 'reports/boot-smoke'
reports.mkdir(parents=True, exist_ok=True)
info = json.loads((image.parent / 'BUILD-INFO.json').read_text())
assert image.is_file() and info['iso']['name'] == image.name
assert image.stat().st_size == info['iso']['bytes']


def command(args):
    subprocess.run(args, check=True)


def boot(name, extra, pattern, seconds):
    serial = reports / f'{name}-serial.log'
    stderr = (reports / f'{name}-qemu.log').open('w')
    serial_output = serial.open('wb')
    kvm = os.access('/dev/kvm', os.R_OK | os.W_OK)
    args = ['qemu-system-x86_64', '-machine', 'q35', '-accel', 'kvm' if kvm else 'tcg',
            '-cpu', 'host' if kvm else 'max', '-smp', '2', '-m', '4096',
            '-vga', 'virtio', '-display', 'none', '-serial', 'stdio', '-monitor', 'none',
            '-nic', 'none', '-no-reboot', '-cdrom', str(image)] + extra
    process = subprocess.Popen(args, stdin=subprocess.PIPE, stdout=serial_output, stderr=stderr)
    started = time.monotonic()
    try:
        while time.monotonic() - started < seconds:
            text = serial.read_text(errors='replace') if serial.exists() else ''
            plain = re.sub(r'\x1b\[[0-?]*[ -/]*[@-~]', '', text)
            if re.search(pattern, plain, re.I | re.M):
                result = dict(test=name, passed=True, accelerator='kvm' if kvm else 'tcg',
                              graphics='virtio-vga', elapsedSeconds=round(time.monotonic() - started, 1))
                print(json.dumps(result), flush=True)
                return result
            if re.search(r'Reached target.*Emergency Mode|You are in emergency mode', plain, re.I):
                # journald is forwarded by the test-only kernel command line.
                time.sleep(5)
                diagnostic = serial.read_text(errors='replace')
                print(diagnostic[-24000:], flush=True)
                raise RuntimeError(f'{name}: emergency mode; isolated guest diagnostics retained')
            if re.search(r'Kernel panic|Unsupported CPU|This kernel requires', plain, re.I):
                raise RuntimeError(f'{name}: guest boot failure\n{plain[-6000:]}')
            if process.poll() is not None:
                raise RuntimeError(f'{name}: QEMU exited {process.returncode}; see QEMU log')
            time.sleep(3)
        raise RuntimeError(f'{name}: timed out; inspect serial/QEMU logs')
    finally:
        if process.poll() is None:
            process.terminate()
            try:
                process.wait(timeout=15)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait(timeout=10)
        stderr.close()
        serial_output.close()


try:
    # Boot the original ISO through UEFI and confirm GRUB reaches its serial menu.
    code = pathlib.Path('/usr/share/OVMF/OVMF_CODE_4M.fd')
    variables = pathlib.Path('/usr/share/OVMF/OVMF_VARS_4M.fd')
    assert code.is_file() and variables.is_file(), 'Expected OVMF firmware missing'
    local_variables = reports / 'uefi-vars.fd'
    shutil.copyfile(variables, local_variables)
    firmware = boot('uefi-grub', ['-drive', f'if=pflash,format=raw,readonly=on,file={code}',
                    '-drive', f'if=pflash,format=raw,file={local_variables}', '-boot', 'd'],
                    r'Welcome to CachyOS', 150)

    # Separately start the ISO's own kernel/initramfs with serial diagnostics.
    # This bypasses GRUB for this second check and changes no ISO bytes.
    files = reports / 'boot-files'
    command(['xorriso', '-osirrox', 'on', '-indev', str(image), '-extract', '/arch/boot/x86_64', str(files)])
    grub = reports / 'grub.cfg'
    command(['xorriso', '-osirrox', 'on', '-indev', str(image), '-extract', '/boot/grub/grub.cfg', str(grub)])
    match = re.search(r'archisosearchuuid=([^\s]+)', grub.read_text())
    assert match and re.fullmatch(r'[a-zA-Z0-9-]+', match[1]), 'Missing/invalid ISO search UUID'
    append = f'archisobasedir=arch archisosearchuuid={match[1]} copytoram=no cow_spacesize=512M console=ttyS0,115200 loglevel=6 systemd.unit=multi-user.target systemd.show_status=1 systemd.journald.forward_to_console=1'
    tests = [firmware]
    failures = []
    for suffix, name in [('', 'live-linux-console'), ('-lts', 'live-linux-lts-console')]:
        kernel = files / f'vmlinuz-linux-cachyos{suffix}'
        initrd = files / f'initramfs-linux-cachyos{suffix}.img'
        assert kernel.is_file() and initrd.is_file(), 'Expected kernel/initramfs missing'
        try:
            tests.append(boot(name, ['-kernel', str(kernel), '-initrd', str(initrd), '-append', append],
                              r'Reached target.*Multi-User System', 600))
        except RuntimeError as error:
            failures.append(name)
            tests.append(dict(test=name, passed=False, error=str(error)[-6000:]))
            print(f'{name} failed; continuing to collect the other kernel result', flush=True)
    result = dict(passed=not failures, baselineBuild=info['shoalCommit'], iso=info['iso'], tests=tests,
                  limits='UEFI-to-GRUB and separate serial Linux live boot only; no desktop, installer, controller, suspend or hardware qualification')
    (reports / 'RESULT.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2), flush=True)
    if failures:
        raise RuntimeError('Boot qualification failed: ' + ', '.join(failures))
finally:
    # Do not upload large extracted kernels or per-test firmware variables.
    if (reports / 'boot-files').exists():
        os.chmod(reports / 'boot-files', 0o700)
        shutil.rmtree(reports / 'boot-files')
    (reports / 'uefi-vars.fd').unlink(missing_ok=True)
