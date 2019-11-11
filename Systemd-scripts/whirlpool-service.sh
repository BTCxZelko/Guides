#### Script to set Whirlpool as a Service running at boot ####
### You Must have already run the java -jar whirlpool-client-cli-0.9.1-run.jar --init command and directory is in ~/whirlpool ###
## Designed for Manjaro-ARM, feel free to modify as necessary ##

# initate Whirlpool
#echo -e "${CYAN}" 
#echo "***"
#echo "Initating Whirlpool...Be prepared to paste Whirlpool Pairing Code from Mobile Wallet and Passphrase"
#echo "***"
#echo -e "${NC}"
#sleep 1s
#java -jar whirlpool-client-cli-0.9.1-run.jar --init --tor
#sleep 3s

echo "Copy your APIkey to connect your GUI"
APIkey=$(sudo cat /home/$HOME/whirlpool/whirlpool-configuration | grep cli.Apikey= | cut -c 12-)
echo "$APIkey"
echo ""
sleep 2s

# setting whirlpool as a Service

USER=$(sudo cat /etc/passwd | grep 1000 | awk -F: '{ print $1}' | cut -c 1-)

#creating an executable file and making it executable

echo "
#!/bin/bash

cd /home/$USER/whirlpool

java -jar whirlpool-client-cli-0.9.1-run.jar --server=mainnet --tor --auto-mix --mixs-target=0 --listen
"| sudo tee -a /bin/whirlpool

sudo chmod +x /bin/whirlpool

# sudo nano /etc/systemd/system/whirlpool.service 
echo "
[Unit]
Description=Whirlpool
After=tor.service
[Service]
WorkingDirectory=/home/$USER/whirlpool
ExecStart=/bin/whirlpool
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

sudo systemctl enable whirlpool
sudo systemctl start whirlpool

echo ""
echo "***"
echo "Starting whirlpool in the background"
echo "***"
sleep 2s
echo "***"
echo "Pair with GUI to unlock wallet and begin mixing"
echo "$APIkey"
echo "***"
