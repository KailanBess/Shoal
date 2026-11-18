# Source foundation and upstream review

Status: source-locking engineering report. Its validation workflow does not build an ISO; a separate [baseline ISO build](BASELINE-BUILD.md) has since completed.

## Selected inputs

- Base: CachyOS, upstream `CachyOS/CachyOS-Live-ISO`.
- Reviewed commit: `b0ebcae291b104765a60e330a5d25a26a69a2234`, dated 2026-11-15.
- Initial prototype target: `x86_64`, upstream `desktop` profile. This is a build starting point, not certification of a CPU, GPU or handheld. Minimum CPU requirements remain unqualified.
- Ten reviewed entry-point/configuration/license files have SHA-256 hashes in [the source lock](../config/source-lock.json). CI fetches the exact commit and checks those bytes before any later build work.
- No upstream scripts are copied into Shoal's tracked source or executed by this validation workflow.

## Review findings to resolve before the baseline build

1. `buildiso.sh` imports local helpers and uses source-relative `build` and `out` directories. The build can recursively remove its work tree; run only in a disposable checkout with guarded paths.
2. `util-iso.sh` edits `/usr/bin/mkarchiso` on the builder, including verbosity and keyring-timer customization. Use a disposable Linux VM/container with the required privileges, never a personal long-lived host.
3. Profile preparation downloads the current mirror list from another repository's moving `master` branch. Pin/review or record that input before claiming repeatability. Packages also come from rolling repositories.
4. The reviewed upstream build profile supports `desktop`; its implementation rejects other profile names. A handheld profile cannot be invented by passing a different flag.
5. The ISO package list includes graphical desktop/installer, multiple kernel/driver variants and recovery tools. It is not evidence of a minimal gaming-only image. Review services, live credentials and installer defaults before redistribution.
6. The upstream CI uses a privileged Arch Linux container on an Ubuntu runner. This is evidence of an approach to evaluate, not proof that Shoal has enough disk, kernel capabilities or current package compatibility. Do not copy its broad permissions or moving inputs unchanged.
7. The package configuration requires repository package signatures; preserve trust checks. It also includes sandbox-related settings that need explicit review when preparing Shoal's configuration. Do not infer that every upstream default is appropriate for the installed OS.
8. The repository's root `LICENSE` contains GPL version 3, while several shell headers identify GPL version 2. Preserve notices and review file-specific licensing before redistribution or modification. Do not label the entire upstream tree with one inferred license.
9. Upstream signing skips a detached signature when no GPG key is configured. Missing signatures must stay explicit. No private keys or signing credentials are needed for source validation.
10. Some date/version generation and network inputs remain dynamic. A fixed source commit and matching script hashes do not imply a reproducible ISO or a security audit.

Review scope: build entry point, imported shell helpers, mount helper, profile definition, pacman configuration, desktop package list, upstream CI and root license. This is not a complete audit of every live root file, installer package or dependency.

## Run the checks

Requires Node.js 22+ and Git. No npm install, administrative access, package installation or signing secret is required.

```sh
node scripts/validate-foundation.mjs
node --test tests/foundation.test.mjs
```

To verify the actual upstream checkout, obtain the exact commit in a separate directory and run:

```sh
node scripts/validate-foundation.mjs /path/to/cachyos-live-iso
```

The validator checks the checkout HEAD and the reviewed files' exact bytes, rejecting symlinked reviewed paths. It does not execute upstream code or assert that every unreviewed file was audited. Do not run the upstream builder yet as part of these commands.

## GitHub checks

The **Source foundation** workflow validates the lock, runs regression checks, fetches pinned upstream source, verifies reviewed bytes and parses selected shell scripts with `bash -n`. It uses read-only token permissions and pinned checkout actions. Its final step records hosted disk/RAM and tool availability in the job summary.

That inventory does not qualify loop mounts, privileged containers, package downloads, a successful ISO build or VM boot. There is no ISO artifact or publish job in this workflow.

The Windows development host has no installed WSL environment; this project does not install one. A disposable hosted Linux baseline builder has now completed; see [the build evidence](BASELINE-BUILD.md). Remaining work includes Shoal branding, app packages and installer/hardware acceptance. The license and reproducibility limitations above still apply.

## Upstream references

- [Pinned source](https://github.com/CachyOS/CachyOS-Live-ISO/tree/b0ebcae291b104765a60e330a5d25a26a69a2234)
- [Build entry point](https://github.com/CachyOS/CachyOS-Live-ISO/blob/b0ebcae291b104765a60e330a5d25a26a69a2234/buildiso.sh)
- [Build implementation](https://github.com/CachyOS/CachyOS-Live-ISO/blob/b0ebcae291b104765a60e330a5d25a26a69a2234/util-iso.sh)
- [Upstream CI](https://github.com/CachyOS/CachyOS-Live-ISO/blob/b0ebcae291b104765a60e330a5d25a26a69a2234/.github/workflows/build.yml)
