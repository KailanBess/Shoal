# Built-in Linux app editions

Confirmed product requirement: Shoal includes Linux editions of Aquarium, FishBowl, FishNet, FishTank, File Organizer, Device Inventory and Workspace Launcher as OS applications. They are not merely links to Windows downloads.

Status: integration requirements only. FishBowl already has upstream Linux source; Shoal packaging/integration is pending. The other editions are not implemented in this repository yet.

## Naming and visual direction

- Existing apps keep their current names and established shell/UI designs: Aquarium, FishBowl, FishNet, FishTank, File Organizer, Device Inventory and Workspace Launcher. Their immediate requirement is a Linux port, not a rename or visual redesign.
- Preserve existing navigation, useful features, appearance options and recognizable layout when porting. Replace Windows-specific APIs and controls with Linux-capable implementations while retaining the established design and behavior wherever practical.
- Newly created Shoal apps and system interfaces use fish, ocean or body-of-water themed names and visual identities. Proposed names must be checked before public branding; no availability is implied.
- New shells, setup pages and dialogs should follow the aquatic direction through a coherent palette, iconography and restrained imagery. Keep labels readable and descriptive, with visible focus, adequate contrast and reduced-motion support.
- Shared integration must respect existing app customization. Do not silently overwrite established themes or force an app redesign to match new OS artwork.
- Linux platform limitations and necessary adaptations remain documented in each feature ledger; visual similarity alone is not feature completion.

## Ownership and delivery

- All Shoal integration, Linux adaptations and packaging remain in this repository. Do not modify existing app repositories or Windows releases.
- Reference pinned external source/releases, with attribution and license/source obligations. Review reuse before copying code.
- Install the Linux applications into the installed OS, with desktop entries and appropriate package dependencies. Test the live ISO separately; live-only shortcuts do not satisfy installed-system delivery.
- Use CachyOS/Arch packages as the system-app update owner. Aquarium presents updates by delegating to package management; it does not replace package-owned programs from ZIP downloads.
- Native Linux implementations are the target. Launching a Windows executable through Wine is not completion of a Linux edition.
- Built-in means installed and available, not running continuously. Do not autostart media playback, security scans, listeners or file operations.
- Keep per-user records writable outside program directories, with separate ownership for settings, data and caches. Never require root just to open an app.
- Use a consistent visual system across every page, dialog, menu and error state. Support keyboard, mouse, controller focus and handheld scaling where relevant.

## Applications and acceptance

| Linux edition | Built-in role | Required acceptance before describing it as working |
| --- | --- | --- |
| Aquarium | OS control center and app management | Native Linux interface; package-manager delegation, truthful update/reboot states, appearance, reviewed record backups and recovery. System updates and user-data backups remain distinct. |
| FishBowl | Main gaming interface | Package existing Linux implementation; controller-first navigation, emulator launch/exit/focus, save snapshots/restore, missing-drive handling and desktop fallback. Windows embedded Play requires separate Linux design, not assumed parity. |
| FishNet | Music, videos and media library | Native Linux interface and playback backend; libraries, playlists, subtitles, supported conversion and output selection; accurate codec/format failures. Test intended formats rather than promising every file works. |
| FishTank | Linux security and authenticated recovery | Linux-specific health evidence, permission boundaries, protected storage/recovery and redacted diagnostics. Review security design before migration of secrets; do not claim Windows Defender/DPAPI features are Linux protection. |
| File Organizer | File organization | Previewed renames/moves, overwrite refusal, linked-path/permission checks, case-sensitive handling, cross-filesystem failure recovery and safe cancellation. |
| Device Inventory | Device and maintenance records | Devices, serials, warranty/receipt references and maintenance records; separate reviewed Linux hardware collection if provided. External receipt files are not silently bundled in record backups. |
| Workspace Launcher | Desktop workspaces | Review and launch supported Linux applications; report missing targets and restricted compositor behavior. Do not promise arbitrary Wayland window placement. |

## Feature parity ledger

For each app, create a feature ledger before porting. Each row must identify:

1. Existing user-facing capability and source revision.
2. Linux implementation or clearly explained platform equivalent.
3. State: planned, implemented, tested, platform-limited or intentionally excluded with explanation.
4. Verification evidence and known limitations.
5. Data-format/migration implications and recovery path.

The aim is to retain useful existing behavior. Do not silently remove features or substitute decorative controls. Linux-specific limitations should be visible in documentation and relevant UI.

## Shared integration work

1. Document the existing apps' names, shells, navigation and appearance as the porting baseline. Define aquatic naming and visual rules for new apps/system surfaces without redesigning the existing apps.
2. Review a Linux-capable UI framework and platform-service boundary before committing to the ports. A specific framework has not been selected.
3. Reuse portable models/validation only after checking Windows dependencies and compiler/runtime compatibility.
4. Design per-user data paths, profile leases, bounded reads, atomic saves, unknown-field preservation and corrupt-file recovery.
5. Define versioned import/export. Preserve the original record before migration; Windows paths need explicit mapping and Windows-protected secrets may require reenrollment.
6. Package each app and its dependencies with a single update owner. Audit duplicate runtimes, codecs and privileged helpers.
7. Keep privileged system tasks behind narrow authenticated interfaces. Do not run the full suite as root.
8. Add app tests plus suite tests for switching apps, dialogs, startup, shutdown, updates, profile recovery and handheld interaction.
9. Verify installed-system persistence across reboot and updates.
10. Publish accurate Linux capability and compatibility tables with each preview.

## Milestones

- **Prototype:** CachyOS baseline plus existing FishBowl Linux; demonstrates the boot/session pipeline. Other apps may still be absent and must be listed as pending.
- **Integrated preview:** working Linux app packages are added incrementally with explicit capability ledgers. An incomplete preview must not imply that all seven editions are present.
- **Complete suite acceptance:** all seven editions are installed, usable and tested within the OS, with platform differences documented.

The first ISO prototype is not the finished product. The final integrated suite requirement remains all seven Linux editions.
