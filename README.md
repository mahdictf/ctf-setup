# 🎯 CTF VM Setup - Modular System

Professional, customizable setup system for CTF and penetration testing VMs.

## 📋 Features

### Tier 1 (Core Features)

- ✅ **Universal Workspace Generator** - Organized folders for any CTF platform
- ✅ **Multi-Platform VPN Manager** - Handle HTB, THM, and other VPN configs
- ✅ **Smart Reverse Shell Listener** - Auto-generates payloads with your IP
- ✅ **File Transfer Arsenal** - HTTP, SMB servers in one command
- ✅ **Tool Updater** - Update all Git repos with one command

### Tier 2 (Enhanced Features)

- ✅ **Payload Generator** - Instant reverse shells, web shells, injections
- ✅ **Network Info Dashboard** - All network details at a glance
- ✅ **Target Manager** - Save target IP/hostname, auto-update /etc/hosts

### Optional Features

- 🔹 Active Directory Tools (BloodHound, Rubeus, etc.)
- 🔹 Docker Environment
- 🔹 Burp Suite Configuration
- 🔹 Report Generation
- 🔹 Screenshot Management
- 🔹 Web Enumeration Automation

---

## 🚀 Quick Start

### Installation

```bash
# Clone or download the setup files
cd ~/ctf-setup

# Make installer executable
chmod +x install.sh

# Run interactive installer
./install.sh
```

### First-Time Setup

1. **Choose Installation Mode:**
   - Quick Install (recommended) - Installs all Tier 1 & 2 features
   - Custom Install - Pick specific features
2. **After Installation:**

```bash
# Apply changes
source ~/.bashrc

# Or log out and log back in
```

---

## 📁 Directory Structure

```
~/ctf-setup/
├── install.sh              # Interactive installer
├── config.conf            # Configuration file (edit this!)
├── core/                  # Core system setup
├── features/              # Main features (Tier 1 & 2)
├── optional/              # Optional features
├── custom/                # YOUR custom features
└── README.md              # This file

After installation:
~/
├── htb/                   # HackTheBox machines
├── thm/                   # TryHackMe rooms
├── ctf/                   # CTF challenges
├── tools/                 # All pentesting tools
├── wordlists/             # Wordlists
├── loot/                  # Collected credentials/data
└── exploits/              # Exploit scripts
```

---

## ⚙️ Configuration

### Edit Configuration

```bash
# Open configuration file
nano ~/ctf-setup/config.conf

# Or use the installer
./install.sh
# Select option [3] Edit Configuration
```

### Common Customizations

**Change platforms:**

```ini
SETUP_HTB=true
SETUP_THM=false
SETUP_CTF=true
```

**Disable features:**

```ini
FEATURE_PAYLOAD_GEN=false
FEATURE_BLOODHOUND=false
```

**Change defaults:**

```ini
DEFAULT_LISTENER_PORT=9001
DEFAULT_HTTP_PORT=80
VPN_CONFIG_PATH="~/vpn-configs"
```

---

## 🎮 Usage

### Core Commands

#### Workspace Management

```bash
# Create new workspace
box-new jerry htb          # HackTheBox
box-new blue thm           # TryHackMe
box-new webapp ctf         # Generic CTF

# Navigate to workspaces
htb                        # cd ~/htb
thm                        # cd ~/thm
ctf                        # cd ~/ctf
```

#### VPN Management

```bash
# List available VPN configs
vpnlist

# Connect to VPN
vpn htb-competitive
vpn thm

# Check VPN status
vpncheck

# Get your VPN IP
myip
```

#### Reverse Shell Listener

```bash
# Start listener (auto-shows payloads)
listener              # Default port 4444
listener 9001         # Custom port

# Alias
listen 443
shell 8080
```

#### File Transfer

```bash
# HTTP Server
serve                 # Port 8000
serve 80              # Port 80
serve80               # Same as above

# SMB Server
smbserv               # Default share name
smbserv files         # Custom share name
```

#### Payload Generator

```bash
# Generate payloads
payload bash          # Bash reverse shell
payload python        # Python reverse shell
payload powershell    # PowerShell reverse shell
payload nc            # Netcat reverse shell
payload php           # PHP web shell
payload sql           # SQL injection
payload xss           # XSS payloads
payload xxe           # XXE payloads
```

#### Network Information

```bash
# Show all network info
netinfo
net
mynet

# Get VPN IP only
myip
```

#### Target Management

```bash
# Set target
target 10.10.10.27 jerry.htb

# Show current target
target

# Use target in commands
ping $TARGET_IP
nmap $TARGET_HOST

# Clear target
target-clear
```

#### Tool Management

```bash
# Update all tools
update-tools

# Copy tools to current directory
linenum              # Copy LinEnum.sh
psh                  # Copy PowerShell reverse shell
```

### Scanning & Enumeration

```bash
# Nmap
nnmap 10.10.10.27              # Script scan + full port scan
nnmap1 10.10.10.27             # Script scan only
nnmap-full 10.10.10.27         # Full port scan only

# Gobuster
gobust http://target.com

# Netcat
nnc 4444                        # rlwrap nc -nvlp 4444
```

---

## 🔧 Customization

### Adding Custom Features

1. **Create a new feature file:**

```bash
nano ~/ctf-setup/custom/my-feature.sh
```

2. **Add your code:**

```bash
#!/bin/bash
# My Custom Feature

my_command() {
    echo "This is my custom command!"
}

alias mycmd='my_command'
```

3. **Enable it:**

```bash
# Edit config.conf
ALIASES_CUSTOM=true
```

4. **Reinstall or update:**

```bash
./install.sh
# Select option [4] Update Existing Installation
```

### Example Custom Features

**Quick Nmap to All Ports:**

```bash
# ~/ctf-setup/custom/quick-scan.sh
quick-scan() {
    local TARGET=$1
    if [ -z "$TARGET" ]; then
        echo "Usage: quick-scan <target>"
        return 1
    fi

    mkdir -p nmap
    sudo nmap -p- -T4 --min-rate 10000 -oA nmap/quick $TARGET
}

alias qs='quick-scan'
```

**Auto-Screenshot:**

```bash
# ~/ctf-setup/custom/screenshot.sh
ss() {
    local NAME=$(basename $PWD)
    local TIME=$(date +%H%M%S)
    scrot -s "${NAME}_${TIME}.png"
    echo "Screenshot saved: ${NAME}_${TIME}.png"
}
```

---

## 📦 Feature Modules

### Core Modules (core/)

- `system-setup.sh` - Package installation, directory creation
- `package-installer.sh` - Package management
- `directory-setup.sh` - Folder structure

### Feature Modules (features/)

- `01-workspace.sh` - box-new command
- `02-vpn-manager.sh` - VPN management
- `03-listener.sh` - Reverse shell listener
- `04-file-transfer.sh` - File transfer tools
- `05-payload-gen.sh` - Payload generator
- `06-network-info.sh` - Network dashboard
- `07-target-manager.sh` - Target management
- `08-tool-updater.sh` - Tool update system

### Optional Modules (optional/)

- `bloodhound.sh` - AD enumeration setup
- `docker-tools.sh` - Docker environment
- `burp-config.sh` - Burp Suite setup
- `report-gen.sh` - Report templates

---

## 🔄 Updating

### Update Tools

```bash
update-tools
```

### Update Configuration

```bash
# Edit config
nano ~/ctf-setup/config.conf

# Rerun installer
./install.sh
# Select [4] Update Existing Installation
```

### Pull Latest Version

```bash
cd ~/ctf-setup
git pull
./install.sh
```

---

## 🐛 Troubleshooting

### VPN Not Working

```bash
# Check VPN status
vpncheck

# List configs
vpnlist

# Check interface
ip a show tun0
```

### Commands Not Found

```bash
# Reload shell configuration
source ~/.bashrc

# Or log out and log back in
```

### Features Not Loading

```bash
# Check config
cat ~/ctf-setup/config.conf | grep FEATURE

# Check logs
tail -f ~/ctf-setup.log
```

---

## 💡 Tips & Tricks

### Workflow Example

```bash
# 1. Create workspace
box-new jerry htb

# 2. Connect to VPN
vpn htb-labs

# 3. Set target
target 10.10.10.27 jerry.htb

# 4. Start enumeration
nnmap $TARGET_IP

# 5. Start listener in another terminal
listener 4444

# 6. Start file server
serve

# 7. When you get shell, upgrade it
python3 -c 'import pty;pty.spawn("/bin/bash")'
# Ctrl+Z
stty raw -echo; fg
export TERM=xterm
```

### Time-Saving Aliases

```bash
# Quick navigation
htb && box-new newmachine htb

# Chain commands
target 10.10.10.27 box.htb && nnmap $TARGET_IP

# Background HTTP server
serve > /dev/null 2>&1 &
```

---

## 📚 Resources

### Included Tools

- PEASS-ng (LinPEAS/WinPEAS)
- Nishang (PowerShell)
- LinEnum
- nmapAutomator
- Kerbrute
- Windapsearch
- Impacket
- SecLists

### Wordlists

- `/usr/share/wordlists/`
- `/usr/share/seclists/`
- `~/wordlists/`

### Documentation

- `/opt/` - Cloned tools
- `~/tools/` - User tools
- `~/ctf-setup/` - This setup system

---

## 🤝 Contributing

### Add Your Own Features

1. Create feature in `custom/` directory
2. Test it
3. Share with others!

### Suggest Improvements

- Open an issue
- Submit a pull request
- Share your custom modules

---

## 📝 License

Free to use, modify, and distribute. Have fun hacking! 🎯

---

## ✨ Credits

Created for CTF players and penetration testers who want a professional, customizable VM setup.

**Platforms Supported:**

- HackTheBox
- TryHackMe
- CTF Competitions
- PentesterLab
- Custom Pentesting Labs

---

## 🆘 Support

If you encounter issues:

1. Check logs: `tail -f ~/ctf-setup.log`
2. Review configuration: `~/ctf-setup/config.conf`
3. Re-run installer: `./install.sh`
4. Check documentation above

Happy Hacking! 🚀
