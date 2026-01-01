#!/bin/bash
# Basic Aliases

cat >> ~/.bashrc << 'ALIASES'

# --- Basic Aliases ---
alias c='clear'
alias dl='cd ~/Downloads'
alias opt='cd /opt'
alias linenum='cp /opt/LinEnum/LinEnum.sh .'
alias psh='cp ~/tools/nishang/Shells/Invoke-PowerShellTcpOneLine.ps1 .'
alias clone='sudo git clone'
alias searchex='searchsploit'
alias gobust='sudo gobuster dir -w /usr/share/seclists/Discovery/Web-Content/raft-small-words.txt -o gobuster.out -b 404,403,301 -u'
alias nnmap='mkdir -p nmap && sudo nmap -sCV -vvv -oA nmap/script-scan'
alias nnmap-full='sudo nmap -p- -T4 -A -oA nmap/full-port-scan'
alias pentmux='tmux new-session -d -s pentest -n vpn \; new-window -n recon \; new-window -n shell \; attach-session -t pentest'

ALIASES

echo "[✓] Basic aliases added"