#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="
set -euo pipefail

dnf5 install -y @cosmic-desktop-environment
systemctl enable cosmic-greeter.service

dnf5 -y copr enable mjakeman/system76-scheduler
dnf5 -y install system76-scheduler
systemctl enable com.system76.Scheduler.service

DESKTOP_PACKAGES=(
    wl-clipboard
    age

    rsms-inter-fonts
    jetbrains-mono-fonts
    google-noto-fonts-all
)

dnf5 install -y "${DESKTOP_PACKAGES[@]}"

EXCLUDED_PACKAGES=(
    cosmic-store  # Prefer GTK alternatives
    cosmic-edit   # ""
    cosmic-player # ""
    cosmic-reader # ""
    # Prefer flatpak version
    firefox
    firefox-langpacks
)

for pkg in "${EXCLUDED_PACKAGES[@]}"; do
    if rpm -q "${pkg}" >/dev/null 2>&1; then
        dnf5 remove -y "${pkg}"
    fi
done

echo "::endgroup::"
