# Ronin Dojo Internal Install Guide

## 1. Format your external disk to "ext4" or "btrfs" and mount it

Raspberry Pi 4 boots from and works with a microSD card. While card sizes are getting increasingly bigger and you can get big enough SD cards to hold the entire blockchain as of today, SD Cards are not reliable long term storage and they have limited lives. Best to go with an external drive. I'd suggest going with 1 TB of external storage.

Attach your external storage through one of the USB 3.0 ports. This will attach your storage to the default /media/yourusername/yourexternalstorage location. It's better to make a seperate attachment point for it and make sure your Pi 4 attaches the external disk to the same location every time you reboot.

If you have bought a ready external drive, there's a very good chance that it's formatted to NTFS - that will not work for us. Let's check:

```
sudo lsblk -f

## SAMPLE OUTPUT ##

NAME        FSTYPE LABEL     UUID                                 FSAVAIL FSUSE% MOUNTPOINT
sda                                                                              
└─sda1      ntfs   ELEMENTS  B0FECF48FECF0616                                    
mmcblk0                                                                          
├─mmcblk0p1 vfat   boot      F661-303B                               213M    15% /boot
└─mmcblk0p2 ext4   rootfs    8d008fde-f12a-47f7-8519-197ea707d3d4   12.6G     8% /
```

You will get something like the above. "mmcblk0" is your SD card. "sda" is your disk and "sda1" is your single partition on that disk. 

The following will remove your single partition from your external disk (/dev/sda - without the last number at the end), create a single primary partition and write all the changes to disk. If you have more than one partition, consult the fdisk command help to delete all and create a single partition.

```
sudo umount /dev/sda1        #We're unmounting the disk before doing anything to it
sudo fdisk /dev/sda          #Firing up fdisk app with /dev/sda as target (no "1" at the end)

## Press the following keys at each prompt to wipe the disk clean and create a fresh partition:

d, n, p, 1, Enter, Enter, Y, w  #The Yes/No prompt will be shown if you are working on an NTFS disk

sudo mkfs.ext4 /dev/sda1      #This will format your disk to "ext4" filesystem
```

Now we need to make it so that we tell the system to mount it to the same location at every boot, automatically. We'll do this by editing the /etc/fstab file and remounting everything.

```
sudo blkid
```

*In the device list that appears find your external disk (probably /dev/sda1)*

**Copy the UUID of it (something like "8d008fde-f12a-47f7-8519-197ea707d3d4").** 

Next, create a directory to mount the disk to and edit /etc/fstab file:

```
sudo mkdir /mnt/usb
sudo nano /etc/fstab
```

Add the following line at the end:

```
UUID=That_UUID_You_Just_Copied  /mnt/usb  ext4  defaults   0   0
```
> For those new to linux you can paste from your clipboard into terminal/command line with Ctrl+Shift+V

**Save and exit with Ctrl+X, Y, Enter**

Then mount everything specified in fstab with:

```
sudo mount -a
```

## 2. Install Docker

As of this writing (Sept 13, 2019) the docker included in Raspbian DOES NOT WORK. DO NOT INSTALL IT!
Use the convenience script located [here](https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-convenience-script)

```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

## 3. Install docker-compose through the package manager

```
sudo apt-get install docker-compose
```

## 4. Configure docker to use the external disk:

```
sudo nano /etc/docker/daemon.json  #This will appear as a new file
```

Copy and Paste the following (edit if you named your HDD/SSD something other than usb)
```
{ 
                  "data-root": "/mnt/usb/docker" 
} 
```
**NOTE: Keep all characters simply copy and paste** 
> For those new to linux you can paste from your clipboard into terminal/command line with Ctrl+Shift+V

**Save and exit with Ctrl+X, Y, Enter**

## 5. Restart docker to accept changes 

```
sudo systemctl stop docker
sudo systemctl daemon-reload 
sudo systemctl start docker 
```

## 6. Check that docker is using the external disk

```
sudo docker info | grep "Docker Root Dir:" 

## SAMPLE OUTPUT

 Docker Root Dir: /mnt/usb/docker
```

## 7. Pull and Configure Dojo repo (v1.2 at time of writing)
```
mkdir temp_dojo
mkdir dojo
cd temp_dojo
git clone https://github.com/Samourai-Wallet/samourai-dojo.git
cd
mv samourai-dojo/* dojo/
```
## 8. Now all your Dojo documents are all in your permenant Dojo Directory. Let's go in an modify the confs for you

### 1. First bitcoid conf file
```
cd dojo/docker/my-dojo/conf
nano docker-bitcoind.conf.tpl
-----------
BITCOIND_RPC_USER=dojorpc  <-- edit
BITCOIND_RPC_PASSWORD=dojorpcpassword  <-- edit (alphanumerical, NO SYMBOLS)
-----------
```
**Save and exit with Ctrl+X, Y, Enter** 

### 2. Edit mysql conf file
```
nano docker-mysql.conf.tpl
-----------
MYSQL_ROOT_PASSWORD=rootpassword <--- edit
MYSQL_USER=samourai <--- edit
MYSQL_PASSWORD=password <--- edit
-----------
```
**Save and exit with Ctrl+X, Y, Enter**

### 3. Edit Node conf 
```
nano docker-node.conf.tpl
-----------
NODE_API_KEY=myApiKey <---edit 
NODE_ADMIN_KEY=myAdminKey <--- edit (IMPORTANT! This is how you access the admin maintenance tool via Tor Broswer)
NODE_JWT_SECRET=myJwtSecret <---edit
NODE_IMPORT_FROM_BITCOIND=active <--- ONLY EDIT to inactive IF you intend on using the OXT rescan feature for old wallet, NOT recommended, FRESH wallet and active setting is recommended
-----------
```
**Save and exit with Ctrl+X, Y, Enter**

## 9. Edit Dockerfiles to work with Raspbian

### 1. Edit Bitcoin Dockerfile (assumes you are still in conf dir) 
```
cd ..
cd bitcoin
nano Dockerfile
----------
## Edit line 9 from: 
    ENV     BITCOIN_URL        https://bitcoincore.org/bin/bitcoin-core-0.18.1/bitcoin-0.18.1-x86_64-linux-gnu.tar.gz
## Edit line 9 to:
    ENV     BITCOIN_URL         https://bitcoincore.org/bin/bitcoin-core-0.18.1/bitcoin-0.18.1-arm-linux-gnueabihf.tar.gz
## Edit line 10 from:
    ENV     BITCOIN_SHA256      600d1db5e751fa85903e935a01a74f5cc57e1e7473c15fd3e17ed21e202cfe5a
## Edit line 10 to: 
    ENV     BITCOIN_SHA256      cc7d483e4b20c5dabd4dcaf304965214cf4934bcc029ca99cbc9af00d3771a1f
----------
```
> For those new to linux you can paste from your clipboard into terminal/command line with Ctrl+Shift+V

**Save and exit with Ctrl+X, Y, Enter**

> Note for future bitcoin upgrades: Here we're basically changing the bitcoin Dockerfile to use the bitcoin image compatible with Raspberry Pi 4 instead of the Desktop compatible version in the default Dockerfile. The above is for Bitcoin v0.18.1

> For future bitcoin upgrades, here's how you can find which filename & hash to put in there:

> For BITCOIN URL go to https://bitcoincore.org/en/download/ , right-click on ARM Linux (the header or 32-bit, NOT 64-bit - Raspbian as of this writing is 32-bit only even if the processor is 64-bit), select "Copy link location" and paste it into the BITCOIN_URL line.

> For BITCOIN_SHA256 on that same page click the "Verify release signatures" link and open the file with a text editor. This link is the same one as in the Dockerfile we're editing, specified in BITCOIN_ASC_URL. You will see the hashes for the sha256 signatures for various platforms. The one we're looking for is "bitcoin-version-arm-linux-gnueabihf.tar.gz". Copy the long string of letters & numbers across it and paste it into the BITCOIN_SHA256 line.

### 2. Edit the MySQL Dockerfile (assumes you are still in bitcoin dir)
```
cd ..
cd mysql
nano Dockerfile
----------
## Edit line 1 from:
    FROM    mysql:5.7.25
## Edit line 1 to:
    FROM    hypriot/rpi-mysql:latest
----------
```
**Save and exit with Ctrl+X, Y, Enter**
```
## Go back to main dojo directory dojo/docker/my-dojo
cd ..
```
## 10. Install Dojo

Now for the moment you've been waiting for... Installing Dojo. Now that all our confs and Dockerfiles are set and ready to go Simply enter the following command
```
sudo ./dojo.sh install
```
The installation takes about 20-30 minutes before the Initial Blockchain Download (IBD) begins.
When the IBD begins you may see _connection refused_ or _connection failed_ many times, this is normal if this happens.

At this point your dojo looks like it's running smoothly - but it's NOT!!!! 

If you go into your maintenance tool (see instructions below), it should look like everything is OK, you can pair your wallet, etc. However, if you look at the API tab, you'll see an error. We need to fix that:

WARNING: You need to do this every time you restart your dojo

Copy and Paste the following commands as is. DO NOT CHANGE ANYTHING.
```
sudo docker exec -it db bash
mysql -h"db" -u"root" -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < /docker-entrypoint-initdb.d/1_db.sql
```

Now when checking API tab you will block headers starting to download.

So NOW we can sit back and relax. This may take 3-5 days depending on your Internet speed.

## Maintenance Tool Access

To get to your Dojo Maintenance Tool, first get your onion address

1. You can either exit the install logs (ctrl+c), or open a new terminal 
```
cd dojo/docker/my-dojo
sudo ./dojo.sh onion
```
Copy the v3 onion address

2. Go to Tor Browser (can be on your main computer or phone)

3. Paste the v3 onion address and add /admin to the end

> For example: blahblahblahblahblahblahblahblah.onion/admin

You will see the QR Pairing code (I recommend waiting for the full install) API tab and PushTX tab
 - The API Tab will let you know where the blockheaders are currently at
 - The PushTx will give you the Blockheight and additional information
 
So you are Downloading your full Bitcoin Node over Tor!

# Hardening your Device

So once you've completed the installation of Dojo before we do anything else, you'll want to lock down your device from potential attackers. We are going to this by installing Fail2Ban and UFW

1. Install Fail2ban

```
sudo apt-get install fail2ban
```

2. UFW (Uncomplicated Firewall)

```
sudo apt-get install ufw
```

Now lets give UFW some rules so we lock it down but we still have access

```
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 192.XXX.X.X/24 to any port 22 comment 'SSH access restricted to local LAN only'
sudo ufw allow from 192.XXX.X.X/24 to any port 8899 comment 'allow whirlpool-gui on local network to access whirlpool-cli'
sudo ufw enable
sudo systemctl enable ufw

## Verify Status

sudo ufw status

To                         Action      From
--                         ------      ----
22                         ALLOW       192.XXX.X.X/24             # SSH access restricted to local LAN only
8899                       ALLOW       192.XXX.X.X/24             # allow whirlpool-gui on local network to access whirlpool-cli
```
> **NOTE: CHANGE 192.XXX.X.X/24 to your IP range. This is generally 192.168.1.0/24 or something similar**

If you are looking to get the most out of your New RONIN DOJO node visit the below sections: 
   - ELECTRS: connect your hardware devices to your own private server powered by your RONIN Dojo
   - WHIRLPOOL: Run your own whirlpool-client-cli so you can keep your mixes going 24/7 
