# Optional Convenience Script - Default Dojo Setup 01
# By @GuerraMoneta
# Please note these scripts are intended for those that have similar hardware/OS and some experience
# ALWAYS analyze scripts before downloading and running them!!!

# Use a search function like Ctrl + F in browser to find "EDIT 1", "EDIT 2", "EDIT 3"...
# Give the script permission and run it when you are ready
# Use command $ chmod 555 NAME.sh
# Use command $ ./NAME.sh

YELLOW='\033[1;33m'
# used for color with ${YELLOW}
CYAN='\033[0;36m'
# used for color with ${CYAN}
NC='\033[0m' 
# No Color

# system setup starts
echo -e "${CYAN}"
echo "***"
echo "Installing Updates"
echo "***"
echo -e "${NC}"
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

echo -e "${CYAN}"
echo "***"
echo "Format the SSD"
echo "See comments of this script for help"
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
# system setup pauses here and resumes at the very end of this script

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

# pip setup starts
echo -e "${CYAN}"
echo "***"
echo "Installing the Python Package Installer and its dependencies"
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
# pip setup ends

# docker setup starts
echo -e "${CYAN}"
echo "***"
echo "Installing docker and docker-compose"
echo "***"
echo -e "${NC}"
sleep 5s

echo -e "${CYAN}"
echo "***"
echo "Downloading docker install script"
echo "Check git commit on line 19 https://github.com/docker/docker-install/blob/master/install.sh before executing"
echo "***"
echo -e "${NC}"
cd ~
curl -fsSL https://get.docker.com -o get-docker.sh
sleep 5s
# EDIT 3
# check git commit on line 19 here https://github.com/docker/docker-install/blob/master/install.sh
# do not trust, always verify!

echo -e "${CYAN}"
echo "***"
echo "Verify the contents of the script just you downloaded!!!"
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

# if Y/y then procees with install
if asksure; then
  echo -e "${CYAN}"
  echo "***"
  echo "Proceeding with install"
  echo "***"
  echo -e "${NC}"
  
echo -e "${CYAN}"
echo "***"
echo "Installing docker and docker-compose"
echo "***"
echo -e "${NC}"
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
echo "Take a look at what PIP has installed on your system"
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
sleep 3s
# docker setup ends

#system setup resumes here
echo -e "${CYAN}"
echo "***"
echo "Running setup-odroid in 10 seconds"
echo "Change root password, hostname" 
echo "This tool may ask you to reboot to apply the changes once you are finished"
echo "***"
echo -e "${NC}"
sleep 10s
setup-odroid
#system setup ends

else
  echo -e "${CYAN}"
  echo "***"
  echo "Exiting now"
  echo "***"
  echo -e "${NC}"
  # else exit script when N/n is pressed

fi
