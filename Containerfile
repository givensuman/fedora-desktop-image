# ---
# hadolint ignore=DL3007
FROM ghcr.io/givensuman/fedora-akmods-image:latest AS akmods
# hadolint ignore=DL3007
FROM ghcr.io/givensuman/fedora-nix-image:latest AS nix

FROM quay.io/fedora/fedora-bootc

COPY --from=akmods /usr/share/modules/akmods /tmp/modules/akmods
COPY --from=nix /usr/share/modules/nix /tmp/modules/nix
RUN /tmp/modules/akmods/apply.sh && \
    /tmp/modules/nix/apply.sh && \
    rm -rf /tmp/modules

COPY files/ /

COPY build/ /tmp/build/
RUN chmod +x /tmp/build/*.sh && \
    /tmp/build/desktop.sh && \
    /tmp/build/flatpak.sh && \
    rm -rf /tmp/build /tmp/* /var/cache/* /var/lib/dnf /var/log/dnf5.log* /run/dnf

RUN bootc container lint
