# First CachyOS baseline ISO

Build completed on 2026-11-18. This is an engineering baseline using CachyOS desktop content. It is not the finished Shoal interface or app suite.

## Download

- [Baseline ISO artifact](https://github.com/KailanBess/Shoal/actions/runs/44383998911/artifacts/14466818906)
- [Successful build run](https://github.com/KailanBess/Shoal/actions/runs/44383998911)
- [Build diagnostics](https://github.com/KailanBess/Shoal/actions/runs/44383998911/artifacts/14467387953)
- [Initial boot smoke attempt](https://github.com/KailanBess/Shoal/actions/runs/44389782453)
- [Virtio artifact verification and boot smoke run](https://github.com/KailanBess/Shoal/actions/runs/44391730467)

GitHub Actions artifact downloads may require signing in. Extract the downloaded ZIP; the image is `shoal-cachyos-baseline-x86_64.iso`. Artifacts are temporary and currently expire on 2026-12-02. This is not a permanent public Release download. The ZIP is about 3.25 GB.

The download includes `SHA256SUMS`, `BUILD-INFO.json`, an installed-package list, the pinned upstream source archive, its license document and the build adjustments patch. Verify the extracted ISO against SHA256SUMS before use. Do not mistake GitHub's automatic repository source ZIP for the ISO.

ISO size: 3,253,714,944 bytes. ISO SHA-256:

`7b3a9b771c5949500645d4425845c48d5f48a1421bca2b82b61d8e26e94aa982`

Uploaded artifact ZIP SHA-256 (distinct from the ISO checksum inside):

`1b0bf0757ff001e5e83b3af7e2be9804e1568b0586272a5d653238af096a747a`

## Build identity and changes

- Shoal build-recipe commit: `dfd37992f8cf321350118cd07ba31cdeaac28f05`.
- CachyOS-Live-ISO: `b0ebcae291b104765a60e330a5d25a26a69a2234`.
- Target: x86-64 desktop baseline; no named physical device is certified.
- Builder: immutable Arch Linux container digest recorded in `config/baseline-inputs.json`, run privileged only on a disposable hosted Linux VM.
- Mirror list pinned to `CachyOS/CachyOS-PKGBUILDS` commit `4d03c35d9de19126fe502085f04d862f4ccd75c9` and SHA-256 checked.
- Minimal upstream adjustments pin that mirror-list fetch, fail on HTTP errors and use the reviewed mirror list for package resolution. The patch is retained with the source archive.
- Package signature verification remains enabled. The build bootstraps the full CachyOS key fingerprint documented upstream, then installs its signed keyring package.
- Actual package versions, builder configuration, boot-layout output and logs are retained in diagnostics. Repositories are rolling; this is not a reproducible package snapshot.

## Verification boundaries

The build completed, found El Torito boot entries and passed its ISO checksum check. A separate job downloads that artifact again and checks its checksum, size and source identity before starting VMs. See the linked job for limited boot-test results.

The smoke tests are deliberately separate: original ISO through UEFI to GRUB, then the ISO's own kernel/initramfs booted with a serial-console command line to check the live Linux system. The second test bypasses GRUB and uses multi-user mode. Neither test qualifies graphical desktop startup, full UEFI-to-desktop behavior, the installer, installed-system updates, controllers, suspend, Secure Boot or physical hardware.

The first smoke attempt reached GRUB and mounted the live root, but entered emergency mode waiting for QEMU's default Bochs DRM module. The follow-up test uses explicit virtio graphics. Retain this as a known virtual-graphics limitation rather than implying every GPU configuration works. The first isolated guest log also recorded namespace-resource and time-synchronization service failures; service health and normal desktop behavior require separate acceptance.

This baseline is unsigned. It contains upstream CachyOS branding/content and does not yet include Shoal's Linux app suite. FishBowl integration, the remaining native Linux editions, shared OS appearance and installer/recovery acceptance remain future work. Existing app designs and repositories remain unchanged.

## Rebuild and retest

After the workflow is merged into main, open **Actions → CachyOS baseline ISO → Run workflow** for a deliberate fresh baseline build. It does not run automatically on main documentation changes. The baseline workflow can take around half an hour, depending on mirrors, packages and compression.

The smoke workflow tests the exact run in `config/baseline-test-inputs.json`. Update that run ID/source identity after a new successful build, especially after artifacts expire. Do not silently substitute an unreviewed latest artifact. Source input locks are not build-result records; use BUILD-INFO, workflow results and smoke evidence for actual build/boot status.

Use disposable VMs for the next acceptance work. Installing or flashing this baseline on a physical disk is separate work; none of that was performed during the build.
