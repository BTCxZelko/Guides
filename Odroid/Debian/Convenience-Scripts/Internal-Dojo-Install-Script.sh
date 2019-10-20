## Optional Convenience Script - Default Dojo Setup
## By @GuerraMoneta

## Deploy a Dojo and begin syncing the blockchain in ~30 minutes
## Intended for Odroid N2 + Debian Stretch
## https://github.com/s2l1/Headless-Samourai-Dojo/blob/master/Default_Dojo_Setup.md#1-hardware-requirements

## Instructions:
# Do not include the "$" when typing a command! The "$" simply marks that something is a command.

# 1.
# Flash the OS on to SD card and boot up your odroid
# SSH in or login once powered on, make sure external drive is plugged in
# $ ssh root@IP.ADDRESS.ODROID.HERE
# Username: root
# Password: odroid

# 2.
# Install updates, sudo, and curl
# $ apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y
# $ apt-get install sudo curl -y

# 3.
# Run setup-odroid
# $ setup-odroid
# Change hostname, password
# May ask to restart the odroid

# 4.
# Download script
# Always analyze scripts before downloading and running them!!!
# $ curl https://raw.githubusercontent.com/BTCxZelko/Ronin-Dojo/master/Odroid/Debian/Convenience-Scripts/Internal-Dojo-Install-Script.sh -o Internal-Dojo-Install-Script.sh

# 5.
# Take note of EDITs, and input your desires values
# Use a search function like Ctrl + F in browser to find "EDIT 1", "EDIT 2", "EDIT 3"...
# Use nano to change "XXX" to your desired values
# $ nano ./Default_Dojo_Setup_Script.sh

# Find "EDIT 1" and make sure you dont lock yourself out of SSH with an incorrect IP address range
# Find "EDIT 2" and "EDIT 3" and take note of the scripts used
# Find "EDIT 4" "EDIT 5" "EDIT 6" and replace "XXX" with whatever you want, but make it secure

# 6.
# Go root, give the script permission, and run it using ./ when you are ready
# $ sudo su -
# $ chmod 555 Default_Dojo_Setup_Script.sh
# $ ./Internal-Dojo-Install-Script.sh
# When you are finished type "exit" to leave root

# 7.
# When the script begins it will ask you to format the SSD.
# Press 'd'
# Press 'w'
# Wait a moment for fdisk
# Press 'n'
# Press 'p'
# Press '1'
# Press 'enter'
# Press 'enter'
# May ask if you want to remove a signature? type yes
# Press 'w'

# 8.
# The script will take a few minutes to run from here
# You will need to select a timezone and have few Y/N to input, so you must be present for the script to finish
# Find "EDIT 2" and "EDIT 3" and take note of the scripts used
# The installer will remind you to verify scripts. Answer Y/y once you are ready
# If you choose N/n to exit the script, the script will be modified to resume at docker/docker-compose install

# 9.
# Once Dojo is installed wait for bitcoind to sync or copy the data over from another machine
# https://github.com/s2l1/Headless-Samourai-Dojo/blob/master/Default_Dojo_Setup.md#11-scp
#
# 10.
# Now would also be a great time to add new user with sudo and lock the root account
# Use adduser command to manually add user
# $ adduser XXX

# Give user "XXX" the ability to use sudo
# $ adduser XXX sudo

# Lock the root account
# $ passwd -l root

# Modify passwd command to -u if you need to unlock the root account
# $ passwd -u root

# Go ahead and restart the odroid
# $ shutdown -r now

# Login using your new user instead of root
# Have fun!
##
##
YELLOW='\033[1;33m'
# used for color with ${YELLOW}
CYAN='\033[0;36m'
# used for color with ${CYAN}
NC='\033[0m'
# No Color

# system setup starts
echo -e "${CYAN}"
echo "***"
echo "Format the SSD"
echo "See instructions and comments of this script for help"
echo "***"
echo -e "${NC}"
sleep 10s
fdisk /dev/sda
# delete existing drive partition
# Press 'd'
# Press 'w'
sleep 2s
fdisk /dev/sda
# create new primary drive partition
# Press 'n'
# Press 'p'
# Press '1'
# Press 'enter'
# Press 'enter'
# May ask if you want to remove a signature? type yes
# Press 'w'

echo -e "${CYAN}"
echo "***"
echo "Using ext4 format, partition1, /dev/sda1"
echo "***"
echo -e "${NC}"
sleep 5s
mkfs.ext4 /dev/sda1
# format partion 1 to ext4

echo -e "${CYAN}"
echo "***"
echo "Displaying the name on the external disk"
echo "***"
echo -e "${NC}"
lsblk -o UUID,NAME,FSTYPE,SIZE,LABEL,MODEL
# double-check that /dev/sda exists, and that its storage capacity is what you expected
sleep 10s

echo -e "${CYAN}"
echo "***"
echo "Editing /etc/fstab to input UUID for sda1 and settings"
echo "***"
echo -e "${NC}"
sleep 5s
lsblk -o UUID,NAME | grep sda1 >> ~/uuid.txt
# this will look up uuid of sda1 and makes txt file with that value
sed -i 's/ └─sda1//g' ~/uuid.txt
# removes the text sda1 after the uuid in txt file
sed -i 1's|$| /mnt/usb ext4 rw,nosuid,dev,noexec,noatime,nodiratime,auto,nouser,async,nofail 0 2 &|' ~/uuid.txt
# adds a necessary line with the path and other options after the uuid in txt file
sed -i 's/^/UUID=/' ~/uuid.txt
# adds UUID= prefix to the front of the line
cat ~/uuid.txt >> /etc/fstab
# adds the line to fstab
rm ~/uuid.txt
# delete txt file

echo -e "${CYAN}"
echo "***"
echo "Creating /mnt/usb"
echo "***"
echo -e "${NC}"
mkdir /mnt/usb
sleep 3s

echo -e "${CYAN}"
echo "***"
echo "Mounting all drives"
echo "***"
echo -e "${NC}"
sleep 3s
mount -a

echo -e "${CYAN}"
echo "***"
echo "Check output for /dev/sda1"
echo "***"
echo -e "${NC}"
df -h
sleep 10s

echo -e "${CYAN}"
echo "***"
echo "Installing fail2ban, git, curl, unzip, net-tools, and others recommended"
echo "***"
echo -e "${NC}"
sleep 5s
apt-get install fail2ban -y
apt-get install git -y
apt-get install curl -y
apt-get install unzip -y
apt-get install net-tools -y

echo -e "${CYAN}"
echo "***"
echo "Set your timezone"
echo "***"
echo -e "${NC}"
sleep 5s
dpkg-reconfigure tzdata
# system setup ends

# ufw setup starts
echo -e "${CYAN}"
echo "***"
echo "Installing ufw and setting up rules"
echo "***"
echo -e "${NC}"
sleep 5s
apt-get install ufw -y
ufw default deny incoming
ufw default allow outgoing
# EDIT 1
# take note of the following lines that start with ufw allow from 192.168.0.0/24
# these 2 lines assume that the IP address of your ODROID is something like 192.168.0.???
# if your IP address is 12.34.56.78, you must adapt this line to ufw allow from 12.34.56.0/24
ufw allow from 192.168.0.0/24 to any port 22 comment 'SSH access restricted to local LAN only'
ufw allow from 192.168.0.0/24 to any port 8899 comment 'allow whirlpool-gui on local network to access whirlpool-cli on Odroid'

echo -e "${CYAN}"
echo "***"
echo "Enabling ufw"
echo "Check settings if connection failure"
echo "See script comments for EDIT 1 if needed"
echo "***"
echo -e "${NC}"
sleep 5s
ufw enable
systemctl enable ufw

echo -e "${CYAN}"
echo "***"
echo "Checking ufw status"
echo "***"
echo -e "${NC}"
ufw status
sleep 5s

echo -e "${CYAN}"
echo "***"
echo "Take a moment to look at the rules that were just created"
echo "***"
echo -e "${NC}"
sleep 20s
# ufw setup ends

# python3 and pip setup starts
echo -e "${CYAN}"
echo "***"
echo "Installing Python3, Python Package Installer, and dependencies"
echo "***"
echo -e "${NC}"
sleep 5s
cd ~
apt-get install python3-dev -y
apt-get install libffi-dev -y
apt-get install libssl-dev -y
apt-get install build-essential -y
# these are useful libs in general for your system
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
# EDIT 2
# get-pip.py is a convenient script, be sure to check it out before running!!!
python3 get-pip.py
# python3 and pip setup ends

echo -e "${CYAN}"
echo "***"
echo "Creating symlink for python/python3"
echo "***"
echo -e "${NC}"
sleep 3s
ln -s /usr/bin/python3 /usr/bin/python
# python2 is deprecated anyway so having the symlink to python3 is the way forward
# which python3 shows directory it is located in

# docker setup starts
echo -e "${CYAN}"
echo "***"
echo "Preparing docker and docker-compose install"
echo "***"
echo -e "${NC}"
sleep 3s

echo -e "${CYAN}"
echo "***"
echo "Downloading docker install script"
echo "Check the git commit for get-docker.sh script!!!"
echo "***"
echo -e "${NC}"
cd ~
curl -fsSL https://get.docker.com -o get-docker.sh
sleep 5s
# EDIT 3
# is a convenient script, be sure to check it out before running!!!
# check the git commit which shows when get-docker.sh script is run
# see line 19 here https://github.com/docker/docker-install/blob/master/install.sh
# do not trust, always verify!

echo -e "${CYAN}"
echo "***"
echo "Did you verify the contents of the script just you downloaded?"
echo "***"
echo -e "${NC}"
sleep 5s

asksure() {
echo -e "${YELLOW}"
echo "***"
echo "Press Y/y if you are ready to proceed"
echo "Press N/n to exit"
echo "***"
echo -e "${NC}"

while read -r -n 1 -s answer; do
  if [[ $answer = [YyNn] ]]; then
    [[ $answer = [Yy] ]] && retval=0
    [[ $answer = [Nn] ]] && retval=1
    break
  fi
done

return $retval
}

# if Y/y then proceed with install
# if N/n scroll to bottom and see else
if asksure; then
  echo -e "${CYAN}"
  echo "***"
  echo "Proceeding with install"
  echo "***"
  echo -e "${NC}"
  sleep 3s

echo -e "${CYAN}"
echo "***"
echo "Installing docker and docker-compose"
echo "The get-docker.sh script will show git commit for you to verify"
echo "***"
echo -e "${NC}"
# script resumes from here if you choose N/n to exit
sleep 5s
sh get-docker.sh
python3 -m pip install --upgrade docker-compose

echo -e "${CYAN}"
echo "***"
echo "Checking docker version"
echo "***"
echo -e "${NC}"
docker -v
sleep 5s

echo -e "${CYAN}"
echo "***"
echo "Check PIP list for docker-compose"
echo "***"
echo -e "${NC}"
python3 -m pip list
sleep 10s

echo -e "${CYAN}"
echo "***"
echo "Now configuring docker to use the external SSD"
echo "***"
echo -e "${NC}"
sleep 5s
mkdir /mnt/usb/docker
echo "{" > /etc/docker/daemon.json
echo '                  "data-root": "/mnt/usb/docker"' >> /etc/docker/daemon.json
echo "}" >> /etc/docker/daemon.json
# using echo > to create file with first line, then using echo >> to append following two lines

echo -e "${CYAN}"
echo "***"
echo "Restarting docker"
echo "***"
echo -e "${NC}"
systemctl daemon-reload
sleep 5s
# sleep here to avoid error systemd[1]: Failed to start Docker Application Container Engine
# see systemctl status docker.service and journalctl -xe for details on error
systemctl stop docker
sleep 3s
systemctl start docker

echo -e "${CYAN}"
echo "***"
echo "Check that docker is using the SSD"
echo "***"
echo -e "${NC}"
sleep 3s
docker info | grep "Docker Root Dir:"
sleep 5s

echo -e "${CYAN}"
echo "***"
echo "Try rebooting if you do not see your SSD listed"
echo "***"
echo -e "${NC}"
sleep 5s
# docker setup ends

# start dojo setup
echo -e "${CYAN}"
echo "***"
echo "Downloading and extracting latest Dojo release"
echo "***"
echo -e "${NC}"
cd ~
sleep 5s
curl -fsSL https://github.com/Samourai-Wallet/samourai-dojo/archive/master.zip -o master.zip
unzip master.zip
sleep 3s

echo -e "${CYAN}"
echo "***"
echo "Making dojo_dir/ and copying data"
echo "***"
echo -e "${NC}"
sleep 5s
mkdir dojo_dir
cp -rv samourai-dojo-master/* dojo_dir/
sleep 3s

echo -e "${CYAN}"
echo "***"
echo "Removing all the files we no longer need"
echo "***"
echo -e "${NC}"
sleep 5s
rm -rvf samourai-dojo-master/ master.zip get-pip.py get-docker.sh
sleep 3s

echo -e "${CYAN}"
echo "***"
echo "Editing the bitcoin docker file, using the aarch64-linux-gnu.tar.gz source"
echo "***"
echo -e "${NC}"
sed -i '9d' ~/dojo_dir/docker/my-dojo/bitcoin/Dockerfile
sed -i '9i             ENV     BITCOIN_URL         https://bitcoincore.org/bin/bitcoin-core-0.18.1/bitcoin-0.18.1-aarch64-linux-gnu.tar.gz' ~/dojo_dir/docker/my-dojo/bitcoin/Dockerfile
sed -i '10d' ~/dojo_dir/docker/my-dojo/bitcoin/Dockerfile
sed -i '10i             ENV     BITCOIN_SHA256      88f343af72803b851c7da13874cc5525026b0b55e63e1b5e1298390c4688adc6' ~/dojo_dir/docker/my-dojo/bitcoin/Dockerfile
sleep 5s
# method used with the sed command is to delete entire lines 9, 10 and add new lines 9, 10
# double check ~/dojo_dir/docker/my-dojo/bitcoin/Dockerfile

echo -e "${CYAN}"
echo "***"
echo "Editing mysql dockerfile to use a compatible database"
echo "***"
echo -e "${NC}"
sed -i '1d' ~/dojo_dir/docker/my-dojo/mysql/Dockerfile
sed -i '1i             FROM    mariadb:latest' ~/dojo_dir/docker/my-dojo/mysql/Dockerfile
sleep 5s
# method used with the sed command is to delete line 1 and add new line 1
# double check ~/dojo_dir/docker/my-dojo/mysql/Dockerfile

echo -e "${CYAN}"
echo "***"
echo "Configuring your Dojo installation by editing all 3 .conf.tpl files"
echo "***"
echo -e "${NC}"
sleep 5s
# this script may be broken during updates if changes are made to the .conf.tpl files
# example is username and password are on lines 7 and 11, if that changed the sed commands would not work properly
# may need to go back and check line by line for if there is failure here, or different method

sed -i '7d' ~/dojo_dir/docker/my-dojo/conf/docker-bitcoind.conf.tpl
sed -i '7i BITCOIND_RPC_USER=XXX' ~/dojo_dir/docker/my-dojo/conf/docker-bitcoind.conf.tpl
sed -i '11d' ~/dojo_dir/docker/my-dojo/conf/docker-bitcoind.conf.tpl
sed -i '11i BITCOIND_RPC_PASSWORD=XXX' ~/dojo_dir/docker/my-dojo/conf/docker-bitcoind.conf.tpl
# EDIT 4
# replace the XXX in BITCOIND_RPC_USER=XXX and BITCOIND_RPC_PASSWORD=XXX
# method used with the sed command is to delete lines 7, 11 and add new lines 7, 11
# make it secure like any other password
# keep in mind that BITCOIND_RPC_USER and BITCOIND_RPC_PASSWORD need to match what is in the ~/.bitcoin/bitcoin.conf

sed -i '7d' ~/dojo_dir/docker/my-dojo/conf/docker-mysql.conf.tpl
sed -i '7i MYSQL_ROOT_PASSWORD=XXX' ~/dojo_dir/docker/my-dojo/conf/docker-mysql.conf.tpl
sed -i '11d' ~/dojo_dir/docker/my-dojo/conf/docker-mysql.conf.tpl
sed -i '11i MYSQL_USER=XXX' ~/dojo_dir/docker/my-dojo/conf/docker-mysql.conf.tpl
sed -i '15d' ~/dojo_dir/docker/my-dojo/conf/docker-mysql.conf.tpl
sed -i '15i MYSQL_PASSWORD=XXX' ~/dojo_dir/docker/my-dojo/conf/docker-mysql.conf.tpl
# EDIT 5
# replace each XXX with your desired value
# method used with the sed command is to delete lines 7, 11, 15 and add new lines 7, 11, 15

sed -i '9d' ~/dojo_dir/docker/my-dojo/conf/docker-node.conf.tpl
sed -i '9i NODE_API_KEY=XXX' ~/dojo_dir/docker/my-dojo/conf/docker-node.conf.tpl
sed -i '15d' ~/dojo_dir/docker/my-dojo/conf/docker-node.conf.tpl
sed -i '15i NODE_ADMIN_KEY=XXX' ~/dojo_dir/docker/my-dojo/conf/docker-node.conf.tpl
sed -i '21d' ~/dojo_dir/docker/my-dojo/conf/docker-node.conf.tpl
sed -i '21i NODE_JWT_SECRET=XXX' ~/dojo_dir/docker/my-dojo/conf/docker-node.conf.tpl
# EDIT 6
# replace each XXX with your desired value
# method used with the sed command is to delete lines 9, 15, 21 and add new lines 9, 15, 21

echo -e "${CYAN}"
echo "***"
echo "Installing Dojo"
echo "***"
echo -e "${NC}"
sleep 5s
cd ~/dojo_dir/docker/my-dojo
./dojo.sh install
# end dojo setup
# if logs look good go ahead and copy over blockchain data, see instructions at top

  else
  echo -e "${CYAN}"
  echo "***"
  echo "Modifying script to start from docker and docker-compose install next run"
  echo "***"
  echo -e "${NC}"
  sleep 5s

  echo -e "${CYAN}"
  echo "***"
  echo "Exiting now"
  echo "***"
  echo -e "${NC}"
  sleep 3s
  # else exit script when N/n is pressed

  sed -i "103,339d" ~/Internal-Dojo-Install-Script.sh
  # delete lines because N/n was chosen, will start again at docker/docker-compose install

fi
