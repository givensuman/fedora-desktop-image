#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="
set -euo pipefail

dnf5 install -y --nogpgcheck \
    --repofrompath "terra,https://repos.fyralabs.com/terra\$releasever" \
    terra-release

dnf5 -y copr enable awood/bat-extras

CLI_PACKAGES=(
    direnv
    neovim
    chezmoi
    bat
    bat-extras
    bottom
    eza
    fd-find
    fish
    gh
    lazygit
    opencode
    ripgrep
    zoxide
)

GUI_PACKAGES=(
    ghostty
)

dnf5 install -y "${CLI_PACKAGES[@]}" "${GUI_PACKAGES[@]}"

dnf5 -y copr disable awood/bat-extras

echo "::endgroup::"
