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
Now you should see Electrs trying to connect to your Dojo's bitcoind. Once connected, Electrs will begin indexing the blockheaders, this can take 6-12 hours. 

NOTE: You will not be able to connect Electrum until fully synced. And you'll need to keep this terminal window open while this runs. We can utilize Tmux the same way we did in Whirlpool.

# 8. Tor Hidden Service

Let's get Electrs running behind a hidden service so we can connect from anywhere. 

### 1. Tor Status/ Install

Let's verify that tor is installed. If you already have Whirlpool running then it should be installed already.

```
tor --version
# Line 1 should say: Tor 0.4.1.6 
# if you get error then we need to install tor
sudo pacman -S tor
```
   * NOTE: Typically we do not install tor with sudo, however, manjaro automactically creates a new user for tor to keep seperate and installs as a systemctl function to keep running in background.

### 2. Edit torrc to include new hiddenservice

If you already completed Whirlpool guide and made edits to torrc then simply add the hidden service portion.

```
sudo nano /etc/tor/torrc
------------------------
# uncomment:
ControlPort 9051
CookieAuthentication 1

# add:
CookieAuthFileGroupReadable 1

# also add:
# Hidden Service for Electrum Server
HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServiceVersion 3
HiddenServicePort 50001 127.0.0.1:50001

# Save and exit: Ctrl+X, y, Enter
----------------------------------
sudo systemctl restart tor
```

Now we have the hidden service running.

### 3. Get new onion address for hidden  service

You will need this address to connect to your Electrum Desktop Client.

```
sudo cat /var/lib/tor/hidden_service/hostname
<your-onion-address>.onion
```

# 9. Install Electrum on Seperate Desktop

Install Electrum on Host device by following the steps at: https://electrum.org/#download

Now that Electrum is downloaded on your host device we are going to set it up to connect thru Tor (so if you don't have tor or tor browser set up do that now) Note: If you use tor browser the Port is 9051, tor service is 9050. 

# 10. Set up One Server Settings.

```
Once Electrum is downloaded it is important to make sure you are in the right env and PATH so the commands work properly:

```
PATH=$PATH:~/.local/bin
touch ~/.profile
export PATH
~/.profile
```

No we will start electrum but we will pass the one server flag to ensure it only connects to our Electrs server

Start electrum with the Tor Browser open (proxy on port 9150)

```
electrum --oneserver --server <your-onion-address>.onion:50001:t --proxy socks5:127.0.0.1:9150
# NOTE: Replace <your-onion-address> with your Electrs onion address from earlier #
```

With Tor installed and running (proxy on port 9050):
```
electrum --oneserver --server <your-onion-address>.onion:50001:t --proxy socks5:127.0.0.1:9050
# NOTE: Replace <your-onion-address> with your Electrs onion address from earlier #
```

Electrum will start as normal. 

Once at main page of wallet display look at the bottom right for a blue dot. If you see that then you are connect via Tor!

NOTE: This may take a few minutes or longer to spin up and index your Hardware wallets history depending on how many txs you have. 

# 11. DONE!

That's it! You are now connecting your hardware/cold storage wallet to your own personal server, back by your personal dojo, all routed through the Tor Network!

Congratulations you are now even more self-soverign. 
