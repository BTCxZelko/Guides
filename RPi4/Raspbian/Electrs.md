# Electrs - an Electrum Personal Server

Electrs is an Electrum Personal Server that is written in a code name called Rust. This implementation allows you to completely power your own Electrum Desktop Wallet using your Dojo Node, using only about 50GB of data (ElectrumX a similar program utilizes about 4x that).

So I elected to use this option so that users can connect their Hardware Wallets like Cold Card, Trezor, or Ledger to Electrum and not ruin their privacy by connecting to random Electrum Servers. 

Additionally, we will utilize Tor hiddenservice to be able to connect to your Personal Desktop from anywhere and add anonymity 

Source: https://github.com/romanz/electrs

# 1. Prepare Dojo

In order to connect to External Apps via RPC (like Electrs, Explorer, and LND) you'll need to modify the default settings of your Dojo. 

```
cd $HOME
cd dojo/docker/my-dojo/confs
sudo nano docker-bitcoind.conf
---------------
# Change Line 64 from: BITCOIND_RPC_EXTERNAL=off
# To: BITCOIND_RPC_EXTERNAL=on

Ctrl+X, y, Enter 
```

Now we need to restart Dojo in order for the changes to go into effect

```
cd $HOME
cd dojo/docker/my-dojo
sudo ./dojo.sh restart
```
   * This may take a few minutes as bitcoind is trying to properly shut down
   
# 2. Creating a New User for Electrs
As a means of enhancing your security. Lets go ahead and add a new user for Electrs only

```
sudo useradd -m electrs
# Create a password that you will remember
su electrs 
```

Now let's start installing stuff

# 3. Installing Rust and Clang

Electrs requires both Rust and Clang. So lets install those:

```
pacman -S rustup
rustup install stable
rustup default stable
pacman -S clang
```

# 4. Electrs Database dir

Before we get too far ahead of ourselves let's make the db where Electrs will store all its blockheaders and majority of data.

```
sudo mkdir /mnt/usb/electrs
sudo mkdir /mnt/usb/electrs/db
```

Now we are set to pull the respository and install Electrs

# 5. Installing Electrs

```
cd $HOME
git clone https://github.com/romanz/electrs
cd electrs
cargo build --release
```

Now this may take about 20-30 minutes so let that run, get some coffee and then we can pick up from here. 

# 6. Configuring Electrs

```
nano /home/electrs/.electrs/config.toml
---------------------------------------
# Paste the following in the file:
verbose = 4
timestamp = true
jsonrpc_import = true
db_dir = "/mnt/usb/electrs/db"
cookie = "DOJO_RPC_USER:DOJO_RPC_PASS" ## REPLACE with Your Dojo RPC Username and Password. 

Ctrl+X, y, Enter
```
Ok we are all set to spin this up

# 7. Start Electrs

```
cd /home/electrs/electrs
cargo run --release -- -vvv --timestamp  --index-batch-size=100 --db-dir /mnt/usb/electrs/db --electrum-rpc-addr="0.0.0.0:50001" --daemon-rpc-addr="127.0.0.1:28256"
```
Now you should see Electrs trying to connect to your Dojo's bitcoind 

# 8. Tor Hidden Service

# 9. Install Electrum on Seperate Desktop

# 10. Set up One Server Settings.
