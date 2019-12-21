RED='\033[0;31m'
# used for color with ${RED}
YELLOW='\033[1;33m'
# used for color with ${YELLOW}
CYAN='\033[0;36m'
# used for color with ${CYAN}
NC='\033[0m'
# No Color

echo -e "${YELLOW}"
echo "***"
echo "Welcome to Samourai Wallet's Whirlpool Install"
echo "By @BTCxZelko"
echo "***"
sleep 3s
echo -e "${RED}"
echo "***"
echo "Install and run Whirlpool Client CLI for continuous mixing"
echo "Intended for Raspberry Pi 4-4GB RAM + Raspbian/Debian based system"
echo "WARNING: YOU MUST HAVE TOR INSTALLED ON SYSTEM BEFORE STARTING"
echo "IF YOU DONT HAVE IT INSTALLED PRESS Ctrl+C to cancel this script and install tor before continuing"
echo "***"
sleep 10s

# install install openjdk
echo -e "${RED}"
echo "***"
echo "Installing Whirlpool Dependencies"
echo "***"
echo -e "${NC}"
sleep 3s
sudo apt-get install openjdk-8-jre -y
echo -e "${RED}"
echo "***"
echo "Download complete"
echo "***"
sleep 2s

# create whirlpool directory
echo -e "${RED}" 
echo "***"
echo "Creating Whirlpool working directory"
echo "***"
echo -e "${NC}"
sleep 1s
mkdir ~/whirlpool
cd ~/whirlpool
echo -e "${RED}"
echo "***"
echo "Done"
echo "***"
sleep 1s

# pull Whirlpool run times
echo -e "${RED}"
echo "***"
echo "Pull Whirlpool from github"
echo "***"
echo -e "${NC}"
sleep 1s
wget -O whirlpool.jar https://github.com/Samourai-Wallet/whirlpool-client-cli/releases/download/0.9.3/whirlpool-client-cli-0.9.3-run.jar
echo -e "${RED}"
echo "***"
echo "Download complete"
echo "***"
sleep 2s

# set Whirlpool as systemd service
echo -e "${RED}"
echo "***"
echo "Setting Whirlpool-Client-CLI as a systemd service and enabling at start"
echo "***"
echo -e "${NC}"
sleep 1s
echo -e "${RED}"
echo "***"
echo "Setting Whirlpool as a service..."
echo "***"
echo -e "${NC}"
sleep 2s

USER=$(sudo cat /etc/passwd | grep 1000 | awk -F: '{ print $1}' | cut -c 1-)
echo "
[Unit]
Description=whirlpool
After=tor.service
[Service]
WorkingDirectory=/home/$USER/whirlpool
ExecStart=/usr/bin/java -jar /home/$USER/whirlpool/whirlpool.jar --server=mainnet --tor --listen
User=$USER
Group=$USER
Type=simple
KillMode=process
TimeoutSec=60
Restart=always
RestartSec=60
[Install]
WantedBy=multi-user.target
" | sudo tee -a /etc/systemd/system/whirlpool.service

sudo systemctl daemon-reload
sleep 3s

echo -e "${RED}"
echo "***"
echo "Starting whirlpool in the background..."
echo "***"
echo -e "${NC}"
sleep 2s
sudo systemctl start whirlpool
sleep 2s

# open port 8899 to local host
echo -e "${RED}"
echo "***"
echo "adding UFW rule to allow 8899 for Whirlpool GUI"
echo "***"
sleep 1s
echo -e "${NC}"
sudo ufw allow from 192.168.1.1/24 to any port 8899 comment 'Whirlpool GUI access restricted to local LAN only'
sleep 1s
echo -e "${RED}"
echo "Rule Updated"
sleep 1s

# display API pairing key for GUI
echo "Install Whirlpool GUI to finish pairing"
sleep 1s
echo "After pairing for restarts simply type:"
echo "sudo systemctl restart whirlpool"
sleep 3s
echo "Enjoy mixing!"
fi
