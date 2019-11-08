YELLOW='\033[1;33m'
# used for color with ${YELLOW}
CYAN='\033[0;36m'
# used for color with ${CYAN}
NC='\033[0m'
# No Color

echo -e "${YELLOW}"
echo "***"
echo "Welcome to Ronin Dojo - Electrs Install"
echo "By @BTCxZelko"
echo "***"
sleep 3s
echo -e "${CYAN}"
echo "***"
echo "Install and run Electrs as a Personal Server for Electrum to connect your Hardware Wallets"
echo "Intended for Raspberry Pi 4-4GB RAM + Manjaro Minimal"
echo "***"
sleep 5s

# Prepare Dojo
echo -e "${CYAN}" 
echo "***"
echo "Editting Dojo to allow for External Apps..."
echo "***"
echo -e "${NC}"
sleep 1s
sed -i '64d' 
sed -i '64i BITCOIND_RPC_EXTERNAL=on' ~/dojo/docker/my-dojo/conf/docker-bitcoind.conf
sleep 2s
echo -e "${CYAN}" 
echo "***"
echo "Edit Complete"
echo "***"

# Restart Dojo
echo -e "${CYAN}"
echo "***"
echo "Restart Dojo to enable change"
echo "***"
echo -e "${NC}"
sleep 1s
cd $HOME
cd dojo/docker/my-dojo
sudo ./dojo.sh restart
sleep 3s

# Install Rust and Clang
echo -e "${CYAN}" 
echo "***"
echo "Installing Rust and Clang for Electrs"
echo "***"
echo -e "${NC}"
sleep 1s
USER=$(sudo cat /etc/passwd | grep 1000 | awk -F: '{ print $1}' | cut -c 1-)
cd $HOME
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup install 1.37.0 --force
rustup override set 1.37.0
sudo pacman -S clang -y
sleep 1s
echo "***"
echo "Installation Complete"
echo "***"
sleep 3s

# Make electrs database dir and give permissions
echo -e "${CYAN}" 
echo "***"
echo "Creating Database location for Electrs"
echo "***"
echo -e "${NC}"
sleep 1s
sudo mkdir /mnt/usb/electrs
sudo mkdir /mnt/usb/electrs/db
sudo chown -R $USER:$USER /mnt/usb/electrs/
sudo chmod 755 /mnt/usb/electrs/
sudo chmod 755 /mnt/usb/electrs/db
echo -e "${CYAN}"
echo "***"
echo "Done"
sleep 3s

# Installing Electrs
echo -e "${CYAN}" 
echo "***"
echo "Installing Electrs...this may take some time"
echo "***"
echo -e "${NC}"
sleep 1s
cd $HOME
git clone https://github.com/romanz/electrs /home/$USER/electrs
cd /home/$USER/electrs
cargo build --release
echo -e "${CYAN}"
echo "***"
echo "Installation complete"
sleep 3s

# Configure Electrs
echo -e "${CYAN}" 
echo "***"
echo "Edit the Electrs config.toml"
echo "***"
echo -e "${NC}"
sleep 1s
RPC_USER=$(sudo cat /home/$USER/dojo/docker/my-dojo/conf/docker-bitcoind.conf | grep BITCOIND_RPC_USER= | cut -c 19-)
RPC_PASS=$(sudo cat /home/$USER/dojo/docker/my-dojo/conf/docker-bitcoind.conf | grep BITCOIND_RPC_PASSWORD= | cut -c 23-)
sudo mkdir /home/electrs/.electrs
touch /home/$USER/config.toml
chmod 600 /home/$USER/config.toml || exit 1 
cat > /home/$USER/config.toml <<EOF
verbose = 4
timestamp = true
jsonrpc_import = true
db_dir = "/mnt/usb/electrs/db"
cookie = "$RPC_USER:$RPC_PASS"
EOF
sudo mv /home/$USER/config.toml /home/$USER/.electrs/config.toml
sleep 3s

# edit torrc
echo -e "${CYAN}" 
echo "***"
echo "Editting torrc..."
echo "***"
echo -e "${NC}"
sleep 1s
sudo sed -i '78i HiddenServiceDir /mnt/usb/tor/hidden_service/' /etc/tor/torrc
sudo sed -i '79i HiddenServiceVersion 3' /etc/tor/torrc
sudo sed -i '80i HiddenServicePort 50001 127.0.0.1:50001' /etc/tor/torrc
echo -e "${CYAN}"
echo "***"
echo "Edit complete"
sleep 1s
echo "Restarting Tor"
sudo systemctl restart tor
sleep 1s
echo "Restart Complete"

# create Electrs tmux session and start Electrs
echo -e "${CYAN}"
echo "***"
echo "Starting up Electrs..."
echo "***"
echo -e "${NC}"
sleep 1s
cd /home/$USER/electrs
tmux new -s electrs -d
sleep 1s
cd /home/$USER/electrs
tmux new -s electrs -d
tmux send-keys -t 'electrs' "cargo run --release -- -vvv --timestamp  --index-batch-size=100 --db-dir /mnt/usb/electrs/db --electrum-rpc-addr="0.0.0.0:50001" --daemon-rpc-addr="127.0.0.1:28256"" ENTER
sleep 5s
echo -e "${YELLOW}"
echo "***"
echo "Electrs is officially running!"
sleep 5s
echo "For pairing with GUI head to full guide at https://github.com/BTCxZelko/Ronin-Dojo/blob/master/RPi4/Manjaro/Minimal/Electrs.md"

echo -e "${CYAN}"
echo "***"
echo "Exiting now"
echo "***"
echo -e "${NC}"
sleep 3s
