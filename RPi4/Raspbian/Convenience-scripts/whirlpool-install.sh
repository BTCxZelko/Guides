YELLOW='\033[1;33m'
# used for color with ${YELLOW}
CYAN='\033[0;36m'
# used for color with ${CYAN}
NC='\033[0m'
# No Color

echo -e "${YELLOW}"
echo "***"
echo "Welcome to Ronin Dojo Whirlpool Install"
echo "By @BTCxZelko"
echo "***"
sleep 3s
echo -e "${CYAN}"
echo "***"
echo "Install and run Whirlpool Client CLI for continuous mixing"
echo "Intended for Raspberry Pi 4-4GB RAM + Raspbian"
echo "***"
sleep 5s

# install instal openjdk
echo -e "${CYAN}"
echo "***"
echo "Installing Whirlpool Dependencies"
echo "***"
echo -e "${NC}"
sleep 3s
sudo apt-get install openjdk-8-jre
sleep 5s

# install instal openjdk
echo -e "${CYAN}"
echo "***"
echo "Installing tmux"
echo "***"
echo -e "${NC}"
sleep 3s
sudo apt-get install tmux
sleep 5s

# create whirlpool directory
echo -e "${CYAN}" 
echo "***"
echo "Creating Whirlpool working directory"
echo "***"
echo -e "${NC}"
sleep 1s
cd $HOME
#mkdir whirlpool
cd whirlpool
sleep 3s

# pull Whirlpool run times
echo -e "${CYAN}" 
echo "***"
echo "Pull Whirlpool from github"
echo "***"
echo -e "${NC}"
sleep 1s
wget https://github.com/Samourai-Wallet/whirlpool-runtimes/releases/download/cli-0.9.1/whirlpool-client-cli-0.9.1-run.jar
echo -e "${CYAN}"
echo "***"
echo "Download complete"
sleep 3s

# create whirlpool tmux session
#echo -e "${CYAN}" 
#echo "***"
#echo "Opening tmux session"
#echo "***"
#echo -e "${NC}"
#sleep 1s
#tmux new -s whirlpool
#sleep 3s

# initate Whirlpool
echo -e "${CYAN}" 
echo "***"
echo "Initating Whirlpool...Be prepared to paste Whirlpool Pairing Code from Mobile Wallet and Passphrase"
echo "***"
echo -e "${NC}"
sleep 1s
java -jar whirlpool-client-cli-0.9.1-run.jar --init --tor
sleep 3s

# start Whirlpool
echo -e "${CYAN}" 
echo "***"
echo "Starting Whirlpool...Be prepared to enter Mobile Wallet passphrase"
echo "***"
echo -e "${NC}"
sleep 1s
java -jar whirlpool-client-cli-0.9.1-run.jar --server=mainnet --tor --auto-mix --authenticate --mixs-target=0 --listen
sleep 3s

# close Whirlpool tmux session
echo -e "${CYAN}" 
echo "***"
echo "Detach from tmux Whirlpool Session..."
each "***"
echo "press Ctrl+b, d"
echo "see guide for GUI pairing at https://github.com/BTCxZelko/Ronin-Dojo/blob/master/RPi4/Raspbian/Whirlpool-Guide.md"
