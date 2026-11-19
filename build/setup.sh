#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="
set -euo pipefail

dnf5 -y install dnf-plugins-core

dnf5 -y install sudo-rs
ln -sf sudo-rs /usr/bin/sudo
ln -sf sudo-rs /usr/bin/sudoedit
ln -sf visudo-rs /usr/bin/visudo
chmod 0440 /etc/sudoers.d/10-nix-path

echo "::endgroup::"
