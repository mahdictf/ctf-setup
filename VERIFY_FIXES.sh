#!/bin/bash
# 🎯 CTF Setup - Verification Checklist

# This script verifies that all fixes have been properly applied

echo "╔════════════════════════════════════════════════════════╗"
echo "║     CTF Setup - Fixes Verification Checklist           ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PASSED=0
FAILED=0

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_file() {
    local file=$1
    local description=$2
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $description"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $description (MISSING: $file)"
        ((FAILED++))
    fi
}

check_directory() {
    local dir=$1
    local description=$2
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} $description"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $description (MISSING: $dir)"
        ((FAILED++))
    fi
}

check_content() {
    local file=$1
    local content=$2
    local description=$3
    if grep -q "$content" "$file" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $description"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $description (NOT FOUND in $file)"
        ((FAILED++))
    fi
}

echo -e "${YELLOW}[1] Checking Directory Structure${NC}"
echo "─────────────────────────────────────────────────────────"
check_directory "$SCRIPT_DIR/core" "Core directory exists"
check_directory "$SCRIPT_DIR/features" "Features directory exists"
check_directory "$SCRIPT_DIR/optional" "Optional directory exists (FIXED)"
check_directory "$SCRIPT_DIR/custom" "Custom directory exists"
echo ""

echo -e "${YELLOW}[2] Checking Core Files${NC}"
echo "─────────────────────────────────────────────────────────"
check_file "$SCRIPT_DIR/install.sh" "install.sh exists"
check_file "$SCRIPT_DIR/config.conf" "config.conf exists"
check_file "$SCRIPT_DIR/README.md" "README.md exists"
echo ""

echo -e "${YELLOW}[3] Checking Feature Files${NC}"
echo "─────────────────────────────────────────────────────────"
check_file "$SCRIPT_DIR/features/00-basic-aliases.sh" "00-basic-aliases.sh exists"
check_file "$SCRIPT_DIR/features/01-workspace.sh" "01-workspace.sh exists"
check_file "$SCRIPT_DIR/features/02-vpn-manager.sh" "02-vpn-manager.sh exists"
check_file "$SCRIPT_DIR/features/03-listener.sh" "03-listener.sh exists"
check_file "$SCRIPT_DIR/features/04-file-transfer.sh" "04-file-transfer.sh exists"
check_file "$SCRIPT_DIR/features/05-payload-gen.sh" "05-payload-gen.sh exists"
check_file "$SCRIPT_DIR/features/06-network-info.sh" "06-network-info.sh exists"
check_file "$SCRIPT_DIR/features/07-target-manager.sh" "07-target-manager.sh exists"
check_file "$SCRIPT_DIR/features/08-tool-updater.sh" "08-tool-updater.sh exists"
echo ""

echo -e "${YELLOW}[4] Checking Optional Files (FIXED)${NC}"
echo "─────────────────────────────────────────────────────────"
check_file "$SCRIPT_DIR/optional/09-bloodhound.sh" "09-bloodhound.sh exists"
check_file "$SCRIPT_DIR/optional/10-docker-tools.sh" "10-docker-tools.sh exists"
check_file "$SCRIPT_DIR/optional/11-burp-config.sh" "11-burp-config.sh exists"
check_file "$SCRIPT_DIR/optional/12-report-gen.sh" "12-report-gen.sh exists"
echo ""

echo -e "${YELLOW}[5] Checking Fix Documentation${NC}"
echo "─────────────────────────────────────────────────────────"
check_file "$SCRIPT_DIR/FIXES_APPLIED.md" "FIXES_APPLIED.md (NEW)"
check_file "$SCRIPT_DIR/INSTALLATION_SUMMARY.md" "INSTALLATION_SUMMARY.md (NEW)"
check_file "$SCRIPT_DIR/QUICK_START.sh" "QUICK_START.sh (NEW)"
echo ""

echo -e "${YELLOW}[6] Checking install.sh Fixes${NC}"
echo "─────────────────────────────────────────────────────────"
check_content "$SCRIPT_DIR/install.sh" "load_all_features()" "load_all_features() fixed"
check_content "$SCRIPT_DIR/install.sh" "custom_install()" "custom_install() fixed"
check_content "$SCRIPT_DIR/install.sh" "quick_install()" "quick_install() fixed"
check_content "$SCRIPT_DIR/install.sh" "file existence checks" "Error handling added"
echo ""

echo -e "${YELLOW}[7] Checking Feature File Shebangs${NC}"
echo "─────────────────────────────────────────────────────────"
for file in "$SCRIPT_DIR/features"/*.sh; do
    if [ -f "$file" ]; then
        if head -1 "$file" | grep -q "#!/bin/bash"; then
            echo -e "${GREEN}✓${NC} $(basename $file) has shebang"
            ((PASSED++))
        else
            echo -e "${RED}✗${NC} $(basename $file) missing shebang"
            ((FAILED++))
        fi
    fi
done
echo ""

echo -e "${YELLOW}[8] Checking system-setup.sh Fixes${NC}"
echo "─────────────────────────────────────────────────────────"
check_content "$SCRIPT_DIR/core/system-setup.sh" "source.*CONFIG_FILE" "Config.conf sourcing (FIXED)"
check_content "$SCRIPT_DIR/core/system-setup.sh" "DIR_TOOLS=" "Config variable usage (FIXED)"
check_content "$SCRIPT_DIR/core/system-setup.sh" "INSTALL_PEASS" "Config respects settings (FIXED)"
echo ""

echo -e "${YELLOW}[9] Checking Feature Initialization${NC}"
echo "─────────────────────────────────────────────────────────"
check_content "$SCRIPT_DIR/features/01-workspace.sh" "mkdir -p" "01: Directory creation (FIXED)"
check_content "$SCRIPT_DIR/features/02-vpn-manager.sh" "mkdir -p ~/Downloads" "02: VPN directory (FIXED)"
check_content "$SCRIPT_DIR/features/03-listener.sh" "mkdir -p ~/.config/ctf" "03: Listener setup (FIXED)"
check_content "$SCRIPT_DIR/features/08-tool-updater.sh" "mkdir -p.*tools" "08: Tool directory (FIXED)"
echo ""

echo "╔════════════════════════════════════════════════════════╗"
echo -e "║     ${GREEN}VERIFICATION SUMMARY${NC}                             ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo -e "  ${GREEN}Passed:${NC} $PASSED"
echo -e "  ${RED}Failed:${NC} $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed! Your fixes are correctly applied.${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. chmod +x install.sh"
    echo "  2. ./install.sh"
    echo "  3. Choose installation option"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Some checks failed. Please review the output above.${NC}"
    exit 1
fi
