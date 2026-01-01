#!/bin/bash
# Feature: Universal Workspace Generator

# Create platform directories
mkdir -p ~/{htb,thm,ctf,pentesterlab}

cat >> ~/.bashrc << 'WORKSPACE'

# --- Feature: Workspace Generator ---
box-new() {
    if [ -z "$1" ]; then
        echo -e "\033[1;33mUsage:\033[0m box-new <machine-name> [platform]"
        echo ""
        echo "Examples:"
        echo "  box-new jerry htb"
        echo "  box-new blue thm"
        echo "  box-new webapp ctf"
        echo ""
        echo "Platforms: htb, thm, ctf, pentesterlab (default: ctf)"
        return 1
    fi
    
    local MACHINE=$1
    local PLATFORM=${2:-ctf}
    local WORKSPACE=~/$PLATFORM/$MACHINE
    
    mkdir -p "$WORKSPACE"/{nmap,loot,exploits,www}
    cd "$WORKSPACE" || return
    
    cat > notes.md << NOTES
# $MACHINE

**Platform:** $PLATFORM  
**Date:** $(date +%Y-%m-%d)

---

## Initial Recon

### Nmap Scan
\`\`\`

\`\`\`

### Open Ports


---

## Enumeration

### Service Enumeration


### Web Enumeration


---

## Exploitation

### Initial Foothold


### User Flag
\`\`\`

\`\`\`

---

## Privilege Escalation

### Enumeration


### Root Flag
\`\`\`

\`\`\`

---

## Notes & Lessons Learned


NOTES
    
    echo -e "\033[0;32m[✓] Workspace created: $WORKSPACE\033[0m"
    ls -la
}

alias htb-new='box-new'
alias thm-new='box-new'
alias htb='cd ~/htb'
alias thm='cd ~/thm'
alias ctf='cd ~/ctf'
alias lab='cd ~/pentesterlab'
alias tools='cd ~/tools'

WORKSPACE

echo "[✓] Workspace generator added"