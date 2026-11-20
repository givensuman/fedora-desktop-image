#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="
set -euo pipefail

plymouth-set-default-theme spinner

# https://github.com/ublue-os/main/blob/main/build_files/initramfs.sh
KERNEL_VERSION="$(rpm -q --queryformat="%{evr}.%{arch}" kernel-core)"

# Ensure Initramfs is generated
export DRACUT_NO_XATTR=1
/usr/bin/dracut --no-hostonly --kver "${KERNEL_VERSION}" --reproducible -v --add ostree -f "/lib/modules/${KERNEL_VERSION}/initramfs.img"
chmod 0600 "/lib/modules/${KERNEL_VERSION}/initramfs.img"

echo "::endgroup::"
