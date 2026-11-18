# Shoal OS — initial design

Status: design proposal, not a bootable or released operating system.
Date: 2026-11-18
Hardware target: hardware-neutral design for PCs and handhelds, selected by the user. No CPU architecture, GPU vendor or specific device is selected or certified. Architecture-specific builds and physical qualification will be required before compatibility claims.

Repository boundary: this is a new, separate repository. Do not change Aquarium, FishBowl, FishNet, FishTank or their existing repositories for this project. Reference existing public releases/source revisions as external inputs. Any Linux adaptations needed for the OS must initially live in the new repository, with dependency licenses respected. Existing app update/release workflows remain independently owned.

## Product

A controller-friendly Linux gaming distribution centered on emulation and the Aquarium app family. Boot into FishBowl's living-room interface, with a normal desktop available for setup, media and troubleshooting. Preserve keyboard/mouse access and a recovery route if the gaming interface fails.

## Foundation

Proposed base: a custom Bazzite-derived image built using the upstream image template. Select the specific base, GPU variant and immutable digest only after choosing the first hardware target. Keep upstream driver and security maintenance rather than maintaining a new kernel or driver stack.

Use KDE Plasma for the desktop initially. Prototype FishBowl autostart in a normal desktop session first; qualify a dedicated Gamescope session separately. Existing Steam Gaming Mode is Steam-centered and must not be presented as a ready-made FishBowl session.

## Existing app integration

| Component | Intended OS role | Required work |
| --- | --- | --- |
| FishBowl Linux | Main game library, emulator routing, save snapshots and living-room browsing | Controller-only setup, compositor/session integration, exit/crash recovery and hardware qualification. Linux currently launches emulators externally; Windows embedded Play is not portable. |
| Aquarium | Suite control center: apps, updates, appearance and recovery | Native Linux UI and platform services; existing WinUI application cannot be shipped as a native Linux app unchanged. Reuse portable models/validation only after dependency review. |
| FishNet | Optional media center | Linux UI and playback backend, codecs, output selection and conversion qualification. Existing Windows media APIs require replacement. |
| FishTank | Optional Linux security/recovery companion | Define Linux-specific protection evidence and authenticated recovery; Windows Defender, DPAPI and Windows policy integrations cannot be reused as Linux protection. Do not transfer Windows-protected secrets automatically. |
| File Organizer | Optional file utilities | Port UI and filesystem behavior, case sensitivity, links, permissions and safe cross-filesystem moves. |
| Device Inventory | Optional hardware records | Port UI/storage and implement explicit Linux hardware inspection separately. |
| Workspace Launcher | Optional desktop workspace tools | Port app discovery; window positioning needs compositor-specific support and may be restricted on Wayland. |

## First usable version

Support two device profiles built from a shared product configuration:

- PC/living-room: keyboard/mouse and controller navigation, multiple displays, TV scaling, external audio and optional controller-first startup.
- Handheld: controller-only first-run setup, touch/on-screen keyboard, small-screen scaling, battery status, supported power/performance controls, suspend/resume and docking/undocking.

Keep user libraries and portable app records compatible across profiles. Device-specific bindings, display configuration and power settings remain local. GPU-specific base images may be needed; a common interface does not imply one image supports every device. Qualify one PC and one specific handheld before expanding the supported-device list. Do not advertise all handhelds as supported.

1. Reproducible image project with pinned inputs, license inventory and build provenance.
2. FishBowl Linux installed with a controller-friendly entry point, desktop fallback and crash recovery.
3. First-run controller, display, audio, network and storage setup using established system components.
4. Reviewed emulator installation through trusted supported packages; no automatic game, firmware or key downloads.
5. User-selected library/save locations with readable missing-drive states and export/restore instructions.
6. OS update staging, reboot indication and previous-system rollback through the base's supported updater.
7. Clear distinction between system rollback and user-data recovery: rolling back the OS does not restore saves or undo profile migrations.
8. Unified appearance and consistent controller focus, scaling, dialogs and error states.

## Update ownership

The base image owns kernel, GPU drivers, desktop/compositor and system packages. Image-bundled apps update with that image. Optional user apps use one chosen application packaging/update mechanism. Aquarium must delegate to those owners and never replace an image-owned executable with its Windows ZIP updater. Serialize system transactions and report app updates separately from reboot-required OS updates.

## Release acceptance

- VM: image boot, login, desktop fallback, first-run recovery, update and rollback. VM results do not qualify physical gaming performance.
- Real selected hardware: graphics/Vulkan, audio, controller hotplug, Bluetooth, suspend/resume, external screens and storage removal.
- Handheld acceptance: controller-only setup and recovery, touch keyboard, readable small-screen dialogs, battery reporting, supported power controls, repeated suspend/resume during games and dock/undock display/audio/input transitions. Preserve access to upstream controls until replacements pass these checks.
- Games: documented homebrew/test fixtures; emulator launch/exit, focus, save restore and controller navigation.
- Security: trusted update chain, image signing/key ownership, least-privilege helpers and no default remote administration.
- User data: interrupted writes, corrupt profiles, profile migration, backup restoration and unavailable drives.
- Distribution: review every bundled dependency's license, redistribution conditions, notices/source obligations and branding. Include only content with redistribution permission.

Do not install, repartition, change boot settings or modify the user's installed apps as part of source/design development. An installer or disk-image release must explicitly state its tested hardware and known limitations.

## Sources

- Bazzite custom image guidance: https://docs.bazzite.gg/Advanced/creating_custom_image/
- Bazzite hardware/image selection: https://docs.bazzite.gg/General/FAQ/
- Bazzite Gaming Mode overview: https://docs.bazzite.gg/Handheld_and_HTPC_edition/Steam_Gaming_Mode/
- Windows UI framework platform: https://learn.microsoft.com/windows/apps/winui

## Next decision

PC and handheld scope is confirmed, with hardware-neutral planning. Establish the project in a new repository, keeping all current repositories unchanged. Choose concrete build targets and test devices later, before claiming bootable-image or physical-device compatibility. Qualify a FishBowl-first prototype before adapting the remaining apps. Shoal OS is the selected project name. Trademark and domain availability have not been checked.
