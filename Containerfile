# ---
# hadolint ignore=DL3007
FROM ghcr.io/givensuman/fedora-nix-image:latest AS nix
# hadolint ignore=DL3007
FROM ghcr.io/givensuman/fedora-akmods-image:latest

RUN dnf5 -y install nix nix-daemon && dnf5 clean all

COPY --from=nix /usr/lib/systemd/system/nix-directory.service \
                /usr/lib/systemd/system/nix.mount \
                /usr/lib/systemd/system/
COPY --from=nix /usr/share/selinux/packages/nix.pp /usr/share/selinux/packages/

RUN semodule -i /usr/share/selinux/packages/nix.pp && \
    systemctl enable nix-directory.service nix.mount nix-daemon.socket

COPY files/ /

COPY build/ /tmp/build/
RUN chmod +x /tmp/build/*.sh && \
    /tmp/build/desktop.sh && \
    /tmp/build/flatpak.sh && \
    rm -rf /tmp/build /tmp/* /var/cache/* /var/lib/dnf /var/log/dnf5.log* /run/dnf

RUN bootc container lint
