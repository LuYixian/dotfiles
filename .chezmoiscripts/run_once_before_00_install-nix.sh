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

    # Test actual download speed (not just connectivity)
    # Download small file and check if speed > 100KB/s
    SPEED=$(curl -sS --connect-timeout 3 -m 10 -w '%{speed_download}' -o /dev/null https://install.determinate.systems/nix 2>/dev/null || echo "0")
    # speed_download is in bytes/sec, 100KB/s = 102400
    if awk "BEGIN {exit !($SPEED > 102400)}"; then
        OFFICIAL_OK=true
        echo "   Official source speed: $(awk "BEGIN {printf \"%.0f\", $SPEED/1024}") KB/s ✓"
    else
        echo "   Official source speed: $(awk "BEGIN {printf \"%.0f\", $SPEED/1024}") KB/s (slow)"
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
