#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="
set -euo pipefail

CORE_PACKAGES=(
    git
    git-lfs
    dnf-plugins-core
)

dnf5 install -y "${CORE_PACKAGES[@]}"

dnf5 -y install sudo-rs
ln -sf sudo-rs /usr/bin/sudo
ln -sf sudo-rs /usr/bin/sudoedit
ln -sf visudo-rs /usr/bin/visudo
chmod 0440 /etc/sudoers.d/10-nix-path

dnf5 -y remove console-login-helper-messages-profile

systemctl mask systemd-remount-fs.service

echo "::endgroup::"
