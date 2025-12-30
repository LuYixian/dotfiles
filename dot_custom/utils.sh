# Utility functions

# nw - Network monitoring with sniffnet
# Usage: nw [sniffnet options]
nw() {
    if ! command -v sniffnet >/dev/null 2>&1; then
        echo "sniffnet is not installed. Install via: nix profile install nixpkgs#sniffnet"
        return 1
    fi
    sudo sniffnet "$@"
}
