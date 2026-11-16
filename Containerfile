FROM fedora as selinux

WORKDIR /selinux
COPY ./selinux /selinux

RUN dnf install -y selinux-policy-devel policycoreutils-devel && \
	make -f /usr/share/selinux/devel/Makefile nix.pp

FROM quay.io/fedora/fedora-bootc

RUN rpm-ostree install \
	nix nix-daemon

COPY ./files /

COPY --from=selinux /selinux/nix.pp /usr/share/selinux/packages/
RUN semodule -i /usr/share/selinux/packages/nix.pp

RUN systemctl enable nix-directory.service nix.mount

RUN bootc container lint
