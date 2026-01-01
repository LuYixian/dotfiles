#!/bin/sh
# shellcheck shell=dash
# Nix installer with automatic mirror selection for chezmoi

set -u

NIX_INSTALLER_VERSION="${NIX_INSTALLER_VERSION:-v3.15.1}"
GITHUB_RELEASE="https://github.com/DeterminateSystems/nix-installer/releases/download/${NIX_INSTALLER_VERSION}"
GHPROXY_RELEASE="https://ghproxy.com/${GITHUB_RELEASE}"

# --- Logging ---

info()  { printf '\033[1;32minfo:\033[0m %s\n' "$1" >&2; }
warn()  { printf '\033[1;33mwarn:\033[0m %s\n' "$1" >&2; }
error() { printf '\033[1;31merror:\033[0m %s\n' "$1" >&2; }
die()   { error "$1"; exit 1; }

# --- Architecture detection (handles Rosetta 2) ---

get_arch() {
    local os cpu
    os=$(uname -s)
    cpu=$(uname -m)

    # macOS: detect real arch behind Rosetta
    if [ "$os" = "Darwin" ] && [ "$cpu" = "x86_64" ]; then
        if sysctl -n hw.optional.arm64 2>/dev/null | grep -q '1'; then
            cpu="arm64"
        fi
    fi

    case "$os" in
        Linux)  os="linux" ;;
        Darwin) os="darwin" ;;
        *) die "unsupported OS: $os" ;;
    esac

    case "$cpu" in
        aarch64|arm64)        cpu="aarch64" ;;
        x86_64|amd64|x86-64)  cpu="x86_64" ;;
        *) die "unsupported CPU: $cpu" ;;
    esac

    echo "${cpu}-${os}"
}

# --- Downloader selection ---

get_downloader() {
    if command -v curl >/dev/null 2>&1; then
        # Avoid broken snap curl
        if command -v curl | grep -q "/snap/"; then
            if command -v wget >/dev/null 2>&1; then
                echo "wget"; return
            fi
            die "snap curl is broken, please install curl via apt"
        fi
        echo "curl"
    elif command -v wget >/dev/null 2>&1; then
        echo "wget"
    else
        die "curl or wget required"
    fi
}

download() {
    local url="$1" output="$2" dld
    dld=$(get_downloader)

    if [ "$dld" = "curl" ]; then
        curl -fsSL --proto '=https' --tlsv1.2 \
            --retry 3 -C - \
            "$url" -o "$output"
    else
        wget -q --https-only "$url" -O "$output"
    fi
}

test_speed() {
    local url="$1" dld
    dld=$(get_downloader)

    if [ "$dld" = "curl" ]; then
        curl -sS --connect-timeout 3 -m 8 -w '%{speed_download}' -o /dev/null "$url" 2>/dev/null || echo "0"
    else
        wget --spider --timeout=3 -q "$url" 2>/dev/null && echo "1000" || echo "0"
    fi
}

# --- Mirror selection ---

select_mirror() {
    local arch="$1" best="" best_speed=0 speed speed_kb

    info "testing download sources..."

    for source in github ghproxy; do
        case "$source" in
            github)  url="${GITHUB_RELEASE}/nix-installer-${arch}" ;;
            ghproxy) url="${GHPROXY_RELEASE}/nix-installer-${arch}" ;;
        esac

        speed=$(test_speed "$url")
        speed_kb=$(awk "BEGIN {printf \"%.0f\", $speed/1024}")
        printf '   %s: %s KB/s\n' "$source" "$speed_kb" >&2

        if awk "BEGIN {exit !($speed > $best_speed)}"; then
            best_speed="$speed"
            best="$source"
        fi
    done

    speed_kb=$(awk "BEGIN {printf \"%.0f\", $best_speed/1024}")
    info "selected: $best (${speed_kb} KB/s)"
    echo "$best"
}

# --- Main ---

main() {
    if command -v nix >/dev/null 2>&1; then
        info "nix already installed"
        return 0
    fi

    info "installing Nix..."

    local arch base url
    arch=$(get_arch)
    info "architecture: $arch"

    # Determine download URL
    if [ -n "${NIX_INSTALLER_OVERRIDE_URL:-}" ]; then
        url="$NIX_INSTALLER_OVERRIDE_URL"
    elif [ -n "${NIX_INSTALLER_USE_MIRROR:-}" ]; then
        info "using mirror (manual override)"
        url="${GHPROXY_RELEASE}/nix-installer-${arch}"
    elif [ -n "${NIX_INSTALLER_BINARY_ROOT:-}" ]; then
        url="${NIX_INSTALLER_BINARY_ROOT}/nix-installer-${arch}"
    else
        case "$(select_mirror "$arch")" in
            ghproxy) base="$GHPROXY_RELEASE" ;;
            *)       base="$GITHUB_RELEASE" ;;
        esac
        url="${base}/nix-installer-${arch}"
    fi

    # Download and run
    local tmpdir bin
    tmpdir=$(mktemp -d)
    bin="${tmpdir}/nix-installer"
    trap 'rm -rf "$tmpdir"' EXIT

    info "downloading: $url"
    download "$url" "$bin" || die "download failed"
    chmod +x "$bin"

    [ -x "$bin" ] || die "cannot execute $bin (try: export TMPDIR=~/tmp)"

    info "running installer..."
    "$bin" install --no-confirm
}

main
