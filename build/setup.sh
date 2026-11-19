#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="
set -euo pipefail

dnf5 -y install dnf-plugins-core

echo "::endgroup::"
