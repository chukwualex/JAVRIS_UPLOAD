#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KERNEL_DIR="${ROOT_DIR}/kernel"
OUT_DIR="${ROOT_DIR}/out"

mkdir -p "${OUT_DIR}"

if [[ ! -d "${KERNEL_DIR}" ]]; then
  echo "[ERROR] Missing kernel source tree at ${KERNEL_DIR}"
  exit 1
fi

if [[ ! -f "${KERNEL_DIR}/Makefile" ]]; then
  echo "[ERROR] Missing Makefile in ${KERNEL_DIR}"
  exit 1
fi

echo "[INFO] Building X6837 kernel project scaffold"

echo "[INFO] This repo does not contain the vendor kernel source, so this build script is intentionally conservative."

echo "[INFO] Place the actual X6837 kernel tree in ${KERNEL_DIR} before running full builds."

echo "[INFO] Expected outputs: Image, DTB/DTBO, modules, 88x2bu.ko, Module.symvers"

echo "[INFO] Build command placeholders:"
cat <<EOF
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- x6837_defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules
EOF

exit 0
