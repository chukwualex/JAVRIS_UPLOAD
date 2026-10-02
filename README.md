# Infinix X6837 / MT6789 Custom Android Kernel Project

This repository is a structured audit-and-build project for a custom ARM64 Android kernel targeting the Infinix Hot 40 Pro (X6837) with MediaTek MT6789, optimized to support a Realtek RTL88x2BU USB Wi-Fi adapter for legitimate wireless security testing.

Important:
- This repo is the build framework and audit workspace.
- It does not include the vendor or device kernel source tree, which is typically proprietary or distributed separately by the manufacturer or from an upstream Android source tree.
- The actual kernel source/configuration must be added or mounted into this workspace before a full kernel build is possible.

## Objectives
- Audit the existing X6837/MT6789 kernel source and configuration
- Preserve all Android device functionality while adding modular USB Wi-Fi support
- Build a kernel compatible with the actual phone kernel ABI, Module.symvers, and vermagic
- Integrate the RTL88x2BU driver in a clean, reproducible way
- Validate monitor mode, packet capture, and injection capability when supported by hardware/driver

## Target hardware
- Phone: Infinix Hot 40 Pro
- Model: X6837
- SoC: MediaTek MT6789
- Architecture: ARM64 / aarch64
- Android-based Linux kernel around 5.10.x

## Planned deliverables
- Kernel source audit notes
- X6837-specific defconfig review
- RTL88x2BU driver integration plan
- Kernel build scripts
- Module verification scripts
- Installation workflow
- Monitor mode validation workflow

## Repo layout
```text
.
├── README.md
├── .gitignore
├── docs/
│   ├── x6837-audit-checklist.md
│   └── rtl88x2bu-integration.md
├── scripts/
│   ├── audit_kernel_tree.sh
│   ├── build.sh
│   ├── verify_vermagic.sh
│   ├── install_88x2bu.sh
│   └── validate_wireless.sh
├── patches/
│   └── README.md
├── drivers/
│   └── rtl88x2bu/
│       └── README.md
├── kernel/
│   └── README.md
└── out/
    └── .gitkeep
```

## Required external inputs
Before a real kernel build can succeed, the following must be available in this workspace or separately downloaded:

- X6837 vendor kernel source tree
- Generated `defconfig` or `vendor` config
- `Module.symvers` from the actual kernel build
- Kernel headers for the target Android tree
- Realtek RTL88x2BU driver source (e.g. `RinCat/RTL88x2BU-Linux-Driver`)
- ARM64 cross toolchain (LLVM/Clang or GCC cross toolchain)

## Current status
This repository is initialized as the project workspace and build harness. The next step is to import or mount the actual X6837 kernel source tree and audit it in place.

## Recommended workflow
1. Place the actual X6837 kernel source in `kernel/`
2. Run `scripts/audit_kernel_tree.sh`
3. Review `docs/x6837-audit-checklist.md`
4. Apply minimal compatibility patches under `patches/`
5. Build with `scripts/build.sh`
6. Verify with `scripts/verify_vermagic.sh`
7. Install the module with `scripts/install_88x2bu.sh`
8. Validate the adapter with `scripts/validate_wireless.sh`

## Legal and safety notice
This project is for legitimate research, development, and authorized wireless testing only. You must ensure compliance with local laws and test only on devices and networks you own or are authorized to evaluate.

## Notes about RTL88x2BU
- Realtek USB Wi-Fi support involves chip/driver compatibility with the target kernel
- The driver must match the exact kernel release, module symbol versions, and `Module.symvers`
- Monitor mode and injection support are driver- and firmware-dependent and should be validated explicitly, not assumed

## Next step
Open `docs/x6837-audit-checklist.md` and then run the audit script after placing the real X6837 kernel source into this repo.
