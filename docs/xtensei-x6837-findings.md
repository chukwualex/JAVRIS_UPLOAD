# XTENSEI X6837 findings

This project is now aligned to the relevant XTENSEI repositories for the Infinix Hot 40 Pro (X6837) and the MT6789 platform family.

## Relevant repos
- XTENSEI/twrp_device_infinix_X6837
  - Recovery/device tree for the X6837
  - Confirms the board name, platform, and ARM64 architecture
- XTENSEI/android_device_tecno_mt6789-common
  - Shared MT6789 device configuration for other devices on the same platform

## Important finding
These repos are useful for device-tree and platform configuration, but they are not the actual Linux kernel source tree for a custom Android kernel build.

The actual kernel source still needs to be obtained separately from:
- the original vendor source tree,
- an upstream MediaTek/Android kernel mirror for the MT6789 platform,
- or a complete vendor/kernel bundle for X6837.

## Confirmed device facts
From the XTENSEI X6837 recovery tree:
- `TARGET_ARCH := arm64`
- `TARGET_BOARD_PLATFORM := mt6789`
- `TARGET_BOOTLOADER_BOARD_NAME := X6837`

Source: https://github.com/XTENSEI/twrp_device_infinix_X6837/blob/pbrp-12.1/BoardConfig.mk#L12-L45

## Why this matters
This gives us the correct platform identity for the kernel work:
- Board: X6837
- SoC: MT6789
- Architecture: ARM64
- Android build family: MediaTek MT6789

## Next step
The project should now proceed with a proper kernel-source audit using the actual X6837/MT6789 kernel source tree, not just the device-tree/recovery tree. The next build work should use:
1. the real vendor kernel source or an equivalent MT6789 kernel tree,
2. the exact defconfig for the device,
3. the generated Module.symvers and headers from that same build,
4. a matching RTL88x2BU driver build against the same kernel release.

## Notes for the custom Wi-Fi work
The recovery/device tree confirms the board is MT6789-based and ARM64, which is consistent with the required kernel build target. However, the Wi-Fi support itself still depends on the actual kernel tree and driver compatibility, especially: `CONFIG_MODULES`, `CONFIG_MODVERSIONS`, `CONFIG_CFG80211`, `CONFIG_MAC80211`, and the exact Realtek RTL88x2BU source compatibility with the selected kernel APIs.
