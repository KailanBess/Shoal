# Shoal

Your games. One current.

Shoal OS is a planned fish-themed Linux gaming distribution for PCs and handhelds, centered on emulation and the Aquarium app family.

**Status: early design. No bootable image, installer or supported-device certification is available yet.** Hardware-neutral planning does not mean compatibility with every device or CPU architecture.

## Experience

- FishBowl as the controller-friendly game library and living-room interface.
- A normal desktop for setup, media and troubleshooting.
- Consistent appearance, controller navigation and readable dialogs.
- Separate PC and handheld profiles, with touch, battery and docking support planned for handhelds.
- Reviewed emulator setup, save recovery and system updates with rollback.

## Project boundaries

Shoal is a separate project. Existing Aquarium, FishBowl, FishNet and FishTank repositories and release workflows remain unchanged. Reference their public releases or pinned source as external dependencies; keep Shoal-specific integration and adaptations here.

FishBowl already has a Linux application. Aquarium, FishNet, FishTank and the smaller Windows tools require platform review and Linux adaptations before inclusion. Their existing Windows functionality is not automatically available on Linux.

The proposed foundation is a custom Bazzite-derived image. The base variant, architecture and pinned image must be selected before implementing an image build. No games, proprietary firmware, keys or unlicensed content are included.

## Documentation

- [System design and app integration](docs/DESIGN.md)
- [Development roadmap](docs/ROADMAP.md)

OS updates must use the base system's update mechanism. Image-owned apps must not be overwritten by a separate ZIP updater. System rollback is distinct from restoring user saves and settings.
