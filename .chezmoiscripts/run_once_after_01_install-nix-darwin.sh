#!/bin/bash

set -eufo pipefail
# Install or update Nix
if ! command -v darwin-version >/dev/null 2>&1; then
    printf "📦 nix-darwin not installed. Installing.\n"
    nix run nix-darwin/master#darwin-rebuild --extra-experimental-features "nix-command flakes"  -- switch --flake ~/nix-config#summit
fi
