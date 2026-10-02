#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KERNEL_DIR="${ROOT_DIR}/kernel"
OUT_DIR="${ROOT_DIR}/out"

mkdir -p "${OUT_DIR}"

cat <<EOF
X6837 / MT6789 kernel audit scaffold

This script intentionally does not build a kernel on its own.
It validates the presence of the actual device source tree and prints a checklist.

Expected inputs:
- ${KERNEL_DIR}/Makefile
- ${KERNEL_DIR}/arch/arm64/
- ${KERNEL_DIR}/.config or vendor defconfig
- ${KERNEL_DIR}/Module.symvers

EOF

if [[ ! -d "${KERNEL_DIR}" ]]; then
  echo "[ERROR] Missing kernel source directory: ${KERNEL_DIR}"
  echo "Place the actual X6837 vendor kernel tree in ./kernel/ before continuing."
  exit 1
fi

if [[ ! -f "${KERNEL_DIR}/Makefile" ]]; then
  echo "[ERROR] Missing Makefile in ${KERNEL_DIR}"
  exit 1
fi

echo "[OK] Kernel source directory exists: ${KERNEL_DIR}"

echo "--- Kernel file checks ---"
for p in \
  "${KERNEL_DIR}/Makefile" \
  "${KERNEL_DIR}/arch/arm64" \
  "${KERNEL_DIR}/scripts" \
  "${KERNEL_DIR}/include"; do
  if [[ -e "$p" ]]; then
    echo "[OK] $p"
  else
    echo "[WARN] Missing: $p"
  fi
done

echo "--- Suggested next steps ---"
cat <<EOF
1. Confirm the kernel version with: make -C ${KERNEL_DIR} kernelversion
2. Inspect the device defconfig
3. Review CONFIG_MODULES, CONFIG_MODVERSIONS, CONFIG_CFG80211, CONFIG_MAC80211
4. Build the kernel only after the actual vendor configuration is confirmed
5. Build and verify the RTL88x2BU module against the exact Module.symvers
EOF
