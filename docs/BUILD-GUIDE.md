# Shoal OS: step-by-step build and release guide

Status: planning and implementation checklist, 2026-11-18. No Shoal ISO, installer, ISO-build workflow or qualified device is available yet. The [source foundation](FOUNDATION.md) now provides input validation and hosted capacity inventory only. A checked planning item is not evidence of a working OS.

## 1. Keep the project boundaries

Owner: Codex.

1. Work only in `KailanBess/Shoal` for this project.
2. Leave Aquarium, FishBowl, FishNet, FishTank and their existing release workflows unchanged.
3. Reference approved public releases or exact source commits as dependencies. Keep Shoal adaptations here and retain upstream attribution/license obligations.
4. Do not install an OS, repartition disks, change firmware settings or update installed apps on the owner's PC as part of repository work.

Done when: the design, build inputs and review diff live in Shoal alone. This boundary is already documented.

## 2. Establish the first preview scope

Owner: Codex proposes and records; owner decides product preferences.

1. Use CachyOS as the selected base.
2. Keep the product design hardware-neutral between PCs and handhelds.
3. Record **x86-64/desktop as the working first prototype build target; not a qualified hardware specification**. ARM support is a separate engineering target, not implied by neutral styling.
4. Before building, declare the artifact's actual architecture, minimum CPU instruction requirements and GPU/profile choices using the pinned upstream requirements. Do not assume an older CPU or every handheld works.
5. First preview scope: bootable live ISO, KDE desktop fallback, FishBowl Linux integration, Shoal branding, basic setup and documented recovery. Verify installed-system behavior separately from the live session.
6. Keep later Linux adaptations clearly marked planned until implemented and tested.

Done when: a versioned build specification states exactly what the first artifact contains and excludes.

## 3. Prepare GitHub

Owner: owner for account/repository settings; Codex for files and workflows.

1. Open [Shoal Actions](https://github.com/KailanBess/Shoal/actions). Enable Actions if GitHub displays a disabled-actions notice.
2. Under repository **Settings → Actions → General**, check that the actions used by the eventual workflow are permitted. Keep the default workflow token read-only; publishing jobs can request narrowly scoped write access in YAML.
3. Allow a workflow run if GitHub explicitly requests approval. The Source foundation validation workflow is available after merge; it does not build an ISO. No ISO-build workflow exists yet.
4. Check Actions storage, runner availability and any billing/spending limits before using paid capacity. Do not buy capacity until actual build measurements show it is needed.
5. Prefer reviewed changes through pull requests once executable build configuration is introduced. Optional branch rules should require the real checks after those checks exist.
6. Keep personal tokens, signing keys, passwords and runner registration tokens out of code, issues, chat and logs. A normal repository workflow can use its built-in GitHub token; a personal access token should not be the default requirement.

Done when: an appropriate runner can execute an explicitly requested Shoal workflow. The documentation does not claim current settings have been inspected or changed.

References: [GitHub secure workflow guidance](https://docs.github.com/en/actions/reference/security/secure-use) and [current Actions limits](https://docs.github.com/en/actions/reference/limits).

## 4. Obtain a disposable Linux builder

Owner: Codex evaluates a hosted runner first; owner provisions a VM/runner only if needed.

1. Use a disposable CachyOS/Arch-compatible Linux build environment with the privileges and filesystem features required by the pinned ISO builder. The Windows workspace is for source work, not a native CachyOS ISO build host.
2. First evaluate a fresh GitHub-hosted Linux VM with an isolated Arch/CachyOS build environment. Do not assume an Ubuntu host or an unprivileged container can run the builder unchanged: verify mount, loop-device, chroot, repository and CPU requirements.
3. Measure free disk, peak disk usage, RAM, CPU instructions, network access and elapsed build time. As an initial **planning allowance**, aim for 4+ vCPU, 8–16 GB RAM and 80–120 GB free disk. These are Shoal estimates, not verified minimums or upstream guarantees.
4. If hosted capacity is insufficient, use a larger ephemeral runner or disposable Linux VM. A self-hosted runner is optional, not automatically required.
5. For a public repository, never run untrusted pull-request code on a persistent privileged runner containing credentials or personal data. Use isolated disposable jobs and separate publishing credentials from builds.
6. Provide access to trusted package mirrors and source repositories. Retain package signature verification; fix keyring/mirror errors rather than disabling verification.
7. Keep ISOs, caches and temporary root filesystems out of Git. Retain only useful logs/manifests as artifacts, with bounded retention.

Done when: the builder can complete a clean upstream baseline build and its capacity measurements are recorded. No VM needs to be installed on the owner's daily-use PC for the first hosted attempt.

## 5. Pin and verify upstream inputs

Owner: Codex.

1. Review and pin a commit of [CachyOS-Live-ISO](https://github.com/CachyOS/CachyOS-Live-ISO).
2. Read that revision's scripts, profile files, dependencies and licenses. Do not treat moving upstream instructions as a tested Shoal command sequence.
3. Record repository configuration, signing-key fingerprints, package versions, source commits and retrieval information. Rolling mirrors can change between builds; pinned scripts alone do not make an ISO reproducible.
4. Validate a supported way to retain exact package inputs or a controlled repository snapshot before claiming reproducible output.
5. Build the upstream desktop baseline on the disposable builder first. Compare logs and output layout against the pinned builder.
6. The upstream README currently documents `buildiso.sh`, a desktop profile and an `out` result directory. These are starting references, not a Shoal build script that exists today. The reviewed automation must perform complete system upgrades when preparing an Arch-family builder instead of copying isolated database-sync instructions.

Done when: the upstream revision, baseline ISO checksum and build report are recorded and repeatable enough to debug.

## 6. Implement Shoal's build files

Owner: Codex, in Shoal only.

1. Add a reviewed source lock/manifest, ISO profile configuration, build wrapper, validation scripts and documentation. Use explicit output/work directories; guard cleanup so it cannot target unrelated paths.
2. Add Shoal name, version, desktop branding and installer identity. Retain accurate CachyOS/Arch attribution. Shoal is a derivative, not an official upstream edition.
3. Track separately what is present in the live ISO and what the installer puts on the installed system. Test that Shoal customizations survive installation.
4. Keep upstream driver and hardware-detection components unless a tested replacement is necessary.
5. Retain existing desktop setup tools until Shoal alternatives work. Do not replace working network/audio/display setup with nonfunctional themed buttons.
6. Do not disable package signatures, broadly grant privileges, add default remote administration or silently enable application telemetry.

Done when: a clean checkout and documented builder produce a versioned Shoal ISO with correct contents.

## 7. Integrate FishBowl first

Owner: Codex.

1. Select a fixed approved FishBowl Linux release/source revision and verify its checksum and redistribution obligations.
2. Package it through an explicitly chosen owner, preferably a Shoal package for system installation. Never use the Windows updater to replace Linux package-owned files.
3. Provide a desktop entry and controller-friendly launch route. Prototype under a normal desktop before introducing a separate gaming session.
4. Make controller-first startup recoverable: an app crash must leave a way to reach the desktop or recovery interface, not a restart loop.
5. Test emulators opening externally, focus transfer, game exit, multiple sessions and returning to FishBowl. Linux does not currently inherit Windows embedded Play behavior.
6. Test new and existing profiles, missing drives, permissions, save snapshots and restore previews. Run games with normal user privileges.
7. Add emulators only through reviewed trusted packages with compatible licenses. Do not bundle commercial games, console BIOS/firmware/keys or scraped copyrighted artwork without redistribution permission. Homebrew fixtures need permission too.

Done when: a legal test fixture launches with usable input, exits cleanly and preserves/restores its save in a tested live and installed environment.

## 8. Configure PC and handheld experiences

Owner: Codex implements; physical testers supply evidence.

1. Share navigation, colors, typography and app identities across profiles.
2. PC: keyboard/mouse and controller operation, TV readability, multiple displays, external audio and optional controller-first startup.
3. Handheld: controller-only first-run setup, touch and on-screen keyboard, small-screen text, battery status and device-supported power/performance settings.
4. Test built-in controls, hotplugged USB/Bluetooth controllers, reconnects, rumble where supported and recovery without a keyboard.
5. Test suspend/resume during play, audio output changes and docking/undocking. Do not apply guessed TDP, fan or charging limits to unknown hardware.
6. Review upstream [Handheld Edition](https://wiki.cachyos.org/installation/installation_handheld/) components as references. Its Steam-oriented session does not automatically become a FishBowl-first session or prove Shoal device compatibility.
7. Keep a compatibility table with **untested / passes / fails / limited**, exact device and image version, and known workarounds.

Done when: the feature works in the actual relevant profile. Physical handheld support stays unqualified until tested on named devices.

## 9. Build the remaining required Linux editions in stages

Owner: Codex; all adaptations initially remain in Shoal. All seven Linux editions are required built-in applications for the complete OS. Follow [the delivery and parity requirements](LINUX-APPS.md). Intermediate prototypes may include a subset, but must list missing editions explicitly.

| App | Work before inclusion |
| --- | --- |
| Aquarium | Linux control-center UI, package-manager delegation, paths, permissions, settings and recovery. Existing WinUI UI cannot run natively unchanged. |
| FishNet | Linux UI, playback/conversion backend, codecs, audio devices and library compatibility. Windows media APIs need replacement. |
| FishTank | Linux-specific protection evidence, permissions and authenticated recovery. Defender, DPAPI and Windows policy functions do not become Linux protections. |
| File Organizer | Linux UI, permissions, case sensitivity, links, cross-filesystem moves and recovery. |
| Device Inventory | Linux UI/data handling; hardware inspection requires separately implemented Linux collectors. |
| Workspace Launcher | Linux discovery and launch handling; Wayland positioning depends on compositor support. |

1. Include only implemented and validated components in release notes.
2. Preserve portable data fields and document migrations. Test recovery before changing profile schemas.
3. Keep Windows-account-protected secrets out of automatic migration; require appropriate reenrollment.
4. Provide one update owner per installed app. Separate system packages from optional Flatpak or other user-managed apps.

Done when: each included app has functional Linux behavior and tests; a launcher shortcut alone does not count as a port.

## 10. Implement updates and recovery

Owner: Codex.

1. Delegate system updates to full pacman upgrades with clear progress, cancellation boundaries and failure handling. Never offer unsupported partial system upgrades.
2. Serialize package operations and respect transaction locks. Do not remove a live lock to force an update.
3. Require appropriate authentication only for privileged operations; keep normal apps unprivileged.
4. Offer Btrfs snapshot recovery only when the selected layout, tooling and bootloader support it and have passed tests.
5. Verify root, boot/kernel/initramfs coverage and excluded subvolumes. Test interrupted updates and restoration, including any package-database consistency implications.
6. Maintain live-media recovery instructions. Do not describe snapshots as atomic upgrades or independent backups; same-drive snapshots do not protect against drive loss.
7. Back up user saves and records separately, and test restoration. Clearly identify external content that record-only backups do not include.
8. Document Secure Boot status separately. ISO checksums, package signatures and Secure Boot are different trust mechanisms. Do not claim Secure Boot works until the image's full boot chain is tested; do not automatically change firmware keys/settings.

Done when: the documented failure and restore scenarios pass on the configured layout. References: [CachyOS snapshots](https://wiki.cachyos.org/configuration/btrfs_snapshots/), [Secure Boot](https://wiki.cachyos.org/configuration/secure_boot_setup/) and [Arch update rules](https://wiki.archlinux.org/title/System_maintenance#Partial_upgrades_are_unsupported).

## 11. Add GitHub automation

Owner: Codex.

1. Add cheap configuration/lint checks for pull requests, using read-only credentials.
2. Add a manual preview ISO workflow after the baseline build works. Do not publish an untested build on every documentation change.
3. Pin third-party actions and external build inputs. Set timeouts, concurrency and artifact retention; preflight disk capacity.
4. Build without publishing/signing secrets. Save the ISO, SHA-256 manifest, package list, source/build manifest and redacted build log.
5. Use a separate release job with only required write access and any protected signing configuration. Keep private keys and passphrases in the appropriate secret store, never the repository.
6. Make publish depend on required checks and explicit preview/release policy. Do not treat a source commit as an installable update.
7. Account for current GitHub runner, artifact and release-asset limits; do not promise free unlimited builds. Hosted job duration and storage vary by service limits.

Done when: the first real workflow run finishes, artifacts can be downloaded and their hashes match. No success should be inferred merely from valid YAML.

## 12. Test before release

Owner: Codex for automated/available VM checks; owner or volunteer testers for physical hardware.

1. VM: UEFI boot, live desktop, login, first-run setup and recovery from FishBowl failure.
2. Disposable virtual disk: installer preview/confirmation, installation, reboot without ISO, correct packages/branding and user creation. Confirm installer actions target only the test disk.
3. Functional tests: legal game fixtures, controller/keyboard focus, game exit, saves, missing media and disconnected storage.
4. Recovery tests: full updates, interrupted writes/transactions, corrupt profiles, configured snapshots and restored saves.
5. UI: all pages, menus and dialogs at small/large screen sizes and scaling; high contrast, focus visibility, text overflow and controller-only navigation.
6. Privacy/security: no shipped personal profiles, passwords, keys, tokens, network auto-exposure or test accounts in the installed product; no secrets in logs/manifests.
7. Physical matrix: AMD/Intel/NVIDIA variants as available, sound, Wi-Fi, Bluetooth, controllers, battery, suspend/resume and dock transitions. An untested matrix entry stays untested.
8. Record image hash, environment, test date, pass/fail evidence and limitations. A VM boot does not qualify physical graphics or handheld power management.

Done when: required preview gates pass and remaining limitations are explicitly documented, without calling incomplete ports or untested hardware supported.

## 13. Publish the first preview

Owner: Codex for repository/artifacts where tool permissions allow; owner for required account settings or signing credentials.

1. Inventory bundled licenses, notices, source obligations and redistributable assets; select Shoal's own source license separately. Do not assume all upstream material has one license or imply upstream endorsement.
2. Choose a preview version and tag the exact reviewed source. Attach the actual ISO, SHA256SUMS, build/package manifests, notices/source references and known-issues notes.
3. GitHub's automatic source ZIP is not an ISO. State clearly which asset to download.
4. Check current per-asset size limits. If the ISO is too large, use an approved download host and documented checksums rather than committing the ISO to Git.
5. Verify the uploaded bytes against the manifest; retain provenance. A checksum detects changed bytes relative to trusted metadata, not independent publisher identity.
6. Label the release **prerelease/preview**, list tested devices and state Secure Boot/signature status accurately.
7. Publish VM-first testing instructions. Flashing USB media or installing to physical disks is a later explicit user action with a reviewed destination and backup plan.
8. Verify public download availability and release notes. Keep the previous known-good build and documented recovery route.

Done when: a public preview ISO is downloadable, verified and accompanied by honest installation and support limits. Reference: [GitHub releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases).

## 14. Maintain the OS

Owner: Codex for requested development; project owner for project operations and physical testing.

1. Track upstream package/kernel/ISO-builder changes and review dependency updates.
2. Repeat boot, upgrade, restore and app integration checks for each candidate release.
3. Triage bugs with redacted diagnostics; never ask users to post credentials or proprietary game files.
4. Expand hardware support only with evidence. Keep known regressions visible and retain recovery builds.
5. Plan signing-key backup/rotation, mirror availability, artifact retention and security response before calling the distribution stable.

## What the owner needs to do next

1. The working first target is **x86-64/desktop**. Request another architecture if needed; additional targets require separate build and test work. No specific PC or handheld model is required for planning.
2. Check that Shoal Actions is available; enable/approve only if GitHub requests it.
3. Let Codex prepare and validate the upstream baseline and build workflow. A VM, personal token, paid runner, domain or signing certificate is not automatically required from the owner now.
4. If measured runner limitations block the build, choose an offered builder option then. Do not register a persistent privileged runner preemptively.
5. Later, supply physical test evidence or arrange testers before hardware-support claims or stable release.

Everything else above is implementation/review work to perform in Shoal, not a request for the owner to write the operating system manually.
