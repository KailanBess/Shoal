# Shoal development roadmap

All milestones below are planned; this repository currently contains design documentation only.

## 1. Build foundation

Select an initial CPU architecture and upstream GPU/device variants without promising universal hardware support. Pin the base image and source inputs; establish dependency license records and a reproducible image build in this repository. Do not modify existing app repositories or install anything on the development PC.

## 2. FishBowl-first prototype

Package an approved FishBowl Linux revision with attribution and required license/source material. Prototype launch from a normal desktop, then controller-first startup with a reliable desktop fallback. Test process exit, controller focus, missing drives and profile recovery. Qualify a dedicated gaming session separately.

## 3. PC and handheld experience

Provide shared styling and separate device profiles. Cover controller-only setup, touch keyboard, display scaling, audio, network and Bluetooth. Add supported power controls and battery status; qualify docking and repeated suspend/resume on actual hardware.

## 4. App integrations

Adapt Aquarium control-center functionality and optional FishNet/media tools within Shoal. Scope FishTank's Linux security functions separately from Windows-only protection. Preserve dependency boundaries and user data; do not assume Windows-protected secrets or window-hosting APIs transfer.

## 5. Recovery and preview release

Test boot, fallback, staged updates and rollback in VMs. Test games, input, graphics, storage, suspend and docking on named physical devices. Test interrupted profile writes and save restores. Document limitations and licenses, establish image signing/key ownership and publish clearly labeled preview artifacts only after acceptance checks pass.

A VM pass is not evidence of handheld compatibility. An OS rollback is not a user-data backup.
