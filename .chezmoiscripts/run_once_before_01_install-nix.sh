#!/bin/bash

set -eufo pipefail
# Install or update Nix
if ! command -v nix >/dev/null 2>&1; then
    printf "📦 Nix not installed. Installing.\n"
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
fi
