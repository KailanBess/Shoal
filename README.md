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

## Built-in Linux applications

The complete Shoal system will include Linux editions of **Aquarium, FishBowl, FishNet, FishTank, File Organizer, Device Inventory and Workspace Launcher**. These are built-in OS applications, with Linux packaging and adaptations maintained here. FishBowl-first prototypes are intermediate milestones, not the complete suite. See [Linux editions and acceptance requirements](docs/LINUX-APPS.md). These editions are not all implemented yet.

Existing apps retain their names and established shell/UI designs; the work is to port them to Linux. New apps and system interfaces use fish, ocean or body-of-water themed names and visuals. See the [naming and visual direction](docs/LINUX-APPS.md#naming-and-visual-direction).

## Project boundaries

Shoal is a separate project. Existing Aquarium, FishBowl, FishNet and FishTank repositories and release workflows remain unchanged. Reference their public releases or pinned source as external dependencies; keep Shoal-specific integration and adaptations here.

FishBowl already has a Linux application. Aquarium, FishNet, FishTank and the smaller Windows tools require platform review and Linux adaptations before inclusion. Their existing Windows functionality is not automatically available on Linux.

The selected foundation is **CachyOS**, with Shoal-specific ISO profiles, packages and integration maintained in this repository. Desktop and handheld configurations share the product design; hardware-neutral planning does not override upstream CPU requirements or certify every device. Pin upstream ISO-builder revisions and record package versions before releasing builds. No games, console BIOS, console firmware, keys or other content without redistribution permission are included.

## Documentation

Start with the [step-by-step build guide](docs/BUILD-GUIDE.md): it lists owner setup, Codex implementation work, prerequisites and acceptance evidence in order. Track progress in the [project checklist](docs/CHECKLIST.md). These documents do not indicate that an ISO or workflow has been built.

- [System design and app integration](docs/DESIGN.md)
- [Development roadmap](docs/ROADMAP.md)

System packages use CachyOS/Arch's pacman update model, with complete system upgrades rather than partial upgrades. Shoal must not overwrite package-owned apps through a separate ZIP updater. Btrfs recovery depends on the selected filesystem, snapshot coverage and boot configuration; it is not an atomic image update or a backup of user saves.

Upstream references: [CachyOS ISO builder](https://github.com/CachyOS/CachyOS-Live-ISO), [Handheld Edition](https://wiki.cachyos.org/installation/installation_handheld/) and [snapshot recovery](https://wiki.cachyos.org/configuration/btrfs_snapshots/).
