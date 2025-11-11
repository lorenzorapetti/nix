#!/usr/bin/env bash

SERVICE="wg-quick-protonvpn.service"

get_status() {
    if systemctl is-active --quiet "$SERVICE"; then
        echo '{"text": "󰖂", "tooltip": "ProtonVPN: Connected", "class": "connected"}'
    else
        echo '{"text": "󰖂", "tooltip": "ProtonVPN: Disconnected", "class": "disconnected"}'
    fi
}

toggle_service() {
    if systemctl is-active --quiet "$SERVICE"; then
        # Service is active, stop it
        pkexec systemctl stop "$SERVICE"
    else
        # Service is inactive, start it
        pkexec systemctl start "$SERVICE"
    fi
}

case "${1:-}" in
    toggle)
        toggle_service
        ;;
    *)
        get_status
        ;;
esac
