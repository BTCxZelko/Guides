# Post initial installation
1. Now that we have started up Manjar-Arm, open up terminal and get updates
```
sudo pacman -Syu
```
2. Mount and configure external device
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
3. Download docker-ce
```
sudo pacman -S docker
sudo pacman -S docker-compose
```
4. Configure Docker-data Dir to be on external device
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
sudo systemctl start docker 
```

. Verify python3 is installed and if not install
```
python3 --version
sudo pacman -S python (only if python3 is not installed)
```
. Pull and Configure Dojo repo (1.2 at time of writing)
```
git pull https://github.com/Samourai-Wallet/samourai-dojo.git

