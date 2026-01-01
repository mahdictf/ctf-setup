#!/bin/bash
# Optional Feature: Report Generator

cat >> ~/.bashrc << 'REPORT'

# --- Feature: Report Generator ---
gen-report() {
    local MACHINE=${1:-report}
    local OUTPUT="${MACHINE}-report-$(date +%Y%m%d).md"
    
    cat > "$OUTPUT" << TEMPLATE
# Penetration Test Report: $MACHINE

**Date:** $(date +"%Y-%m-%d")  
**Tester:** $(whoami)  
**Target:** \${TARGET_IP:-N/A}

---

## Executive Summary

### Objectives
- Penetration testing and security assessment

### Findings Summary
- Critical: 0
- High: 0
- Medium: 0
- Low: 0

---

## Vulnerabilities

### Critical Issues

### High Risk Issues

### Medium Risk Issues

### Low Risk Issues

---

## Remediation

---

## Appendix

### Tools Used
- Nmap
- Burp Suite
- Metasploit

TEMPLATE

    echo "[✓] Report template generated: $OUTPUT"
}

alias report='gen-report'

REPORT

echo "[✓] Report generator added"
