#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${ROOT_DIR}/out"

mkdir -p "${OUT_DIR}"

echo "[INFO] Installation workflow scaffold"
echo "[INFO] Place the final 88x2bu.ko into a safe module directory and load it with the Android kernel's module path."

echo "[INFO] Example workflow:"
cat <<EOF
adb shell
su
mkdir -p /system/lib/modules/$(uname -r)/extra/
cp /sdcard/88x2bu.ko /system/lib/modules/$(uname -r)/extra/
depmod -a
modprobe 88x2bu
lsmod | grep 88x2bu
EOF

echo "[INFO] Validation commands:"
echo "lsusb"
echo "dmesg | tail -n 100"
echo "ip link"
echo "iw phy"
echo "iw dev"
