#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="
set -euo pipefail

mkdir -p /etc/systemd/system

# Create flatpak-preinstall.service
# https://github.com/ublue-os/bluefin/blob/main/system_files/shared/usr/lib/systemd/system/flatpak-preinstall.service
cat <<\EOF >>/etc/systemd/system/flatpak-preinstall.service
[Unit]
Description=Preinstall Flatpaks
After=network-online.target
Wants=network-online.target
ConditionPathExists=/usr/bin/flatpak
Documentation=man:flatpak-preinstall(1)
StartLimitIntervalSec=600

[Service]
Type=oneshot
ExecStart=/usr/bin/flatpak preinstall -y --ostree-verbose
RemainAfterExit=true
Restart=on-failure
RestartSec=30

StartLimitBurst=3

[Install]
WantedBy=multi-user.target
EOF

systemctl enable flatpak-preinstall.service

# https://man.archlinux.org/man/extra/flatpak/flatpak-preinstall.1.en
mkdir -p /etc/flatpak/preinstall.d

PREINSTALL_FILE="/etc/flatpak/preinstall.d/fedora-desktop.preinstall"
touch $PREINSTALL_FILE

DESKTOP_FLATPAKS=(
    org.mozilla.firefox
    io.podman_desktop.PodmanDesktop
    com.spotify.Client
    io.github.milkshiift.GoofCord
    de.haeckerfelix.Fragments
    org.nickvision.tubeconverter
    com.obsproject.Studio
    org.kde.kdenlive
    org.blender.Blender
    org.inkscape.Inkscape
    org.gimp.GIMP
    org.localsend.localsend_app
    org.freecad.FreeCAD
    com.mojang.Minecraft
)

GTK_FLATPAKS=(
    org.gtk.Gtk3theme.adw-gtk3
    org.gtk.Gtk3theme.adw-gtk3-dark
    io.github.kolunmi.Bazaar
    org.gnome.baobab
    org.gnome.Boxes
    org.gnome.Calendar
    org.gnome.Characters
    org.gnome.clocks
    org.gnome.Contacts
    org.gnome.Firmware
    org.gnome.font-viewer
    org.gnome.Logs
    org.gnome.Loupe
    org.gnome.Maps
    org.gnome.Papers
    org.gnome.Showtime
    org.gnome.Snapshot
    org.gnome.TextEditor
    org.gnome.Weather
)

GTK_RUNTIMES=(
    org.freedesktop.Platform//25.08
)

UTILS_FLATPAKS=(
    com.github.tchx84.Flatseal
    io.github.flattool.Warehouse
    io.github.flattool.Ignition
)

# ---

FLATPAKS=(
    "${DESKTOP_FLATPAKS[@]}"
    "${GTK_FLATPAKS[@]}"
    "${UTILS_FLATPAKS[@]}"
)

RUNTIMES=(
    "${GTK_RUNTIMES[@]}"
)

sep=""
for entry in "${FLATPAKS[@]}"; do
    printf '%s[Flatpak Preinstall %s]\nBranch=stable\n' \
        "$sep" "$entry" >>"$PREINSTALL_FILE"
    sep=$'\n'
done

for entry in "${RUNTIMES[@]}"; do
    printf '%s[Flatpak Preinstall %s]\nBranch=%s\nIsRuntime=true\n' \
        "$sep" "${entry%%//*}" "${entry##*//}" >>"$PREINSTALL_FILE"
done

echo "::endgroup::"
