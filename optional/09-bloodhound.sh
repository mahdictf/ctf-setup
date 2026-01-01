#!/bin/bash
# Optional Feature: BloodHound & Active Directory Tools

cat >> ~/.bashrc << 'BLOODHOUND'

# --- Feature: BloodHound & AD Tools ---
# BloodHound installation can be done manually
# Download from: https://github.com/BloodHoundAD/BloodHound/releases

alias bloodhound='neo4j console &>/dev/null & sleep 3 && /opt/BloodHound/BloodHound'

BLOODHOUND

echo "[✓] BloodHound configuration added (manual install required)"
