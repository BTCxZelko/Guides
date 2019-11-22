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
echo "***"
sleep 5s

# install instal openjdk
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

# install instal openjdk
echo -e "${RED}"
echo "***"
echo "Installing tmux"
echo "***"
echo -e "${NC}"
sleep 1s
sudo apt-get install tmux -y
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
cd $HOME
mkdir whirlpool
cd whirlpool
echo -e "${RED}"
echo "***"
echo "Done"
echo "***"
sleep 2s

# pull Whirlpool run times
echo -e "${RED}" 
echo "***"
echo "Pull Whirlpool from github"
echo "***"
echo -e "${NC}"
sleep 1s
wget https://github.com/Samourai-Wallet/whirlpool-runtimes/releases/download/cli-0.9.1/whirlpool-client-cli-0.9.1-run.jar
echo -e "${RED}"
echo "***"
echo "Download complete"
echo "***"
sleep 3s

# initate Whirlpool
echo -e "${RED}" 
echo "***"
echo "Initating Whirlpool...Be prepared to paste Whirlpool Pairing Code from Mobile Wallet and Passphrase"
echo "***"
echo -e "${NC}"
sleep 1s
java -jar whirlpool-client-cli-0.9.1-run.jar --init --tor
echo -e "${RED}"
echo "***"
echo "Initation complete"
echo "***"
sleep 3s

# display API pairing key for GUI
echo "Copy your APIkey to connect your GUI"
APIkey=$(sudo cat /home/$HOME/whirlpool/whirlpool-configuration | grep cli.Apikey= | cut -c 12-)
echo "***"
echo "$APIkey"
echo "***"
sleep 5s

# create whirlpool tmux session and start Whirlpool
echo -e "${RED}"
echo "***"
echo "Opening tmux session and Start Whirlpool"
echo "***"
echo -e "${NC}"
sleep 1s
tmux new -s whirlpool -d
sleep 1s
tmux send-keys -t 'whirlpool' "java -jar whirlpool-client-cli-0.9.1-run.jar --server=mainnet --tor --auto-mix --authenticate --mixs-target=0 --listen" ENTER
sleep 2s
echo -e "${YELLOW}"
echo "***"
echo "Entering tmux Whirlpool Session"
sleep 1s
echo -e "${YELLOW}"
echo "Type in your Wallet Passphrase when prompted"
sleep 3s
echo -e "${YELLOW}"
echo "***"
echo "After you see it running you can close by pressing the following:"
echo "Ctrl+b then d"
echo "***"
echo "For pairing with GUI head to full guide at https://github.com/BTCxZelko/Ronin-Dojo/blob/master/RPi4/Raspbian/Whirlpool-Guide.md#pairing-your-with-the-whirlpool-gui"
sleep 5s
tmux a -t 'whirlpool'
