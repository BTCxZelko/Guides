# Post initial OS installation
## 1. Now that we have started up Manjar-Arm, open up terminal and get updates
```
sudo pacman -Syu
```
## 2. Mount and configure external device
Attach your external storage through one of the USB 3.0 ports. This will attach your storage to the default /media/yourusername/yourexternalstorage location. It's better to make a seperate attachment point for it and make sure your Pi 4 attaches the external disk to the same location every time you reboot.

If you have bought a ready external drive, there's a very good chance that it's formatted to NTFS - that will not work for us. Let's check:
```
sudo lsblk -f
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

Press the following keys at each prompt to wipe the disk clean and create a fresh partition:
d, n, p, 1, Enter, Enter, Y, w  #The Yes/No prompt will be shown if you are working on an NTFS disk

sudo mkfs.ext4 /dev/sda1      #This will format your disk to "ext4" filesystem
```
Now we need to make it so that we tell the system to mount it to the same location at every boot, automatically. We'll do this by editing the /etc/fstab file and remounting everything.
```
sudo blkid
```
In the device list that appears find your external disk (probably /dev/sda1) and note down or copy the UUID of it (something like "8d008fde-f12a-47f7-8519-197ea707d3d4"). 

Next, create a directory to mount the disk to and edit /etc/fstab file:
```
sudo mkdir /mnt/usb
sudo nano /etc/fstab
```
Add the following line at the end:
```
UUID=That_UUID_You_Just_Copied  /mnt/usb  ext4  defaults   0   0
```
**Save and exit with Ctrl+X, Y, Enter**

Then mount everything specified in fstab with:
```
sudo mount -a
```
## 3. Install Docker
```
sudo pacman -S docker
sudo pacman -S docker-compose
```
## 4. Configure Docker-data Dir to be on external device
First create the docker directory where we will store all docker data
```
sudo mkdir /mnt/usb/docker
```
Create a new file "/etc/docker/daemon.json". 
```
sudo nano /etc/docker/daemon.json
```
Add the following lines:
```
{ 
                  "data-root": "/mnt/usb/docker" 
} 
```
**Save and exit with Ctrl+X, Y, Enter**

Restart Docker to save changes
```
sudo systemctl daemon-reload 
sudo systemctl stop docker
sudo systemctl start docker
```
Verify that the Docker Data Directory is using External Disk
```
sudo docker info | grep "Docker Root Dir:"
```
Should see the following:
```
WARNING: No swap limit support
WARNING: No cpu cfs quota support
WARNING: No cpu cfs period support
 Docker Root Dir: /mnt/usb/docker
 ```

## 5. Verify python3 is installed and if not install
```
python3 --version
sudo pacman -S python (only if python3 is not installed)
```
## 6. Pull and Configure Dojo repo (v1.2 at time of writing)
```
mkdir temp_dojo
mkdir dojo
cd temp_dojo
git clone https://github.com/Samourai-Wallet/samourai-dojo.git
cd
mv samourai-dojo/* dojo/
```
# Now all your Dojo documents are all in your permenant Dojo Directory. Let's go in an modify the confs for Manjaro-ARM

1. First bitcoid conf file
```
cd dojo/docker/my-dojo/conf
nano docker-bitcoind.conf.tpl
-----------
BITCOIND_RPC_USER=dojorpc  <-- edit
BITCOIND_RPC_PASSWORD=dojorpcpassword  <-- edit (alphanumerical, NO SYMBOLS)
-----------
```
**Save and exit with Ctrl+X, Y, Enter** 

2. Edit mysql conf file
```
nano docker-mysql.conf.tpl
-----------
MYSQL_ROOT_PASSWORD=rootpassword <--- edit
MYSQL_USER=samourai <--- edit
MYSQL_PASSWORD=password <--- edit
-----------
```
**Save and exit with Ctrl+X, Y, Enter**

3. Edit Node conf 
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

## 7. Edit Dockerfiles to work with Manjaro-ARM
1. Edit Bitcoin Dockerfile (assumes you are still in conf dir) 
```
cd ..
cd bitcoin
nano Dockerfile
----------
##Edit line 9 from 
    ENV     BITCOIN_URL        https://bitcoincore.org/bin/bitcoin-core-0.18.1/bitcoin-0.18.1-x86_64-linux-gnu.tar.gz
##Edit line 9 to:
    ENV     BITCOIN_URL         https://bitcoincore.org/bin/bitcoin-core-0.18.1/bitcoin-0.18.1-aarch64-linux-gnu.tar.gz
##Edit line 10 from:
    ENV     BITCOIN_SHA256      600d1db5e751fa85903e935a01a74f5cc57e1e7473c15fd3e17ed21e202cfe5a
##Edit line 10 to: 
    ENV     BITCOIN_SHA256      88f343af72803b851c7da13874cc5525026b0b55e63e1b5e1298390c4688adc6
----------
```
**_For those new to linux you can paste from your clipboard into terminal/command line with Ctrl+Shift+V_**

**Save and exit with Ctrl+X, Y, Enter**

2. Edit the MySQL Dockerfile (assumes you are still in bitcoin dir)
```
cd ..
cd mysql
nano Dockerfile
----------
##Edit line 1 from:
    FROM    mysql:5.7.25
##Edit line 1 to:
    FROM    mariadb:latest
----------
```
**Save and exit with Ctrl+X, Y, Enter**
```
##Go back to main dojo directory dojo/docker/my-dojo
cd ..
```
## 8. Install Dojo

Now for the moment you've been waiting for... Installing Dojo. Now that all our confs and Dockerfiles are set and ready to go Simply enter the following command
```
sudo ./dojo.sh install
```
The installation takes about 20-30 minutes before the Initial Blockchain Download (IBD) begins.
When the IBD begins you may see _connection refused_ or _connection failed_ many times, this is normal if this happens.

So now sit back and relax. This may take 3-5 days depending on your Internet speed.

## OPTIONAL but Recommended, Maintenance Tool usage

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
