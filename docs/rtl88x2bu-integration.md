# RTL88x2BU integration notes

This file captures the intended integration path for the Realtek RTL88x2BU USB Wi‑Fi adapter on the X6837/MT6789 kernel.

## 1. Driver source
Use the correct Realtek driver source for the target platform. The most common public source is the `RinCat/RTL88x2BU-Linux-Driver` project, but compatibility must be checked against the actual kernel tree, not assumed.

## 2. Vendor kernel compatibility
Very common failure mode:
- kernel build is successful for one release
- driver is compiled against a different kernel version
- `vermagic` mismatch occurs
- `modinfo` and `insmod` fail or the module behaves inconsistently

The final driver must be compiled with:
- exact kernel release
- exact `Module.symvers`
- same generated headers
- same `CONFIG_MODVERSIONS`
- same architecture (ARM64)

## 3. Required config options
Inspect and confirm these options, depending on the actual driver release and kernel version:

```text
CONFIG_MODULES=y
CONFIG_MODVERSIONS=y
CONFIG_CFG80211=y
CONFIG_MAC80211=y
CONFIG_USB=y
CONFIG_USB_SUPPORT=y
CONFIG_PACKET=y
```

Additional options may be required by the specific driver tree; do not invent them blindly. Inspect the driver’s `Kconfig`, `Makefile`, and `include` requirements.

## 4. Build process
Recommended approach:

1. Configure the actual X6837 kernel tree
2. Generate or restore the device defconfig
3. Build the kernel image and modules
4. Build the `88x2bu` module against the same tree
5. Check `modinfo` and `vermagic`
6. Install only if compatible

## 5. Monitor mode and packet injection
Monitor mode and injection are not guaranteed by compilation alone. They depend on:
- cfg80211/mac80211 support
- adapter driver support
- firmware capability
- USB host stack behavior
- Android restrictions or kernel options

The validation must be explicit and performed with standard tooling such as:
- `iw phy`
- `iw dev`
- `iw dev wlanX set monitor control`
- `tshark`
- `tcpdump`
- `airodump-ng`

## 6. Security testing requirement
This project is for legitimate, authorized wireless security testing. It is not a bypass of device controls or an attempt to interfere with unauthorized networks.

## 7. Practical note
Do not flash a random Kali or desktop Linux kernel onto the phone. The device must retain its normal Android boot and phone functionality while adding external USB Wi-Fi connectivity.
