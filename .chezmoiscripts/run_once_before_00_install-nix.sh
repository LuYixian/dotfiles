#!/bin/bash

set -eufo pipefail

if command -v nix >/dev/null 2>&1; then
    echo "✓ Nix already installed"
    exit 0
fi

echo "📦 Installing Nix..."

# Manual override: NIX_INSTALLER_BINARY_ROOT or NIX_INSTALLER_USE_MIRROR=1
if [[ -n "${NIX_INSTALLER_USE_MIRROR:-}" ]]; then
    echo "🌏 Using GitHub mirror (manual override)..."
    export NIX_INSTALLER_BINARY_ROOT="https://ghproxy.com/https://github.com/DeterminateSystems/nix-installer/releases/download"
elif [[ -z "${NIX_INSTALLER_BINARY_ROOT:-}" ]]; then
    echo "🔍 Detecting network environment..."

    # Check if in China: can reach Chinese mirror fast, but official source is slow
    CHINA_MIRROR_OK=false
    OFFICIAL_OK=false

    if curl -sS --connect-timeout 2 -m 3 https://mirrors.tuna.tsinghua.edu.cn >/dev/null 2>&1; then
        CHINA_MIRROR_OK=true
    fi

    if curl -sS --connect-timeout 3 -m 5 https://install.determinate.systems >/dev/null 2>&1; then
        OFFICIAL_OK=true
    fi

    # Use mirror if: official is slow, OR (in China region: Chinese mirror fast but official slow)
    if [[ "$OFFICIAL_OK" == "false" ]]; then
        if [[ "$CHINA_MIRROR_OK" == "true" ]]; then
            echo "🇨🇳 Detected China region, using GitHub mirror (ghproxy)..."
        else
            echo "🌏 Slow connection detected, using GitHub mirror..."
        fi
        export NIX_INSTALLER_BINARY_ROOT="https://ghproxy.com/https://github.com/DeterminateSystems/nix-installer/releases/download"
    fi
fi

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
