#!/bin/bash
# Feature: File Transfer Arsenal

cat >> ~/.bashrc << 'TRANSFER'

# --- Feature: File Transfer ---
serve() {
    local PORT=${1:-8000}
    local MY_IP=$(myip 2>/dev/null || echo "localhost")
    echo -e "\033[0;32m[*] HTTP Server on http://$MY_IP:$PORT\033[0m"
    echo -e "\033[0;33m[*] Serving: $(pwd)\033[0m"
    python3 -m http.server "$PORT"
}

serve80() {
    local MY_IP=$(myip 2>/dev/null || echo "localhost")
    echo -e "\033[0;32m[*] HTTP Server on http://$MY_IP:80\033[0m"
    echo -e "\033[0;33m[*] Serving: $(pwd)\033[0m"
    sudo python3 -m http.server 80
}

smbserv() {
    local SHARE=${1:-share}
    local MY_IP=$(myip 2>/dev/null)
    
    if [ -z "$MY_IP" ]; then
        echo -e "\033[0;31m[✗] VPN not connected!\033[0m"
        return 1
    fi
    
    echo -e "\033[0;32m[*] SMB Server: \\\\$MY_IP\\$SHARE\033[0m"
    echo -e "\033[0;33m[*] Serving: $(pwd)\033[0m"
    echo ""
    echo "Windows commands:"
    echo "  copy \\\\$MY_IP\\$SHARE\\file.exe C:\\Temp\\"
    echo ""
    
    sudo impacket-smbserver "$SHARE" . -smb2support
}

alias pyserv='serve'
alias smb='smbserv'

TRANSFER

echo "[✓] File transfer tools added"