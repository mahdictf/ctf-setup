#!/bin/bash
# Optional Feature: Docker Tools

cat >> ~/.bashrc << 'DOCKER'

# --- Feature: Docker Tools ---
docker-pentest() {
    local IMAGE=${1:-kalilinux/kali-rolling}
    echo "[*] Starting Docker container: $IMAGE"
    docker run -it --rm -v "$PWD:/work" "$IMAGE" /bin/bash
}

alias docker-kali='docker-pentest kalilinux/kali-rolling'
alias docker-ubuntu='docker-pentest ubuntu:latest'

DOCKER

echo "[✓] Docker tools added (Docker installation required)"
