#!/bin/bash
# Feature: Multi-Platform VPN Manager

cat >> ~/.bashrc << 'VPN'

# --- Feature: VPN Manager ---
vpn-connect() {
    local VPN_DIR=~/Downloads
    
    if [ -z "$1" ]; then
        echo -e "\033[1;33mAvailable VPN configs:\033[0m"
        find "$VPN_DIR" -name "*.ovpn" 2>/dev/null | sed 's|.*/||' | sed 's|\.ovpn||' | sort
        echo ""
        echo "Usage: vpn <config-name>"
        echo "Example: vpn htb-competitive"
        return 1
    fi
    
    local CONFIG="$VPN_DIR/$1.ovpn"
    [ ! -f "$CONFIG" ] && CONFIG="$VPN_DIR/$1"
    
    if [ -f "$CONFIG" ]; then
        echo -e "\033[0;32m[*] Connecting to VPN...\033[0m"
        sudo openvpn "$CONFIG"
    else
        echo -e "\033[0;31m[✗] Config not found: $1\033[0m"
        return 1
    fi
}

alias vpn='vpn-connect'
alias vpnlist='find ~/Downloads -name "*.ovpn" 2>/dev/null | sed "s|.*/||" | sed "s|\.ovpn||" | sort'

vpncheck() {
    if ip a show tun0 >/dev/null 2>&1; then
        echo -e "\033[0;32m[✓] VPN: Connected\033[0m"
        ip -4 addr show tun0 | grep inet | awk '{print "    IP:", $2}'
    else
        echo -e "\033[0;31m[✗] VPN: Disconnected\033[0m"
    fi
}

myip() {
    local VPN_IP=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    if [ -n "$VPN_IP" ]; then
        echo "$VPN_IP"
    else
        echo -e "\033[0;31m[✗] VPN not connected\033[0m" >&2
        return 1
    fi
}

VPN

echo "[✓] VPN manager added"