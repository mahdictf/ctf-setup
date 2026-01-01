#!/bin/bash
# Feature: Target Manager

cat >> ~/.bashrc << 'TARGET'

# --- Feature: Target Manager ---
target() {
    if [ -z "$1" ]; then
        if [ -n "$TARGET_IP" ]; then
            echo -e "\033[0;32m[*] Current Target:\033[0m"
            echo "    IP:       $TARGET_IP"
            echo "    Hostname: $TARGET_HOST"
        else
            echo "Usage: target <ip> [hostname]"
            echo "Example: target 10.10.10.27 jerry.htb"
        fi
        return 0
    fi
    
    export TARGET_IP=$1
    export TARGET_HOST=${2:-$1}
    
    if [ "$TARGET_HOST" != "$TARGET_IP" ]; then
        if ! grep -q "$TARGET_IP.*$TARGET_HOST" /etc/hosts 2>/dev/null; then
            echo "$TARGET_IP    $TARGET_HOST" | sudo tee -a /etc/hosts >/dev/null
            echo -e "\033[0;32m[✓] Added to /etc/hosts\033[0m"
        fi
    fi
    
    echo -e "\033[0;32m[✓] Target set:\033[0m"
    echo "    IP:       $TARGET_IP"
    echo "    Hostname: $TARGET_HOST"
    echo ""
    echo "Quick access: \$TARGET_IP and \$TARGET_HOST"
}

alias tgt='target'
alias target-clear='unset TARGET_IP TARGET_HOST; echo "Target cleared"'

TARGET

echo "[✓] Target manager added"