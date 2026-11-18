# Shoal development roadmap

All milestones below are planned; this repository currently contains design documentation only. Follow the [step-by-step build guide](BUILD-GUIDE.md) for the full sequence and responsibilities, and the [project checklist](CHECKLIST.md) for evidence-based progress.

## 1. Build foundation

Use CachyOS as the selected base. Select build architectures and CPU/GPU/device requirements without promising universal compatibility. Pin the upstream CachyOS-Live-ISO revision and maintain Shoal ISO profiles and package definitions here. Record repository/package inputs and license obligations; validate builds on a supported Linux builder before claiming reproducibility. Do not modify existing app repositories or install anything on the development PC.

## 2. FishBowl-first prototype

Package an approved FishBowl Linux revision with attribution and required license/source material. Prototype launch from a normal desktop, then controller-first startup with a reliable desktop fallback. Test process exit, controller focus, missing drives and profile recovery. Qualify a dedicated gaming session separately.

## 3. PC and handheld experience

Provide shared styling and separate device profiles. Cover controller-only setup, touch keyboard, display scaling, audio, network and Bluetooth. Add supported power controls and battery status; qualify docking and repeated suspend/resume on actual hardware.

## 4. App integrations

Adapt Aquarium control-center functionality and optional FishNet/media tools within Shoal. Scope FishTank's Linux security functions separately from Windows-only protection. Preserve dependency boundaries and user data; do not assume Windows-protected secrets or window-hosting APIs transfer.

## 5. Recovery and preview release

Test ISO boot/install, fallback, full pacman upgrades, interrupted transactions and documented recovery in VMs. Qualify Btrfs snapshot coverage and boot/kernel restoration; do not assume immutable-image or atomic rollback behavior. Test games, input, graphics, storage, suspend and docking on named physical devices. Test interrupted profile writes and save restores. Document limitations and licenses, establish ISO/package signing and key ownership and publish clearly labeled preview artifacts only after acceptance checks pass.

A VM pass is not evidence of handheld compatibility. An OS rollback is not a user-data backup.
