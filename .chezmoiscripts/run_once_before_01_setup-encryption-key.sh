#!/bin/bash
# Setup encryption key before chezmoi can decrypt files
set -euo pipefail

# Source nix environment
if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Install age if not available (required for chezmoi to decrypt .age files)
if ! command -v age &>/dev/null; then
    echo "📦 Installing age..."
    nix profile install nixpkgs#age
fi

# Install 1password-cli if not available
if ! command -v op &>/dev/null; then
    echo "📦 Installing 1password-cli..."
    nix profile install nixpkgs#_1password-cli
fi

KEY_FILE="$HOME/.ssh/main"
KEY_PUB="$HOME/.ssh/main.pub"

if [[ -f "$KEY_FILE" ]]; then
    echo "✓ Encryption key already exists: $KEY_FILE"
    exit 0
fi

echo "Encryption key not found: $KEY_FILE"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Try 1Password CLI
if command -v op &>/dev/null; then
    # Check: service account token, desktop app integration, or manual signin
    if [[ -n "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]] || op account list &>/dev/null; then
        echo "Fetching key from 1Password..."
        if op read "op://Personal/main/private key?ssh-format=openssh" 2>/dev/null | tr -d '\r' > "$KEY_FILE.tmp"; then
            mv "$KEY_FILE.tmp" "$KEY_FILE"
            op read "op://Personal/main/public key" > "$KEY_PUB"
            chmod 600 "$KEY_FILE"
            chmod 644 "$KEY_PUB"
            echo "✓ Key imported from 1Password"
            exit 0
        else
            rm -f "$KEY_FILE.tmp"
            echo "⚠ Failed to fetch from 1Password"
        fi
    fi
fi

# Manual setup required
echo ""
echo "Please set up your encryption key using one of these methods:"
echo ""
echo "1. Copy manually:"
echo "   scp ~/.ssh/main ~/.ssh/main.pub user@this-machine:~/.ssh/"
echo ""
echo "2. Use 1Password desktop app integration:"
echo "   Open 1Password → Settings → Developer → Enable CLI integration"
echo "   Then run: chezmoi apply"
echo ""
echo "3. Use 1Password service account (for servers):"
echo "   export OP_SERVICE_ACCOUNT_TOKEN='your-token'"
echo "   chezmoi apply"
echo ""
exit 1
