# Optional Convenience Script - Default Dojo Setup 02
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
# make sure the version and hash are up to date

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
# EDIT 1
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
# EDIT 2
# replace each XXX with your desired value
# method used with the sed command is to delete lines 7, 11, 15 and add new lines 7, 11, 15

sed -i '9d' ~/dojo_dir/docker/my-dojo/conf/docker-node.conf.tpl
sed -i '9i NODE_API_KEY=XXX' ~/dojo_dir/docker/my-dojo/conf/docker-node.conf.tpl
sed -i '15d' ~/dojo_dir/docker/my-dojo/conf/docker-node.conf.tpl
sed -i '15i NODE_ADMIN_KEY=XXX' ~/dojo_dir/docker/my-dojo/conf/docker-node.conf.tpl
sed -i '21d' ~/dojo_dir/docker/my-dojo/conf/docker-node.conf.tpl
sed -i '21i NODE_JWT_SECRET=XXX' ~/dojo_dir/docker/my-dojo/conf/docker-node.conf.tpl
# EDIT 3
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
# if logs look good go ahead and copy over blockchain data
