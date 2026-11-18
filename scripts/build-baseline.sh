#!/usr/bin/env bash
# Run only inside Shoal's disposable privileged build container.
set -euo pipefail

[[ ${SHOAL_DISPOSABLE_BUILDER:-} == 1 && -f /.dockerenv ]] || { echo 'Disposable container required' >&2; exit 1; }
[[ $(id -u) == 0 && $(uname -m) == x86_64 ]] || { echo 'Root in an x86_64 build container required' >&2; exit 1; }
[[ $(realpath /workspace) == /workspace && -d /workspace/.cache/cachyos-live-iso ]] || exit 1
cd /workspace
mkdir -p out/baseline reports
exec > >(tee -a /workspace/reports/baseline-build.log) 2>&1
date -u
df -h /workspace
free -h
available_kb=$(df -Pk /workspace | awk 'NR==2 {print $4}')
(( available_kb >= 35000000 )) || { echo 'Less than 35 GB free; refusing to begin' >&2; exit 1; }

# Bring the disposable Arch builder up to date without partial upgrades.
pacman -Syu --noconfirm --needed archlinux-keyring archiso mkinitcpio-archiso squashfs-tools grub curl python sudo git xorriso
pacman-key --init
pacman-key --populate archlinux
key=882DCFE48E2051D48E2562ABF3B607488DB35A47
curl --fail --location --retry 3 --max-time 120 "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x$key" -o /tmp/cachyos-public-key.asc
gpg --show-keys --with-colons /tmp/cachyos-public-key.asc | awk -F: '$1=="fpr" {print $10}' | grep -Fx "$key"
pacman-key --add /tmp/cachyos-public-key.asc
pacman-key --lsign-key "$key"

python - <<'PY'
import hashlib, json, pathlib, urllib.request
root = pathlib.Path('/workspace')
inputs = json.loads((root/'config/baseline-inputs.json').read_text())
url = inputs['mirrorlist']['url']
data = urllib.request.urlopen(url, timeout=60).read(1048577)
assert len(data) <= 1048576, 'Mirror list too large'
assert hashlib.sha256(data).hexdigest() == inputs['mirrorlist']['sha256'], 'Mirror list changed'
pathlib.Path('/etc/pacman.d/cachyos-mirrorlist').write_bytes(data)
(root/'reports/cachyos-mirrorlist').write_bytes(data)
conf = pathlib.Path('/etc/pacman.conf')
text = conf.read_text()
assert '[cachyos]' not in text
text = text.replace('[core]', '[cachyos]\nInclude = /etc/pacman.d/cachyos-mirrorlist\n\n[core]', 1)
conf.write_text(text)
PY
pacman -Syu --noconfirm --needed cachyos-keyring
pacman-key --populate cachyos
pacman -Q > reports/builder-packages.txt
cp /etc/pacman.conf reports/builder-pacman.conf

# Work only in the already verified disposable upstream checkout.
src=/workspace/.cache/cachyos-live-iso
[[ $(realpath "$src") == "$src" && ! -e "$src/build" && ! -e "$src/out" ]] || { echo 'Expected a clean upstream checkout' >&2; exit 1; }
python - <<'PY'
import json, pathlib
root = pathlib.Path('/workspace')
src = root/'.cache/cachyos-live-iso'
inputs = json.loads((root/'config/baseline-inputs.json').read_text())
script = src/'util-iso.sh'
text = script.read_text()
old = 'https://github.com/CachyOS/CachyOS-PKGBUILDS/raw/master/cachyos-mirrorlist/cachyos-mirrorlist'
assert text.count(old) == 1
text = text.replace(old, inputs['mirrorlist']['url'])
old_curl = 'curl -sSL "${_mirrorlist_url}" >'
assert text.count(old_curl) == 1
text = text.replace(old_curl, 'curl --fail --location --retry 3 --max-time 120 "${_mirrorlist_url}" >')
script.write_text(text)
conf = src/'archiso/pacman.conf'
text = conf.read_text()
old = 'Server = https://mirror.cachyos.org/repo/$arch/$repo'
assert text.count(old) == 1
conf.write_text(text.replace(old, 'Include = /etc/pacman.d/cachyos-mirrorlist'))
PY
git -c safe.directory="$src" -C "$src" diff --binary > reports/upstream-build-adjustments.patch
cp config/source-lock.json config/baseline-inputs.json reports/
cp "$src/LICENSE" reports/UPSTREAM-LICENSE.txt
cp "$src/archiso/packages_desktop.x86_64" reports/requested-packages.txt

# The upstream helper can edit mkarchiso and use sudo: contain this in the VM/container.
useradd --create-home --uid "$(stat -c %u /workspace)" builder
printf 'builder ALL=(ALL) NOPASSWD: ALL\n' > /etc/sudoers.d/shoal-builder
chmod 0440 /etc/sudoers.d/shoal-builder
chown -R builder:builder "$src"
cd "$src"
sudo -H -u builder bash ./buildiso.sh -p desktop -v

mapfile -t images < <(find "$src/out/desktop" -maxdepth 1 -type f -name '*.iso')
(( ${#images[@]} == 1 )) || { echo 'Expected exactly one ISO' >&2; exit 1; }
image=/workspace/out/baseline/shoal-cachyos-baseline-x86_64.iso
cp "${images[0]}" "$image"
cd /workspace
cp "$src"/out/desktop/*.pkgs.txt out/baseline/
cp reports/upstream-build-adjustments.patch out/baseline/
git -c safe.directory="$src" -C "$src" archive --format=tar HEAD | gzip -n > out/baseline/upstream-source.tar.gz
cp reports/UPSTREAM-LICENSE.txt out/baseline/
xorriso -indev "$image" -report_el_torito plain > reports/iso-boot-layout.txt 2>&1
grep -q 'El Torito boot img' reports/iso-boot-layout.txt
python - <<'PY'
import hashlib, json, os, pathlib, datetime
root = pathlib.Path('/workspace')
image = root/'out/baseline/shoal-cachyos-baseline-x86_64.iso'
digest = hashlib.file_digest(image.open('rb'), 'sha256').hexdigest()
(image.parent/'SHA256SUMS').write_text(f'{digest}  {image.name}\n')
report = dict(status='built-not-boot-qualified', purpose='CachyOS baseline; Shoal apps and branding are not integrated',
    shoalCommit=os.environ['SHOAL_SOURCE_COMMIT'], upstream=json.loads((root/'config/source-lock.json').read_text())['upstream'],
    inputs=json.loads((root/'config/baseline-inputs.json').read_text()), iso=dict(name=image.name, bytes=image.stat().st_size, sha256=digest),
    createdUtc=datetime.datetime.now(datetime.timezone.utc).isoformat(), signed=False, secureBootQualified=False,
    installedSystemTested=False, hardwareQualified=False, packageInputs='rolling repositories; versions recorded, not reproducible snapshot')
(image.parent/'BUILD-INFO.json').write_text(json.dumps(report, indent=2)+'\n')
PY
(cd out/baseline && sha256sum --check SHA256SUMS)
echo 'Baseline ISO built and statically inspected; VM boot and installed-system acceptance remain separate.'
