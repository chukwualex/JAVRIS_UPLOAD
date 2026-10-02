#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KERNEL_DIR="${ROOT_DIR}/kernel"
MODULE_PATH="${KERNEL_DIR}/drivers/net/wireless/realtek/rtl88x2bu"

if [[ ! -d "${KERNEL_DIR}" ]]; then
  echo "[ERROR] Missing kernel tree at ${KERNEL_DIR}"
  exit 1
fi

if [[ ! -f "${KERNEL_DIR}/Module.symvers" ]]; then
  echo "[WARN] Module.symvers missing in ${KERNEL_DIR}; this is common before a build is generated."
  echo "[INFO] Run the kernel build first, then rebuild the driver against the generated Module.symvers."
  exit 0
fi

echo "[INFO] Kernel Module.symvers found: ${KERNEL_DIR}/Module.symvers"
echo "[INFO] Checking module build prerequisites..."

echo "[INFO] Verify with: modinfo <module>.ko | grep vermagic"

echo "[INFO] Verify with: file <module>.ko"

if [[ -d "${MODULE_PATH}" ]]; then
  echo "[OK] Candidate RTL88x2BU source directory found: ${MODULE_PATH}"
else
  echo "[WARN] Realtek RTL88x2BU source directory not yet present. Add the driver under drivers/rtl88x2bu or the vendor directory layout."
fi
