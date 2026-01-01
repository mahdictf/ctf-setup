#!/bin/bash
# Optional Feature: Burp Suite Configuration

cat >> ~/.bashrc << 'BURP'

# --- Feature: Burp Suite Tools ---
burp-foss() {
    echo "[*] Starting Burp Suite Community Edition..."
    /opt/burpsuite/burpsuite &
}

burp-config-proxy() {
    echo "[*] Burp Suite proxy configuration:"
    echo "    Browser Proxy: localhost:8080"
    echo "    CA Certificate: ~/.burp/ca.crt (import to browser)"
}

alias burp='burp-foss'
alias burp-config='burp-config-proxy'

BURP

echo "[✓] Burp Suite configuration added (Burp installation required)"
