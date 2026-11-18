# Shoal project checklist

Planning status: 2026-11-18. Checked items mean the stated decision/documentation exists, not that a build passed. Follow [the build guide](BUILD-GUIDE.md) for each step, owner and completion evidence.

## Confirmed

- [x] Separate `KailanBess/Shoal` repository.
- [x] Shoal name and tagline: Your games. One current.
- [x] CachyOS selected as the base.
- [x] PC and handheld product scope; hardware-neutral planning.
- [x] Existing app repositories must remain unchanged.
- [x] Design, integration plan, roadmap and detailed build guide documented.

## Owner setup / decisions

- [ ] Confirm the recommended initial x86-64 build architecture.
- [ ] Verify Actions availability and enable/approve if GitHub requests it.
- [ ] Select extra runner capacity only if a measured build limitation requires it.
- [ ] Arrange named physical test devices/testers later.

## Engineering — all pending

- [ ] Pin and review upstream ISO-builder source and licenses.
- [ ] Validate a disposable Linux builder; record capacity and privileges.
- [ ] Build an unchanged upstream baseline.
- [ ] Record source/package/repository inputs and baseline hashes.
- [ ] Implement Shoal ISO profiles, packaging, build wrapper and branding.
- [ ] Verify live-session and installed-system content separately.
- [ ] Integrate a fixed FishBowl Linux revision with license/source obligations.
- [ ] Test controller-first launch, crash recovery and desktop fallback.
- [ ] Implement PC and handheld configuration profiles.
- [ ] Validate first-run controls, keyboard/touch, audio, display and networking.
- [ ] Implement full-system update ownership and privileged transaction handling.
- [ ] Test configured snapshots, boot/kernel recovery and separate user backups.
- [ ] Implement and test optional Linux app adaptations before inclusion.
- [ ] Add read-only PR checks and a manual preview ISO workflow.
- [ ] Complete a real build run and verify downloaded artifact checksums.

## Preview acceptance — all pending

- [ ] VM UEFI boot/live session.
- [ ] Install to disposable virtual disk and boot installed system.
- [ ] Legal game fixture launch/exit/input/save restoration.
- [ ] Update/interruption/profile corruption/recovery tests.
- [ ] All screens/dialogs/scaling/controller focus reviewed.
- [ ] No personal data/secrets/test accounts in release output.
- [ ] Physical compatibility matrix has honest tested/untested results.
- [ ] Signing/Secure Boot status documented and tested if claimed.
- [ ] License inventory, notices, source obligations and Shoal license resolved.
- [ ] Exact source tag, ISO, hashes, manifests and known issues prepared.
- [ ] GitHub asset size/storage limits checked; public downloads verified.
- [ ] Preview published with VM-first instructions and previous-build recovery.

## Not required now

- Reinstalling the owner's PC or changing any existing app repository.
- Buying a domain, server, certificate or paid runner before a demonstrated need.
- Supplying personal access tokens or signing keys in chat.
- Choosing a specific device merely to continue hardware-neutral design.

There is no ISO workflow or bootable Shoal release yet. Update this checklist using actual evidence as engineering work completes.
