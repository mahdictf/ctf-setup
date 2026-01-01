#!/bin/bash
# Core System Setup

export DEBIAN_FRONTEND=noninteractive

# Source configuration file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config.conf"
LOG_FILE="${LOG_FILE:-$HOME/ctf-setup.log}"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "[!] Warning: config.conf not found, using defaults"
fi

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

# Add optional packages based on config
if [ "$INSTALL_CORE_TOOLS" = "true" ]; then
    PACKAGES+=(curl wget git)
fi

if [ "$INSTALL_WEB_TOOLS" = "true" ]; then
    PACKAGES+=(nikto feroxbuster)
fi

if [ "$INSTALL_WORDLISTS" = "true" ]; then
    PACKAGES+=(wordlists seclists)
fi

sudo apt install -y "${PACKAGES[@]}" 2>&1 | tee -a "$LOG_FILE"

echo "[+] Creating directory structure..."
# Use config variables for directory names, with defaults
TOOLS_DIR="${DIR_TOOLS:-tools}"
WORDLISTS_DIR="${DIR_WORDLISTS:-wordlists}"
LOOT_DIR="${DIR_LOOT:-loot}"
EXPLOITS_DIR="${DIR_EXPLOITS:-exploits}"
RECON_DIR="${DIR_RECON:-recon}"

mkdir -p "$HOME"/{$TOOLS_DIR,$WORDLISTS_DIR,$LOOT_DIR,$EXPLOITS_DIR,$RECON_DIR}
mkdir -p "$HOME"/{htb,thm,ctf,pentesterlab}

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
        echo "    Downloading $name..."
        if curl -L -s -o "/tmp/$name" "$url" 2>/dev/null; then
            chmod +x "/tmp/$name"
            sudo mv "/tmp/$name" "/usr/bin/$name" 2>/dev/null && echo "    ✓ $name installed" || echo "    ✗ Failed to install $name"
        else
            echo "    ✗ Failed to download $name"
        fi
    else
        echo "    ✓ $name already installed"
    fi
}

if [ "$INSTALL_KERBRUTE" = "true" ]; then
    (download_binary "https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64" "kerbrute") &
fi

if [ "$INSTALL_WINDAPSEARCH" = "true" ]; then
    (download_binary "https://github.com/ropnop/go-windapsearch/releases/download/v0.3.0/windapsearch-linux-amd64" "windapsearch") &
fi

wait

echo "[+] Cloning tool repositories..."
clone_repo() {
    local url=$1
    local dest=$2
    if [ -d "$dest" ]; then
        echo "    ✓ $(basename $dest) already exists"
    else
        echo "    Cloning $(basename $dest)..."
        if git clone --depth 1 "$url" "$dest" 2>&1 | tee -a "$LOG_FILE" >/dev/null; then
            echo "    ✓ $(basename $dest) cloned"
        else
            echo "    ✗ Failed to clone $(basename $dest)"
        fi
    fi
}

if [ "$INSTALL_NMAP_AUTOMATOR" = "true" ]; then
    (clone_repo "https://github.com/21y4d/nmapAutomator" "$HOME/$TOOLS_DIR/nmapAutomator") &
fi

if [ "$INSTALL_LINENUM" = "true" ]; then
    (clone_repo "https://github.com/rebootuser/LinEnum" "$HOME/$TOOLS_DIR/LinEnum") &
fi

if [ "$INSTALL_PEASS" = "true" ]; then
    (clone_repo "https://github.com/carlospolop/PEASS-ng.git" "$HOME/$TOOLS_DIR/PEASS-ng") &
fi

if [ "$INSTALL_NISHANG" = "true" ]; then
    (clone_repo "https://github.com/samratashok/nishang.git" "$HOME/$TOOLS_DIR/nishang") &
fi

wait

# Setup symlinks for PEASS
if [ -d "$HOME/$TOOLS_DIR/PEASS-ng" ]; then
    ln -sf "$HOME/$TOOLS_DIR/PEASS-ng/linPEAS/linpeas.sh" "$HOME/$TOOLS_DIR/linpeas.sh" 2>/dev/null
    ln -sf "$HOME/$TOOLS_DIR/PEASS-ng/winPEAS/winPEAS.bat" "$HOME/$TOOLS_DIR/winpeas.bat" 2>/dev/null
fi

# Setup nmap automator if installed
if [ -d "$HOME/$TOOLS_DIR/nmapAutomator" ]; then
    sudo chmod +x "$HOME/$TOOLS_DIR/nmapAutomator/nmapAutomator.sh" 2>/dev/null
fi

echo "[+] Setting bash as default shell..."
if [ "$SET_BASH_DEFAULT" = "true" ]; then
    [ "$SHELL" != "/bin/bash" ] && chsh -s /bin/bash "$USER" && echo "    ✓ Bash set as default" || echo "    ✓ Bash already default"
fi

sudo updatedb 2>/dev/null

echo "[✓] Core system setup complete"