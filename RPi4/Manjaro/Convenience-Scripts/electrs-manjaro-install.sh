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
cd $HOME
sudo pacman -S rustup -y
rustup toolchain install nightly-2018-12-27
cargo +nightly-2018-12-27 build
sudo pacman -S clang -y
sleep 1s
echo "***"
echo "Installation Complete"
echo "***"
sleep 3s

# Make electrs database dir
echo -e "${CYAN}" 
echo "***"
echo "Creating Database location for Electrs"
echo "***"
echo -e "${NC}"
sleep 1s
List usernames
USER=${NONROOTUSER}
sudo mkdir /mnt/usb/electrs
sudo mkdir /mnt/usb/electrs/db
sudo chown -R $USER:$USER /mnt/usb/electrs/
sudo chmod 755 /mnt/usb/electrs/
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
RPC_USER=$(sudo cat ~/dojo/docker/my-dojo/conf/docker-bitcoind.conf | grep BITCOIND_RPC_USER= | cut -c 19-)
RPC_PASS=$(sudo cat ~/dojo/docker/my-dojo/conf/docker-bitcoind.conf | grep BITCOIND_RPC_PASSWORD= | cut -c 23-)
mkdir /home/$USER/electrs/.electrs
touch /home/$USER/electrs/.electrs/config.toml
sed -i '1i verbose = 4'
sed -i '2i timestamp = true'
sed -i '3i jsponrpc_import = true'
sed -i '4i db_dir = "/mnt/usb/electrs/db"'
sed -i '5i cookie = "$RPC_USER:$RPC_PASS"'
sleep 3s

# edit torrc
echo -e "${CYAN}" 
echo "***"
echo "Editting torrc..."
echo "***"
echo -e "${NC}"
sleep 1s
sed -i '87i HiddenServiceDir /var/lib/tor/hidden_service/electrs' /etc/tor/torrc
sed -i '88i HiddenServiceVersion 3' /etc/tor/torrc
sed -i '89i HiddenServicePort 50001 127.0.0.1:50001' /etc/tor/torrc
sudo systemctl restart tor
echo -e "${CYAN}"
echo "***"
echo "Edit complete"
sleep 3s

# create Electrs tmux session and start Electrs
echo -e "${CYAN}"
echo "***"
echo "Starting up Electrs..."
echo "***"
echo -e "${NC}"
sleep 1s
tmux new -s electrs -d
sleep 1s
cd /home/$USER/electrs
tmux send-keys -t 'electrs' "cargo run --release -- -vvv --timestamp  --index-batch-size=100 --db-dir /mnt/usb/electrs/db --electrum-rpc-addr="0.0.0.0:50001" --daemon-rpc-addr="127.0.0.1:28256""
sleep 5s
echo -e "${YELLOW}
echo "***"
echo "Electrs is officially running!"
sleep 5s
echo "See the full guide at https://github.com/BTCxZelko/Ronin-Dojo/blob/master/RPi4/Manjaro/Minimal/Electrs.md"

echo -e "${CYAN}"
echo "***"
echo "Exiting now"
echo "***"
echo -e "${NC}"
sleep 3s


