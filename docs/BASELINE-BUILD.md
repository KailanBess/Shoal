# CachyOS baseline ISO — revision 2

Built on 2026-11-18. This is a CachyOS-based engineering image with Shoal boot configuration. The finished Shoal interface and Linux app suite are still future work.

## Download

- [Revision 2 ISO artifact](https://github.com/KailanBess/Shoal/actions/runs/44400893620/artifacts/14474305874)
- [Successful build](https://github.com/KailanBess/Shoal/actions/runs/44400893620)
- [Build metadata and diagnostics](https://github.com/KailanBess/Shoal/actions/runs/44400893620/artifacts/14472956501)
- [Revision 2 verification and boot checks](https://github.com/KailanBess/Shoal/actions/runs/44402203427)

GitHub artifact downloads may require signing in. Extract the ZIP to obtain `shoal-cachyos-baseline-x86_64.iso`. The ZIP is about 3.58 GB; artifacts currently expire on 2026-12-02. This is temporary engineering-artifact hosting, not a permanent public Release.

The download includes `SHA256SUMS`, `BUILD-INFO.json`, `installed-packages.txt`, the pinned upstream source archive, its license document and the build-adjustments patch. GitHub's automatic repository source ZIP is not the ISO.

ISO size: **3,575,021,568 bytes**. ISO SHA-256:

`6e12d450fca0fe082fdcc4a83efae39b51015c9c0103db3f9aeffa63ba8564c7`

Uploaded artifact ZIP SHA-256, distinct from the ISO:

`2e0732ed1b372ddb4e1199c56ac3ac816770b4e2fa1fc0b4e32a180764d83ac1`

## Build identity

- Build-recipe commit: `187664cab3db564c3e283e7a99b46accc352a1eb`.
- CachyOS-Live-ISO: `b0ebcae291b104765a60e330a5d25a26a69a2234`.
- Target: x86-64 desktop baseline, without named physical-device certification.
- Pinned Arch container digest and mirror-list source/hash are recorded in `config/baseline-inputs.json`.
- **1,008 installed package versions** are recorded from the built root's local package database. The build checks required core packages and records an inventory hash.
- Package signature verification stays enabled. Root/configuration changes are retained in the patch alongside upstream source.
- Packages come from rolling repositories. Recorded versions and script hashes do not establish a reproducible package snapshot.

## Revision 2 changes

The first image built successfully and passed checksum/static boot-file checks, but software-emulated VM startup entered emergency mode after device initialization stalled. The logs showed a namespace service repeatedly timing out while consuming CPU. Both included kernels reproduced the problem.

The pinned [CachyOS settings](https://github.com/CachyOS/CachyOS-Settings/blob/1.4.4/usr/lib/systemd/system.conf.d/00-timeout.conf) set a 15-second service startup budget. Revision 2 retains required services and failure handling, with these bounded allowances:

- Default service startup: 120 seconds.
- Default device wait: 120 seconds.
- DRM initialization target: 180 seconds; its emergency failure handling remains enabled.

Revision 2 uses zstd for the live filesystem and initramfs. The live-filesystem compression stage dropped from roughly 25 minutes in the first run to a few minutes. The artifact is somewhat larger. Boot tests, rather than this build-time observation, determine whether startup succeeds.

## Verification and limits

The revision 2 build succeeded, contains BIOS/UEFI El Torito entries and passed its ISO checksum check. The separate verification job downloads that exact artifact and verifies the ISO, source identity, inventory count and inventory hash before booting.

**Revision 2 boot checks are pending until the linked job finishes.** No passing result should be inferred from a successful build alone.

The boot checks are deliberately separate: the original ISO through UEFI to GRUB, followed by each included kernel/initramfs booted against that ISO with a serial-console command line into multi-user mode. The kernel checks bypass GRUB and forward diagnostic journals to the console. They do not qualify graphical desktop startup, full UEFI-to-desktop behavior, installation, updates of an installed system, controllers, suspend, Secure Boot or physical hardware.

The image remains unsigned and mostly carries upstream CachyOS branding/content. FishBowl integration, the other native Linux editions, shared OS appearance and installer/recovery acceptance remain future work. Existing app repositories, Windows releases and installed profiles are unchanged.

## Rebuild and retest

After merge, open **Actions → CachyOS baseline ISO → Run workflow** for a deliberate fresh build. It does not rebuild automatically on main documentation changes. Build time varies with mirrors and package inputs.

The smoke workflow tests the precise run and source identity in `config/baseline-test-inputs.json`. Update those inputs after a new successful build or expired artifacts. Input locks are not build-result records; use workflow evidence and BUILD-INFO for actual results.

Use disposable VMs for further acceptance. No physical disk was flashed or installed during this work. The owner's reference ISOs and USB are not used as build inputs.

## Earlier evidence

The [first baseline build](https://github.com/KailanBess/Shoal/actions/runs/44383998911) is retained as historical evidence. [Its two-kernel diagnostic run](https://github.com/KailanBess/Shoal/actions/runs/44398735792) failed live boot. Prefer the revision 2 artifact above for ongoing engineering; do not describe the first image as boot-qualified.
