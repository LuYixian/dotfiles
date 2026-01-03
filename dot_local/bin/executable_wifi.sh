#!/bin/bash
# wifi - Display WiFi status with signal strength visualization
# Usage: wifi [--tmux]
#
# Output format: SSID Rate ▂▅▇

AIRPORT_PATH="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

# Signal strength visualization
SIGNALS=(▂ ▅ ▇)

# Check if airport command exists
if [[ ! -x "$AIRPORT_PATH" ]]; then
    echo "offline"
    exit 1
fi

# Get WiFi info
get_wifi_info() {
    local info
    info=$("$AIRPORT_PATH" --getinfo 2>/dev/null)

    if [[ -z "$info" ]]; then
        echo "offline"
        return 1
    fi

    local rssi state rate ssid
    rssi=$(echo "$info" | awk '/agrCtlRSSI:/{print $2}')
    state=$(echo "$info" | awk '/state:/{print $2}')
    rate=$(echo "$info" | awk '/lastTxRate:/{print $2}')
    ssid=$(echo "$info" | awk '/^ *SSID:/{print $2}')

    if [[ "$state" != "running" ]] || [[ -z "$ssid" ]] || [[ "$rate" == "0" ]]; then
        echo "offline"
        return 1
    fi

    # Build signal strength visualization
    local signal=""
    for ((j = 0; j < ${#SIGNALS[@]}; j++)); do
        if   (( j == 0 && rssi > -100 )) ||
             (( j == 1 && rssi > -80  )) ||
             (( j == 2 && rssi > -50  )); then
            signal="${signal}${SIGNALS[$j]}"
        else
            signal="${signal} "
        fi
    done

    echo "${ssid} ${rate}Mbps ${signal}"
}

# Color output for tmux
wifi_tmux() {
    local info
    info=$(get_wifi_info)

    if [[ "$info" == "offline" ]]; then
        echo "#[fg=red]offline#[default]"
    else
        echo "#[fg=green]${info}#[default]"
    fi
}

# Parse arguments
case "$1" in
    -h|--help)
        echo "Usage: wifi [--tmux]"
        echo "  --tmux    tmux colored output"
        exit 0
        ;;
    --tmux)
        wifi_tmux
        ;;
    *)
        get_wifi_info
        ;;
esac
