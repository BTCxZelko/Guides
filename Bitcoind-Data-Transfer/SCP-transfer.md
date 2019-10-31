# Transferring the Initial Blockdownload 

So if you have an a Computer that has better than RPi4/Odroid N2 (most computers are) and want to download the Initial Block Download (IBD) and then transfer to your new device, then read below.

> **NOTE: The advantage to Downloading your IBD via Dojo is the privacy factor of running through Tor, your ISP has no idea you are downloading the Bitcoin Blockchain. Downside: Takes about 3-5 days for a full sync as of Oct 6, 2019.** 

## After syncing the blockchain on your main computer.

### 1. Install Dojo as per the guide of your choice.

### 2. Stop Dojo after you see the blockchain begin to sync.

```
cd /home/USERNAME/dojo/docker/my-dojo # Change USERNAME to your username
sudo ./dojo.sh stop
```

### 3. Stop Bitcoin-Coin on main computer

### 4. Once completed stopped head to docker volumes

```
cd /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/
## If you cannot gain access to this folder, you may need to log into root temporarily with: 
sudo su
```

> If you needed to utilize root access during this step you will need to during any other steps moving forward if you receive permission denied when accessing a directory. 

> **NOTE: If you are using root access temporarily, always log back to user immediately after to decrease security threats**

```
sudo rm -r blocks chainstate
# If using root access, log back into original user
su USER 
# Change USER to your username
```

### 5. Transfer Bitcoin-Core blocks and chainstate to your Dojo 

From your main computer in the Bitcoin data directory
Default location for linux is: ~/.bitcoin/
For other Operating Systems click [here](https://en.bitcoinwiki.org/wiki/Data_directory) to verify location.

```
sudo scp -r blocks chainstate **USERNAME**@192.168.X.XX:/mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/ 
```

> **Note replace USERNAME with the username of your Dojo device**

> **Also replace 192.168.X.XX with your IP on your Dojo device (you can use "ifconfig" on Raspbian or "ip a" on Manjaro and look for eth0 for ethernet connection or wlan0 for wifi**

*This may take several hours to transfer all data*

### 6. Once this is complete, remove any LOCK file, and edit permissions for Dojo

```
cd /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/blocks
sudo rm -r LOCK
cd ..
cd /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/chainstate
sudo rm -r LOCK
cd ..
sudo chown -R 1105:1108 /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/*
# Verify permissions are correct
ls -lsa /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/*
# should show similar to the following:
   4 drwxr-xr-x 5 1105 1108    4096 Oct 16 14:27 .
   4 drwxr-xr-x 3 root root    4096 Oct 13 09:59 ..
   4 -rw------- 1 1105 1108      37 Oct 13 10:13 banlist.dat
   4 -rw------- 1 1105 1108       3 Oct 16 04:41 bitcoind.pid
 124 drwx------ 3 1105 1108  122880 Oct 15 19:39 blocks
  72 drwx------ 2 1105 1108   69632 Oct 16 10:01 chainstate
 828 -rw------- 1 1105 1108  839728 Oct 16 14:21 debug.log
 244 -rw------- 1 1105 1108  247985 Oct 15 04:24 fee_estimates.dat
   4 drwx------ 3 1105 1108    4096 Oct  5 08:34 indexes
   0 -rw------- 1 1105 1108       0 Oct 13 10:13 .lock
   4 -rw------- 1 1105 1108      17 Oct 13 10:23 mempool.dat
3416 -rw------- 1 1105 1108 3493924 Oct 16 14:27 peers.dat
```
If all of that looks correct inregards to 1105 1108, then move to Step 7.
 
### 7. Start Dojo

```
cd /home/USERNAME/dojo/docker/my-dojo # Change USERNAME to your username
sudo ./dojo.sh start
```

Verify logs
```
sudo ./dojo.sh logs bitcoind
```

You will have to wait for the Logs Tracker to index all blockheaders. You can track this with the following:
```
sudo ./dojo.sh logs tracker
```
This may take some time as well, usually about 1-3 hours


### You've now sync'd your Dojo Full Node with the Bitcoin Network!
