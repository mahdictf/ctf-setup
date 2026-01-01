#!/bin/bash
# Core System Setup

export DEBIAN_FRONTEND=noninteractive

echo "[+] Updating package list..."
sudo apt update 2>&1 | tee -a "$LOG_FILE"

echo "[+] Installing core packages..."
PACKAGES=(
    tmux fastfetch kali-wallpapers-all
    impacket-scripts dnsrecon smbclient ldap-utils krb5-user 
    nikto smbmap nmap rlwrap feroxbuster gobuster
    terminator python3-pip wordlists seclists
    exploitdb exploitdb-bin-sploits
)

sudo apt install -y "${PACKAGES[@]}" 2>&1 | tee -a "$LOG_FILE"

echo "[+] Creating directory structure..."
mkdir -p "$HOME"/{tools,recon,loot,exploits,htb,thm,ctf,pentesterlab,wordlists}

echo "[+] Configuring tmux..."
if ! grep -q "##### Custom Tmux Settings #####" "$HOME/.tmux.conf" 2>/dev/null; then
cat << 'EOF' >> "$HOME/.tmux.conf"

##### Custom Tmux Settings #####
set -g mouse on
set -g history-limit 10000
set -g terminal-overrides 'xterm*:smcup@:rmcup@'
################################

EOF
fi

echo "[+] Downloading binary tools..."
download_binary() {
    local url=$1
    local name=$2
    if [ ! -f "/usr/bin/$name" ]; then
        curl -L -s -o "/tmp/$name" "$url"
        chmod +x "/tmp/$name"
        sudo mv "/tmp/$name" "/usr/bin/$name"
    fi
}

(download_binary "https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64" "kerbrute") &
(download_binary "https://github.com/ropnop/go-windapsearch/releases/download/v0.3.0/windapsearch-linux-amd64" "windapsearch") &
wait

echo "[+] Cloning tool repositories..."
clone_repo() {
    local url=$1
    local dest=$2
    [ -d "$dest" ] || git clone --depth 1 "$url" "$dest" 2>&1 | tee -a "$LOG_FILE"
}

(clone_repo "https://github.com/21y4d/nmapAutomator" "/opt/nmapAutomator") &
(clone_repo "https://github.com/rebootuser/LinEnum" "/opt/LinEnum") &
(clone_repo "https://github.com/carlospolop/PEASS-ng.git" "$HOME/tools/PEASS-ng") &
(clone_repo "https://github.com/samratashok/nishang.git" "$HOME/tools/nishang") &
wait

[ -d /opt/nmapAutomator ] && sudo chmod +x /opt/nmapAutomator/nmapAutomator.sh
[ -d /opt/nmapAutomator ] && sudo cp /opt/nmapAutomator/nmapAutomator.sh /usr/bin/recon.sh 2>/dev/null
[ -d /opt/LinEnum ] && sudo chmod +x /opt/LinEnum/LinEnum.sh

if [ -d "$HOME/tools/PEASS-ng" ]; then
    ln -sf "$HOME/tools/PEASS-ng/linPEAS/linpeas.sh" "$HOME/tools/linpeas.sh" 2>/dev/null
    ln -sf "$HOME/tools/PEASS-ng/winPEAS/winPEAS.bat" "$HOME/tools/winpeas.bat" 2>/dev/null
fi

echo "[+] Setting bash as default shell..."
[ "$SHELL" != "/bin/bash" ] && chsh -s /bin/bash "$USER"

sudo updatedb 2>/dev/null
echo "[✓] Core system setup complete"