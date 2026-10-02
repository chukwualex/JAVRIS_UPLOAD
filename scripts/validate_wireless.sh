#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${ROOT_DIR}/out"

mkdir -p "${OUT_DIR}"

echo "[INFO] Wireless validation workflow"
cat <<EOF
lsusb
lsmod | grep 88x2bu || true
ip link
iw phy
iw dev
sudo iw dev wlan0 interface add mon0 type monitor
ip link show mon0
sudo tcpdump -i mon0 -n -vvv -c 20
EOF

echo "[INFO] This validates detection, PHY enumeration, and monitor mode availability."
