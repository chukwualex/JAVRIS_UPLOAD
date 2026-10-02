# X6837 kernel audit checklist

This document is the step-by-step audit checklist for the Infinix Hot 40 Pro (X6837) kernel and its Android environment.

## 1. Identify the actual kernel source tree
Before building anything, confirm the exact source tree that matches the phone firmware.

Look for:
- `Makefile` with `VERSION`, `PATCHLEVEL`, `SUBLEVEL`
- `scripts/` and `arch/arm64/`
- vendor DTB, device tree source, and `defconfig`
- `Module.symvers` from the original build
- Android vendor-specific configs

## 2. Confirm architecture and kernel version
Run the following against the actual kernel tree:

```bash
make kernelversion
uname -r
cat Makefile | grep -E 'VERSION|PATCHLEVEL|SUBLEVEL'
```

Expected outcome:
- ARM64 / AArch64 target
- Linux 5.10.x family, matching the phone environment

## 3. Identify the defconfig
Use the device-specific config source rather than a generic kernel config.

Check for:
- `arch/arm64/configs/*`
- vendor config fragments
- build-generated config files
- shipping `defconfig`

## 4. Review wireless and USB configuration
The kernel must include the required Android-compatible wireless stack while retaining the rest of the phone functionality.

Inspect:
- `CONFIG_MODULES`
- `CONFIG_MODVERSIONS`
- `CONFIG_CFG80211`
- `CONFIG_MAC80211`
- `CONFIG_PACKET`
- `CONFIG_USB`
- `CONFIG_USB_SUPPORT`
- `CONFIG_USB_USBNET`
- `CONFIG_WEXT_CORE` where relevant

## 5. Find the actual `Module.symvers`
The final RTL88x2BU driver must build against the exact `Module.symvers` used by the phone kernel.

Check:
- `Module.symvers`
- `scripts/` and `include/generated/` headers
- `include/config/auto.conf`

## 6. Confirm Android ABI and build requirements
This is an Android kernel, so it will likely require:
- `CROSS_COMPILE`
- LLVM/Clang or GCC cross-toolchain
- correct `ARCH=arm64`
- vendor-specific dtb/dtbo generation
- Android kernel image output conventions

## 7. Driver compatibility review
Before editing the Realtek source, ensure it matches the current kernel APIs:
- `cfg80211`
- `mac80211`
- USB APIs
- `net_device`
- Android-specific compatibility

If the driver is incompatible, patch it minimally and document each change.

## 8. Build workflow
Recommended sequence:

```bash
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- x6837_defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- menuconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)
```

For Android/Clang-based toolchains, adapt to the vendor’s intended build flow.

## 9. Module verification requirements
Before declaring compatibility, verify all of the following:
- `88x2bu.ko` built for the same kernel release
- architecture matches `arm64`
- `modinfo 88x2bu.ko` shows matching `vermagic`
- `Module.symvers` matches the kernel build
- `lsmod` can load the module without fake vermagic bypasses

## 10. Wireless validation
Use standard Linux tooling:

```bash
lsusb
lsmod
dmesg | tail -n 100
ip link
iw phy
iw dev
```

Check for:
- adapter detected as `0bda:b812`
- Wi-Fi PHY enumerated
- monitor interface creation
- packet capture support
- injection capability support (if reported and permitted)

## 11. Recovery plan
Before flashing anything on the phone:
- keep the original boot image
- verify your custom kernel build artifacts independently
- prepare a known-good recovery path
- validate on lab hardware or a safe environment first

## 12. Reporting
Document each compatibility patch and each configuration change so the source can be reproduced and audited.

## 13. Final acceptance criteria
The kernel project is only considered suitable when all of the following are true:
- ARM64 build is successful
- defconfig is the actual device config
- `88x2bu.ko` has matching vermagic and symbol versions
- module loads without forced bypasses
- USB Wi-Fi adapter is detected
- wireless PHY exists
- monitor mode and packet capture are validated
- normal phone functions remain intact

## 14. Missing required data
If the actual vendor kernel source or Android tree is not available, stop and collect the exact source before modifying configuration or driver code. Do not build against a random kernel tree or a generic desktop kernel.
