#!/bin/bash
# ================================
# CTF VM Setup - Modular System
# Interactive Installer
# ================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config.conf"
LOG_FILE="$HOME/ctf-setup.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# ================================
# Helper Functions
# ================================

print_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║        CTF VM SETUP - Modular Installation           ║
║        Professional Pentesting Environment            ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

step() {
    echo -e "${YELLOW}[+]${NC} $1"
    echo "[+] $1" >> "$LOG_FILE"
}

success() {
    echo -e "${GREEN}    ✓${NC} $1"
    echo "    ✓ $1" >> "$LOG_FILE"
}

error() {
    echo -e "${RED}    ✗${NC} $1"
    echo "    ✗ $1" >> "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# ================================
# Load Configuration
# ================================

load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        return 0
    else
        error "Configuration file not found: $CONFIG_FILE"
        return 1
    fi
}

# ================================
# Menu System
# ================================

show_main_menu() {
    print_banner
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}INSTALLATION MODE:${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo ""
    echo "  [1] 🚀 Quick Install (Recommended - All Tier 1 & 2 features)"
    echo "  [2] ⚙️  Custom Install (Choose what to install)"
    echo "  [3] 📝 Edit Configuration (config.conf)"
    echo "  [4] 🔄 Update Existing Installation"
    echo "  [5] ℹ️  Show Current Configuration"
    echo "  [0] ❌ Exit"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo -n "Select option [0-5]: "
}

show_custom_menu() {
    print_banner
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}CUSTOM INSTALLATION:${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${MAGENTA}CORE FEATURES:${NC}"
    echo "  [1] ✓ System Setup (packages, directories)"
    echo "  [2] ✓ Workspace Generator (box-new)"
    echo "  [3] ✓ VPN Manager"
    echo "  [4] ✓ Reverse Shell Listener"
    echo "  [5] ✓ File Transfer Tools"
    echo "  [6] ✓ Payload Generator"
    echo "  [7] ✓ Network Info Dashboard"
    echo "  [8] ✓ Target Manager"
    echo ""
    echo -e "${MAGENTA}OPTIONAL FEATURES:${NC}"
    echo "  [9]   Active Directory Tools"
    echo "  [10]  Docker Environment"
    echo "  [11]  Burp Suite Configuration"
    echo "  [12]  Report Generator"
    echo ""
    echo "  [A] Select All Core Features"
    echo "  [B] Select All Optional Features"
    echo "  [C] Select All"
    echo "  [0] Continue with Selection"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo -n "Select features (space-separated, e.g., 1 2 3): "
}

# ================================
# Installation Functions
# ================================

install_system_setup() {
    step "Installing system packages..."
    
    if [ -f "$SCRIPT_DIR/core/system-setup.sh" ]; then
        source "$SCRIPT_DIR/core/system-setup.sh"
        success "System setup complete"
    else
        error "system-setup.sh not found"
        return 1
    fi
}

install_feature() {
    local feature_file=$1
    local feature_name=$2
    
    step "Installing: $feature_name"
    
    if [ -f "$feature_file" ]; then
        source "$feature_file"
        success "$feature_name installed"
        return 0
    else
        error "Feature file not found: $feature_file"
        return 1
    fi
}

load_all_features() {
    step "Loading all enabled features..."
    
    # Load core features
    for feature in "$SCRIPT_DIR/features"/*.sh; do
        if [ -f "$feature" ]; then
            local feature_name=$(basename "$feature" .sh)
            local config_var="FEATURE_${feature_name^^}"
            config_var="${config_var//-/_}"
            
            if [ "${!config_var}" = "true" ] 2>/dev/null || [ -z "${!config_var}" ]; then
                install_feature "$feature" "$(basename $feature .sh)"
            fi
        fi
    done
    
    # Load optional features if enabled
    for feature in "$SCRIPT_DIR/optional"/*.sh; do
        if [ -f "$feature" ]; then
            local feature_name=$(basename "$feature" .sh)
            local config_var="FEATURE_${feature_name^^}"
            config_var="${config_var//-/_}"
            
            if [ "${!config_var}" = "true" ] 2>/dev/null; then
                install_feature "$feature" "$(basename $feature .sh)"
            fi
        fi
    done
    
    # Load custom features
    if [ -d "$SCRIPT_DIR/custom" ]; then
        for feature in "$SCRIPT_DIR/custom"/*.sh; do
            if [ -f "$feature" ]; then
                install_feature "$feature" "Custom: $(basename $feature .sh)"
            fi
        done
    fi
    
    success "All features loaded"
}

quick_install() {
    print_banner
    echo -e "${GREEN}Starting Quick Install...${NC}"
    echo ""
    
    install_system_setup
    load_all_features
    
    echo ""
    echo -e "${GREEN}✓ Quick Installation Complete!${NC}"
    show_completion_message
}

custom_install() {
    # Interactive feature selection
    show_custom_menu
    read -r selections
    
    # Process selections
    print_banner
    echo -e "${GREEN}Starting Custom Install...${NC}"
    echo ""
    
    install_system_setup
    
    for selection in $selections; do
        case $selection in
            1) install_feature "$SCRIPT_DIR/core/system-setup.sh" "System Setup" ;;
            2) install_feature "$SCRIPT_DIR/features/01-workspace.sh" "Workspace Generator" ;;
            3) install_feature "$SCRIPT_DIR/features/02-vpn-manager.sh" "VPN Manager" ;;
            4) install_feature "$SCRIPT_DIR/features/03-listener.sh" "Reverse Shell Listener" ;;
            5) install_feature "$SCRIPT_DIR/features/04-file-transfer.sh" "File Transfer Tools" ;;
            6) install_feature "$SCRIPT_DIR/features/05-payload-gen.sh" "Payload Generator" ;;
            7) install_feature "$SCRIPT_DIR/features/06-network-info.sh" "Network Info" ;;
            8) install_feature "$SCRIPT_DIR/features/07-target-manager.sh" "Target Manager" ;;
            9) install_feature "$SCRIPT_DIR/optional/bloodhound.sh" "BloodHound" ;;
            10) install_feature "$SCRIPT_DIR/optional/docker-tools.sh" "Docker" ;;
            11) install_feature "$SCRIPT_DIR/optional/burp-config.sh" "Burp Suite" ;;
            12) install_feature "$SCRIPT_DIR/optional/report-gen.sh" "Report Generator" ;;
            A|a) load_all_features ;;
        esac
    done
    
    echo ""
    echo -e "${GREEN}✓ Custom Installation Complete!${NC}"
    show_completion_message
}

update_installation() {
    print_banner
    step "Updating existing installation..."
    
    # Update tools
    if [ -f "$HOME/tools/update-tools.sh" ]; then
        "$HOME/tools/update-tools.sh"
    fi
    
    # Reload configuration
    load_all_features
    
    success "Update complete"
    
    echo ""
    read -p "Press Enter to continue..."
}

edit_configuration() {
    if command -v nano &> /dev/null; then
        nano "$CONFIG_FILE"
    elif command -v vim &> /dev/null; then
        vim "$CONFIG_FILE"
    else
        vi "$CONFIG_FILE"
    fi
}

show_current_config() {
    print_banner
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}CURRENT CONFIGURATION:${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo ""
    
    load_config
    
    echo -e "${MAGENTA}Platforms:${NC}"
    echo "  HTB: $SETUP_HTB"
    echo "  TryHackMe: $SETUP_THM"
    echo "  CTF: $SETUP_CTF"
    echo ""
    
    echo -e "${MAGENTA}Core Features:${NC}"
    echo "  Workspace Generator: $FEATURE_WORKSPACE"
    echo "  VPN Manager: $FEATURE_VPN_MANAGER"
    echo "  Listener: $FEATURE_LISTENER"
    echo "  File Transfer: $FEATURE_FILE_TRANSFER"
    echo "  Payload Generator: $FEATURE_PAYLOAD_GEN"
    echo "  Network Info: $FEATURE_NETWORK_INFO"
    echo "  Target Manager: $FEATURE_TARGET_MANAGER"
    echo ""
    
    echo -e "${MAGENTA}Optional Features:${NC}"
    echo "  BloodHound: $FEATURE_BLOODHOUND"
    echo "  Docker: $FEATURE_DOCKER"
    echo "  Burp Suite: $FEATURE_BURP"
    echo ""
    
    echo -e "${MAGENTA}Settings:${NC}"
    echo "  Default Listener Port: $DEFAULT_LISTENER_PORT"
    echo "  Default HTTP Port: $DEFAULT_HTTP_PORT"
    echo "  VPN Config Path: $VPN_CONFIG_PATH"
    echo ""
    
    read -p "Press Enter to continue..."
}

show_completion_message() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}        Installation Successful! ✓${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo "  1. Log out and log back in (or run: source ~/.bashrc)"
    echo "  2. Connect to your VPN: ${CYAN}vpn <config>${NC}"
    echo "  3. Create a workspace: ${CYAN}box-new <machine> <platform>${NC}"
    echo ""
    echo -e "${YELLOW}Quick Commands:${NC}"
    echo "  ${CYAN}vpncheck${NC}         - Check VPN status"
    echo "  ${CYAN}listener [port]${NC}  - Start reverse shell listener"
    echo "  ${CYAN}serve [port]${NC}     - Start HTTP server"
    echo "  ${CYAN}payload <type>${NC}   - Generate payloads"
    echo "  ${CYAN}netinfo${NC}          - Show network info"
    echo "  ${CYAN}target <ip>${NC}      - Set target"
    echo "  ${CYAN}update-tools${NC}     - Update all tools"
    echo ""
    echo -e "${YELLOW}Documentation:${NC}"
    echo "  • Full guide: ${CYAN}$SCRIPT_DIR/README.md${NC}"
    echo "  • Configuration: ${CYAN}$SCRIPT_DIR/config.conf${NC}"
    echo "  • Custom features: ${CYAN}$SCRIPT_DIR/custom/${NC}"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo ""
    
    read -p "Press Enter to exit..."
}

# ================================
# Main Program
# ================================

main() {
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        error "Do not run this script as root!"
        echo "Run as your user: ./install.sh"
        exit 1
    fi
    
    # Initialize log
    echo "==== CTF VM Setup Log - $(date) ====" > "$LOG_FILE"
    
    # Load configuration
    if ! load_config; then
        error "Failed to load configuration. Exiting."
        exit 1
    fi
    
    # Main menu loop
    while true; do
        show_main_menu
        read -r choice
        
        case $choice in
            1)
                quick_install
                break
                ;;
            2)
                custom_install
                break
                ;;
            3)
                edit_configuration
                ;;
            4)
                update_installation
                ;;
            5)
                show_current_config
                ;;
            0)
                echo ""
                echo "Exiting. Have fun hacking! 🎯"
                exit 0
                ;;
            *)
                echo ""
                echo -e "${RED}Invalid option. Please try again.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Run main program
main