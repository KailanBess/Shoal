# Verified CachyOS reference images

Verified on 2026-11-18 by reading the supplied local files and computing SHA-256. No image was mounted, booted, installed, modified or uploaded to GitHub. Local filesystem paths are intentionally omitted.

| Reference image | Size (bytes) | SHA-256 | Result |
| --- | ---: | --- | --- |
| cachyos-desktop-linux-260809.iso | 3188850688 | `959f6577f45e25ee9fd8c220fd221b08e4ea79412c7315c0f922dd6d86d5e33c` | Matches official published checksum |
| cachyos-handheld-linux-260628.iso | 2664595456 | `0567c61f21622e5b4b482a874c41076beeb9bd8c00f046fa40e5c8cfbe34d15f` | Matches official published checksum |

Desktop comparison source: [CachyOS Downloads and Validation](https://wiki.cachyos.org/cachyos_basic/download/), which explicitly lists the 260809 filename/hash. Handheld comparison source: [CachyOS CDN checksum for 260628](https://cdn.cachyos.org/ISO/handheld/260628/cachyos-handheld-linux-260628.iso.sha256), retrieved directly as text.

This verifies consistency with published upstream checksums. Detached GPG signatures have not been verified here. No claim of bootability, installed-system safety, hardware compatibility or absence of vulnerabilities follows from a checksum match.

## Use in Shoal

These are CachyOS reference images, not Shoal builds. They can support a later disposable VM comparison of desktop and handheld behavior. Their dates differ from each other and from the pinned ISO-builder revision; they are not proof that the locked source reproduces these binaries. They do not replace the pending baseline build, app integration, installer validation or physical-device tests.

Source locking and validation are described in [the foundation report](FOUNDATION.md). Any VM boot or installation is separate work and has not occurred during this verification.
