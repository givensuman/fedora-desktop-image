set shell := ["bash", "-euo", "pipefail", "-c"]

export DOCKER_HOST := env("DOCKER_HOST", "unix://" + env("XDG_RUNTIME_DIR", "/run/user/1000") + "/podman/podman.sock")

default:
    @just --list

# Lint the Containerfile and shell scripts
lint:
    hadolint Containerfile
    shellcheck build/*.sh

# Build the image
build:
    podman build -t fedora-desktop-image:dev .

# Run the GitHub workflow
ci:
    systemctl --user start podman.socket
    act pull_request -j build
