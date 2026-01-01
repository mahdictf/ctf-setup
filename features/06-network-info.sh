#!/bin/bash
# Feature: Network Info Dashboard

# Verify curl is available for public IP detection
if ! command -v curl &>/dev/null; then
    echo "[!] curl not found, skipping some network features"
fi

cat >> ~/.bashrc << 'NETINFO'

# --- Feature: Network Info ---
netinfo() {
    echo -e "\033[0;36m=== Network Information ===\033[0m"
    echo ""
    
    local ETH0_IP=$(ip -4 addr show eth0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
    [ -n "$ETH0_IP" ] && echo -e "\033[1;37mLocal IP:\033[0m $ETH0_IP"
    
    local VPN_IP=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    if [ -n "$VPN_IP" ]; then
        echo -e "\033[1;37mVPN IP:\033[0m   $VPN_IP"
    else
        echo -e "\033[1;37mVPN IP:\033[0m   \033[0;31mNot connected\033[0m"
    fi
    
    local PUB_IP=$(curl -s --max-time 2 ifconfig.me 2>/dev/null)
    [ -n "$PUB_IP" ] && echo -e "\033[1;37mPublic IP:\033[0m $PUB_IP"
    
    echo ""
    echo -e "\033[1;37mActive Interfaces:\033[0m"
    ip -br a | grep -E "UP|UNKNOWN" | awk '{printf "  %-12s %s\n", $1, $3}'
    echo ""
}

alias net='netinfo'
alias mynet='netinfo'

NETINFO

echo "[✓] Network info dashboard added"