# SelfSign
Self hosted sideloading website for iOS 

## Installing
```bash
docker build -t selfsign-image .
docker run -p 1300:1300 selfsign-image
```
This is the script that you want running 24/7 on an server or another computer.

Go to `127.0.0.1:1300` to get to the site on the host (the computer running start.sh) to access this on another device (needs to be connected to the same internet) go to `YOUR_COMPUTERS_IP:1300`

**To get your computers ip run ifconfig (on linux and mac) and ipconfig (on windows)**

Example: `192.158.1.38:1300`

**So SelfSign is hosted on port** ***1300***

# Credit
SelfSign wouldnt work without [zsign](https://github.com/zhlynn/zsign)

# Status
| OS | Status |
|----|----|
| Linux | ✅ |
| Mac | ✅ |
| Windows | ❌ |
