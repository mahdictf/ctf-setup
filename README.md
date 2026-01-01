# 🎯 CTF VM Setup —

This project helps you prepare a Linux VM for Capture-The-Flag (CTF) practice and pentesting. It installs useful tools, creates directories (htb, thm, ctf), and adds handy shell commands (aliases and functions) to speed up your workflow.

---

## Quick summary

- What it does: installs tools, creates workspaces, and adds useful shell commands.
- How to use it: run the installer and then source your shell config.
- Who it's for: CTF players and pentesters who want a ready-to-use environment.

---

## Quick start (recommended)

Open a terminal and run:

```bash
cd ~/ctf-setup        # go to the project folder
chmod +x install.sh   # make installer runnable
./install.sh          # run the interactive installer
# choose option 1 for Quick Install, or 2 for Custom Install

# when done, apply changes to your shell
source ~/.bashrc
```

After that you have commands like `box-new`, `vpn`, `listener`, `serve`, etc.

---

## Key files and folders

- `install.sh` — interactive installer (Quick / Custom / Update / Edit config)
- `config.conf` — main settings file (change before install to customize)
- `core/` — core setup scripts (system packages, directories)
- `features/` — feature scripts that add commands and tools
- `optional/` — optional features (enable in `config.conf`)
- `custom/` — your custom feature scripts

---

## Most useful commands (examples)

- Workspaces

  - `box-new <name> <platform>` — create a workspace (platform: htb, thm, ctf)
  - `htb`, `thm`, `ctf` — jump to workspace folders

- VPN

  - `vpnlist` — show available .ovpn files in `~/Downloads`
  - `vpn <name>` — connect with `sudo openvpn <file>`
  - `vpncheck` — check if `tun0` is up
  - `myip` — show VPN IP

- Listener & payloads

  - `listener [port]` — prints payloads and starts `nc` listener

- File sharing

  - `serve [port]` — simple Python HTTP server
  - `smbserv [share]` — run `impacket-smbserver` (if installed)

- Misc
  - `payload <type>` — prints reverse-shell payloads (bash, python, powershell, etc.)
  - `netinfo` — show local / VPN / public IPs and interfaces
  - `target <ip> [hostname]` — set a target and optionally add to `/etc/hosts`
  - `update-tools` — update all cloned tool repositories

Remember to run `source ~/.bashrc` to enable commands after installation.

---

## Edit configuration (simple)

Open `config.conf` in an editor and change values. Example:

```ini
# enable/disable features
FEATURE_VPN_MANAGER=true
FEATURE_PAYLOAD_GEN=true

# directory names
DIR_TOOLS="tools"
DIR_WORDLISTS="wordlists"

# install specific tools
INSTALL_PEASS=true
INSTALL_KERBRUTE=true
```

Save and re-run `./install.sh` (use Update or Custom mode) to apply changes.

---

## Why you sometimes see prompts during install

Some system packages (Debian/Ubuntu) ask questions during installation. For example, `krb5-user` asks for a "default Kerberos realm". You can:

- press OK to accept the default (safe if you don't use Kerberos);
- or enter a realm (e.g., `EXAMPLE.COM`) if you need Kerberos.

To avoid the prompt, disable the related package in `config.conf` (e.g., `INSTALL_KERBRUTE=false`) or remove it from the package list in `core/system-setup.sh`.

---

## Troubleshooting (quick)

- Commands missing after install? Run:

```bash
source ~/.bashrc
# or log out and back in
```

- Installer always asks for Kerberos realm: edit `config.conf` to disable Kerberos-related installs or skip `krb5-user`.

- A feature didn't load: check logs:

```bash
tail -n 200 ~/ctf-setup.log
```

---

## Add your own feature (2 steps)

1. Create `custom/my-feature.sh` with your functions/aliases.
2. Set `ALIASES_CUSTOM=true` in `config.conf` and run installer (Update).

Example `custom/my-feature.sh`:

```bash
#!/bin/bash
mycmd() { echo "Hello from custom feature"; }
cat >> ~/.bashrc <<'EOF'
alias mycmd='mycmd'
EOF
```
