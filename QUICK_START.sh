#!/bin/bash
# QUICK INSTALLATION GUIDE

# ================================
# CTF VM Setup - Quick Start
# ================================

echo "╔════════════════════════════════════════════╗"
echo "║  CTF VM Setup - Installation Guide        ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Step 1: Prepare
echo "[Step 1] Making installer executable..."
chmod +x install.sh
echo "    ✓ Done"
echo ""

# Step 2: Review Configuration (Optional)
echo "[Step 2] (Optional) Review/edit configuration:"
echo "    nano config.conf"
echo ""

# Step 3: Run Installer
echo "[Step 3] Running installer..."
echo "    ./install.sh"
echo ""
echo "    Choose one of:"
echo "    - Option [1]: Quick Install (recommended)"
echo "    - Option [2]: Custom Install (pick features)"
echo "    - Option [3]: Edit Configuration"
echo "    - Option [4]: Update Existing Installation"
echo ""

# Step 4: Apply Changes
echo "[Step 4] Apply shell configuration:"
echo "    source ~/.bashrc"
echo ""
echo "    OR log out and back in"
echo ""

# Step 5: Test
echo "[Step 5] Test installation:"
echo "    box-new test-machine ctf"
echo "    vpncheck"
echo "    netinfo"
echo ""

echo "╔════════════════════════════════════════════╗"
echo "║  Installation Complete!                   ║"
echo "╚════════════════════════════════════════════╝"
echo ""
echo "For detailed information, see:"
echo "    - README.md (Full documentation)"
echo "    - FIXES_APPLIED.md (What was fixed)"
echo "    - config.conf (Customize installation)"
