# SelfSign
Self hosted sideloading website for iOS 

## Installing
### On linux && Mac:
```bash
chmod +x install.sh && ./install.sh
```
### On Windows:
```bash
chmod +x windows.sh && ./windows.sh
```

# Using
When you have installed SelfSign run:
```bash
chmod +x start.sh && sudo ./start.sh 
```
This is the script that you want running 24/7 on an server or another computer.

Go to `127.0.0.1:13` to get to the site on the host (the computer running start.sh) to access this on another device (needs to be connected to the same internet) go to `YOUR_COMPUTERS_IP:13`

**To get your computers ip run ifconfig (on linux and mac) and ipconfig (on windows)**

Example: `192.158.1.38:13`

**So SelfSign is hosted on port ** ***13***

# Libraries
SelfSign wouldnt work without [zsign](https://github.com/zhlynn/zsign)