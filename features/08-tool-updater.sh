#!/bin/bash
# Feature: Tool Updater

mkdir -p "$HOME/tools"

cat > "$HOME/tools/update-tools.sh" << 'UPDATER'
#!/bin/bash
echo -e "\033[1;33m[*] Updating all tools...\033[0m"

for dir in ~/tools/*; do
    if [ -d "$dir/.git" ]; then
        echo "  Updating $(basename $dir)..."
        git -C "$dir" pull --quiet 2>/dev/null || echo "    └── Failed"
    fi
done

for dir in /opt/*; do
    if [ -d "$dir/.git" ]; then
        echo "  Updating $(basename $dir)..."
        sudo git -C "$dir" pull --quiet 2>/dev/null || echo "    └── Failed"
    fi
done

sudo updatedb 2>/dev/null
echo -e "\033[0;32m[✓] Tools updated!\033[0m"
UPDATER

chmod +x "$HOME/tools/update-tools.sh"

cat >> ~/.bashrc << 'UPDATE'

# --- Feature: Tool Updater ---
alias update-tools='~/tools/update-tools.sh'

UPDATE

echo "[✓] Tool updater added"