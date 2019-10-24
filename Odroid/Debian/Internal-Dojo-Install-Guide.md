# Introduction
**for ODROID N2**
<sub><sup>by @GuerraMoneta</sup></sub>

This is inspired by what is considered to be the "default dojo deployment". This setup is recommended to Samourai users who feel comfortable with a few command lines. More advanced users may find [this guide](https://github.com/s2l1/Headless-Samourai-Dojo/blob/master/Advanced_Dojo_Setup.md) helpful for things like running external bitcoind. I have tried my best to give as much detail as possible for new users.

# Table of Contents
* [**HARDWARE REQUIREMENTS**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#1-hardware-requirements) 
* [**OPERATING SYSTEM**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#2-operating-system)
* [**BLOCKCHAIN DATA**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#3-blockchain-data)
* [**NETWORK**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#4-network)
* [**SSH SUDO AND ROOT**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#5-ssh-sudo-and-root)
* [**SYSTEM SETUP**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#6-system-setup)
* [**UFW**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#7-ufw)
* [**PIP**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#8-pip)
* [**DOCKER**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#9-docker)
* [**DOJO**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#10-dojo)
* [**SCP**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#11-scp)
* [**FINALIZE DOJO**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#12-finalize-dojo)
* [**PAIRING WALLET WITH DOJO**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#13-pairing-wallet-with-dojo)

```
# My sources:

Dojo Telegram - https://t.me/samourai_dojo
Dojo Docs - https://github.com/Samourai-Wallet/samourai-dojo/blob/master/doc/DOCKER_setup.md#first-time-setup
Advanced Setups - https://github.com/Samourai-Wallet/samourai-dojo/blob/master/doc/DOCKER_advanced_setups.md
Raspibolt - https://stadicus.github.io/RaspiBolt/
Pi 4 Dojo Guide - https://burcak-baskan.gitbook.io/workspace/
```

**NEWBIE TIPS:** Each command has `$` before it, and the outputs of the command are marked `>` to avoid confusion. `#` is symbol fo a comment. Do not enter these as part of a command. If you are not sure about commands, stuck, learning, etc. try visiting the information links and doing the Optional Reading. Look up terms that you do not know. The Dojo Telegram chat is also very active and helpful. I am trying my best to educate anyone new throughout this guide. 

## 1. [HARDWARE REQUIREMENTS]
- `https://forum.odroid.com/viewtopic.php?f=176&t=33781`

You will need an ODROID N2 and I do suggest getting a case for it. I am using this with a 1tb Samsung Portable SSD, USB3.0, hardline ethernet connection, and SD card. You could also use an old 500gb HDD if you have a spare on hand to tinker with.

You will also need a Windows / Linux / Mac with good specs that is on the same network as the ODROID. This setup will take up about as much room as a standard home router/modem and look clean clean once finished.

Add a UPS battery back up later on to be sure your ODROID wont lose power during bad weather etc. 


## 2. [OPERATING SYSTEM]
- `https://forum.odroid.com/viewtopic.php?f=179&t=33865`

By meveric » Tue Feb 19, 2019 8:29 AM: "This is the first version of my Debian Stretch image for the ODROID N2. It is uses the 4.9 LTS Kernel from Hardkernel. It's a headless server image only with user root. It has all my repositories included, which allows for easy installation and updates of packages such as Kernel and Headers and other packages. The image has my usual setup: means on first boot it's resizing the rootfs partition and configures SSH. It will automatically reboot after the initial setup after which this image is ready to use. Kernel and headers are already installed if you need to build your own drivers. A few basic tools such as htop, mc, vim and bash-completion are already installed."
```
DOWNLOAD: https://oph.mdrjr.net/meveric/images/Stretch/Debian-Stretch64-1.0.1-20190519-N2.img.xz 
MD5: https://oph.mdrjr.net/meveric/images/Stretch/Debian-Stretch64-1.0.1-20190519-N2.img.xz.md5
SHA512: https://oph.mdrjr.net/meveric/images/Stretch/Debian-Stretch64-1.0.1-20190519-N2.img.xz.sha512
SIG: https://oph.mdrjr.net/meveric/images/Stretch/Debian-Stretch64-1.0.1-20190519-N2.img.xz.sig

MIRROR: http://fuzon.co.uk/meveric/images/Stretch/Debian-Stretch64-1.0.1-20190519-N2.img.xz
MD5: http://fuzon.co.uk/meveric/images/Stretch/Debian-Stretch64-1.0.1-20190519-N2.img.xz.md5
SHA512: http://fuzon.co.uk/meveric/images/Stretch/Debian-Stretch64-1.0.1-20190519-N2.img.xz.sha512
SIG: http://fuzon.co.uk/meveric/images/Stretch/Debian-Stretch64-1.0.1-20190519-N2.img.xz.sig

PGP PUBLIC KEY: https://oph.mdrjr.net/meveric/meveric.asc
```
Use the md5, sha512, sig, and the PGP public key to check that the Debian `.img.xz` you have downloaded is authentic. Do not trust, verify! If you are not sure on this please look up “md5 to verify software” and “gpg to verify software.” 

Please take some time to learn as this is used to verify things often. Watch the entire playlist below if you are a newbie and working on getting comfortable using the Windows CMD or Linux Terminal.
```
Size compressed: 113MB
Size uncompressed: 897 MB

Default Login: root
Default Password: odroid

Newbie Playlist: 
https://www.youtube.com/watch?v=plUQ3ZRBL54&list=PLmoQ11MXEmajkNPMvmc8OEeZ0zxOKbGRa

Optional Reading: How To gpg - https://www.dewinter.com/gnupg_howto/english/GPGMiniHowto-3.html
Optional Reading: How To md5 - https://www.lifewire.com/validate-md5-checksum-file-4037391 
```
It's ready to be used as a server image. Flash the image on to an SD card and boot up. Give the ODROID some time. As mentioned by meveric above "it will automatically reboot" then it is ready for use.

## 3. [BLOCKCHAIN DATA]

The Bitcoin blockchain records all transactions and basically defines who owns how many bitcoin. This is the most crucial of all information and we should not rely on someone else to provide this data. To set up our Bitcoin Full Node on mainnet, we need to download the whole blockchain (~ 250 GB), verify every Bitcoin transaction that ever occurred, every block ever mined, create an index database for all transactions, so that we can query it later on, calculate all bitcoin address balances (called the UTXO set). Look up "running a bitcoin full node" for additional information.

The ODROID is up to the big task of downloading the blockchain so you may wonder why we are downloading on a faster machine, and copying over the data. The download is not the problem, but to initially process the whole blockchain would take a long time due to its computing power and memory. We need to download and verify the blockchain with Bitcoin Core on your regular computer, and then transfer the data to the ODROID. This needs to be done only once. After that the ODROID can easily keep up with new blocks.

This guide assumes that many will use a Windows machine, but it should also work with most operating systems. I have done my best to provide linux or mac instructions where possible. You need to have about 250+ GB free disk space available, internally or on an external hard disk (but not the SSD reserved for the ODROID). As indexing creates heavy read/write traffic, the faster your hard disk the better. If you are using linux as a main machine I will assume that you are comfortable lookup up how to download Bitcoin Core.

Using SCP, we will copy the blockchain from the Windows computer over the local network later in this guide.

For now download the Bitcoin Core installer from `bitcoincore.org` and store it in the directory you want to use to download the blockchain. To check the authenticity of the program, we will calculate its checksum and compare it with the checksums provided.

In Windows, I’ll preface all commands you need to enter with `$`, so with the command `$ cd bitcoin` just type `cd bitcoin` and hit enter.

Open the Windows command prompt (Start Menu and type cmd directly and hit Enter), navigate to the directory where you downloaded bitcoin setup.exe file. For me, it’s `C:\Users\USERNAME\Desktop` but you can double check in Windows Explorer. Then use certutil calculate the checksum of the already downloaded program.
```
$ cd C:\Users\USERNAME\Desktop
$ mkdir bitcoin_mainnet
$ dir
$ certutil -hashfile bitcoin-0.18.1-win64-setup.exe sha256
>3bac0674c0786689167be2b9f35d2d6e91d5477dee11de753fe3b6e22b93d47c
```
Save and later on check this hash 3bac067... against the file SHA256SUMS.asc once you are on step #9 of this guide to verify that it is authentic.

Open Bitcoin Core and leave it to sync.


## 4. [NETWORK]

The ODROID got a new IP address from your home network. This address can change over time. To make the ODROID reachable from the internet, we assign it a fixed address.

The fixed address is configured in your network router, this can be the cable modem or the Wifi access point. So we first need to access the router. To find out your routers address start the Command Prompt on a computer that is connected to your home network. 
```
#Windows:
#Open Start Menu and type cmd directly and hit Enter
$ ipconfig

#Linux/Mac:
#Open Terminal
$ ifconfig

#look for “Default Gateway” and note the address (eg. “192.168.0.1”)
```
Now open your web browser and access your router by entering the address, like a regular web address. You need to sign in, and now you can look up all network clients in your home network. Your ODROID should be listed here, together with its IP address (eg. “192.168.0.240”).

We now need to set the fixed (static) IP address for the ODROID. Normally, you can find this setting under “DHCP server”. The manual address should be the same as the current address, just change the last part to a lower number (e.g. 192.168.0.240 → 192.168.0.20).

Take note of this new static IP address for your ODROID and apply changes. 

If you have not changed your router's default login password from the default, please do so now. 

Apply and log out of your router. 


## 5. [SSH, SUDO, AND ROOT]

Go ahead and log in or SSH into your ODROID by using Putty on Windows or Terminal on Linux. The machine must be connected to your local network.
```
# Default Login Info:
# Default Username - root
# Default Password - odroid

# Windows: 
# Download - https://www.putty.org/
# Enter the ODROID IP you just took note of, connect, and enter the password.

# In Linux Terminal:
$ ssh root@IP.OF.ODROID.HERE
#Example: root@192.168.0.5
>Enter password:odroid
```
Now you are connected to your ODROID. 

There's constantly new development for this image and ODROIDs in general. The first thing you should do after the image is up and running is to install all updates and sudo.

```
$ apt-get update && apt-get upgrade && apt-get dist-upgrade
$ apt-get install sudo 
```

Now use the terminal to setup sudo permission on a new user and disable the root account. @Nicholas does a great job explaining why you should do this in the following quotation.

"Ultimately the whole point of a permission set is to separate things. Why should Dojo have access to install system drivers? Why should Tor be able to edit Dojo's database? Stuff like that. Ultimately I'd say it's worth it, if not just for good practices. Having a user with an ssh key is good practice, but then requiring their own credentials (sudo -> root) is just another barrier in case a malicious actor gets into your system.

We disable the root account because it is a matter of the principle of least privilege, there's no point running as root when you don't have to. The difference is relatively slim when dealing with a node that only has one purpose and one user. You can argue that if your user is compromised there might be some security, but with an interactive compromised user this is limited. From my understanding (compromised user -> evil maid attack -> root)".

Now let's add the main user, you could think of it as the "admin" user.

Create the new user, set password, and add it to the group "sudo".
``` 
$ adduser XXX
$ adduser XXX sudo
# replace XXX with any username you want
```
Reboot and and log in with the new user "admin".

`$ shutdown -r now`

Now lock the “root” account with the following command.

`$ sudo passwd -l root`

Modify the command to `-u` if you need to unlock the root account.

`$ sudo passwd -u root`

```
Optional Reading: Installing Images - https://www.raspberrypi.org/documentation/installation/installing-images/
Optional Reading: Backup - https://www.raspberrypi.org/magpi/back-up-raspberry-pi/
```


## 6. [SYSTEM SETUP]

First SSH in or log in to your new "admin" account. 

Install fail2ban, git, curl, unzip, and net-tools.

`$ sudo apt-get install fail2ban git curl unzip net-tools`

Now we will format the SSD, erasing all previous data. Make sure your SSD is plugged in. The external SSD is then attached to the file system and can be accessed as a regular folder (this is called mounting). We will use ext4 format, NTFS will not work.
```
# Delete existing flash drive partition:
$ sudo fdisk /dev/sda
# Press 'd'
# Press 'w'
```
```
# Create new primary flash drive partition:
$ sudo fdisk /dev/sda
# Press 'n'
# Press 'p'
# Press '1'
# Press 'enter'
# Press 'enter'
# May ask if you want to remove a signature? type yes
# Press 'w'
```
Take note of the `NAME` for main partition on the external hard disk using the following command.

`$ lsblk -o UUID,NAME,FSTYPE,SIZE,LABEL,MODEL`

Assuming you only have one drive connected, the `NAME` will be `/dev/sda`. Double-check that `/dev/sda` exists, and that its storage capacity is what you expected.

Format the external SSD with Ext4. Use `NAME` from above, example is `/dev/sda1`.

`$ sudo mkfs.ext4 /dev/sda1`

Copy the `UUID` that is provided as a result of this format command to your notepad.

Edit the fstab file using nano, then add the line at the end replacing the `UUID` with your own.
```
$ sudo nano /etc/fstab
# replace `UUID=123456` with the `UUID` that you just took note of
UUID=123456 /mnt/usb ext4 rw,nosuid,dev,noexec,noatime,nodiratime,auto,nouser,async,nofail 0 2
```
Create the directory to add the SSD. Here we will use `/mnt/usb` as the example.

`$ sudo mkdir /mnt/usb`

**NEWBIE TIPS:** `/mnt/usb/` is simply my desired path, and you can choose any path you want for the mounting of your SSD. Any time you see `/mnt/usb/` you should know to change it to your SSD's file path.

Mount all drives and then check the file system. Is `/mnt/usb` listed?
```
$ sudo mount -a
$ df /mnt/usb
> Filesystem     1K-blocks  Used Available Use% Mounted on
> /dev/sda1      479667880 73756 455158568   1% /mnt/hdd
```

Set your timezone.

`$ sudo dpkg-reconfigure tzdata`

Setup tool can be accessed by using the following command.

`$ sudo setup-odroid`

Here you can change hostname, root password, etc. 

Do not move the rootfs to HDD/SSD. I suggest putting OS, Dojo, and any other non-docker software on the SD card. The docker images will be under a subfolder on the external disk.

This tool may ask you to reboot to apply the changes. 

```
# disabling password login and using SSH Key for login is highly recommended!
Optional Reading: Login with SSH Key - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#login-with-ssh-keys
Optional Reading: SSH Key Setup - https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2
```

```
# during setup you can move the swapfile to SSD or disable swap to extend life of your SD card
Optional Reading: Swap File - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#moving-the-swap-file
Optional Reading: Extend Life of SD Card - https://raspberrypi.stackexchange.com/questions/169/how-can-i-extend-the-life-of-my-sd-card
Optional Reading: Mounting External Drive - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#mounting-external-hard-disk 
Optional Reading: Fstab Guide -https://www.howtogeek.com/howto/38125/htg-explains-what-is-the-linux-fstab-and-how-does-it-work/
```


## 7. [UFW]

Enable the Uncomplicated Firewall which controls what traffic is permitted and closes some possible security holes. 

The lines that start with `ufw allow from 192.168.0.0/24...` below assumes that the IP address of your ODROID is something like 192.168.0.???, the ??? being any number from 0 to 255. If your IP address is 12.34.56.78, you must adapt this line to `ufw allow from 12.34.56.0/24...`. 
```
$ apt-get install ufw
$ ufw default deny incoming
$ ufw default allow outgoing
$ ufw allow from 192.168.0.0/24 to any port 22 comment 'SSH access restricted to local LAN only'
$ ufw allow from 192.168.0.0/24 to any port 8899 comment 'allow whirlpool-gui on local network to access whirlpool-cli on Odroid'
$ ufw enable
$ systemctl enable ufw
$ ufw status
```
```
Optional Reading: Connecting to the Network - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#connecting-to-the-network
Optional Reading: Connecting to ODROID - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#connecting-to-the-pi
Optional Reading: Access restricted for local LAN - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#enabling-the-uncomplicated-firewall
Optional Reading: Login with SSH keys - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#login-with-ssh-keys
```

## 8. [PIP] 

Now install the Python Package Installer which we will utilize soon.

First go to the home directory of the root user and then install the necessary dependencies. 

`$ cd ~`

`$ apt-get install python3-dev libffi-dev libssl-dev build-essential`

**NEWBIE TIPS:** Useful libs to have in the system. Also python2 is end of life so we are using python3.

`Optional Reading: Installing PIP - https://pip.pypa.io/en/stable/installing/`

To install pip, securely download get-pip.py. “Secure” in this context means using a modern browser or a tool like curl that verifies SSL certificates when downloading from https URLs.

`$ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py`

Then run the following.

`$ python3 get-pip.py`

In the future, when you need to update software with PIP you will use a command similar to the following. 

`pip install SoftwareName --upgrade`


## 9. [DOCKER]

Now install docker using this method the convenience script. This script is meant for quick and easy install. 

`$ curl -fsSL https://get.docker.com -o get-docker.sh` 

`$ sh get-docker.sh`

**NEWBIE TIPS:** Make sure to verify the contents of the script you downloaded matches the contents of `install.sh` located at https://github.com/docker/docker-install before executing. Take this and all security measures seriously by doing some research when necessary.
```
# git commit from https://github.com/docker/docker-install
SCRIPT_COMMIT_SHA="6bf300318ebaab958c4adc341a8c7bb9f3a54a1a"
```
Now we will use pip to install docker-compose, I have noticed that apt-get can install an old version. Better to use the docker-compose install instructions which you can look at in Optional Reading. I will walk you through the pip install approach, though there are a few ways to install the latest version.
```                         
$ python3 -m pip install --upgrade docker-compose
# Let the install finish
# --upgrade part is only useful if you already have it, which some people may.
```
```
Optional Reading - Install docker-compose - https://docs.docker.com/compose/install/
Optional Reading - Install docker-compose using pip - https://docs.docker.com/compose/install/#install-using-pip
```
Now check your docker version. An outdated version can cause problems. 

`$ docker -v`

Take a look at what PIP has installed on your system.

`$ python3 -m pip list`

Now to configure docker to use the external SSD. Create a new file in text editor. 

`$ nano /etc/docker/daemon.json`

Add the following 3 lines.
```
{
                  "data-root": "/mnt/usb/docker"
} 
```
Save and exit Nano text editor.

Restart docker to accept changes.

`$ systemctl daemon-reload`

`$ systemctl start docker`

Check that docker is using the SSD.
```
$ docker info | grep "Docker Root Dir:" 
> "data-root": "/mnt/usb/docker/"
```
Try rebooting if you do not see your external SSD listed.

`$ shutdown -r now`

## 10. [DOJO] 

Please verify bitcoind is not running. Will output an error if it is not running.

`$ bitcoin-cli stop`

Download and unzip latest Dojo release.
```
$ cd ~
$ curl -fsSL https://github.com/Samourai-Wallet/samourai-dojo/archive/master.zip -o master.zip
$ unzip master.zip
```
Create a directory for Dojo. We will name it `dojo_dir` for this guide.

`$ mkdir dojo_dir`

Copy samourai-dojo-master directory contents to `dojo_dir` directory. 

`$ cp -rv samourai-dojo-master/* dojo_dir/`

Now remove all the old downloads that you used earlier in the guide.
```
$ rm -rvf samourai-dojo-master/ master.zip SHA256SUMS.asc laanwj-releases.asc get-pip.py get-docker.sh
```
Open bitcoin docker file in text editor. We are going to use the `aarch64-linux-gnu.tar.gz` source. Updates will happen so keep an eye out for new versions and update accordingly.

`$ nano ~/dojo_dir/docker/my-dojo/bitcoin/Dockerfile`
```
         #Change line #9 to: 
            ENV     BITCOIN_URL        https://bitcoincore.org/bin/bitcoin-core-0.18.1/bitcoin-0.18.1-aarch64-linux-gnu.tar.gz

         #Change line #10 to:
            ENV     BITCOIN_SHA256     88f343af72803b851c7da13874cc5525026b0b55e63e1b5e1298390c4688adc6
```
Edit mysql Dockerfile to use a compatible database.

`$ nano ~/dojo_dir/docker/my-dojo/mysql/Dockerfile`
```
         #Change line #1 to:
            FROM    mariadb:latest
```
Now configure your Dojo installation by editing all 3 `.conf.tpl` files. For each line i.e "USER, PASSWORD, KEY, SECRET" type in anything you prefer. Make it secure like any other password.

`$ cd ~/dojo_dir/docker/my-dojo/conf`

`$ nano docker-bitcoind.conf.tpl`
```
# Using nano edit docker-bitcoind.conf.tpl and provide a new value for the following parameters:
BITCOIND_RPC_USER = login protecting the access to the RPC API of your full node
BITCOIND_RPC_PASSWORD = password protecting the access to the RPC API of your full node
```
`$ nano docker-mysql.conf.tpl`
```
# Using nano edit docker-mysql.conf.tpl and provide a new value for the following parameters:
MYSQL_ROOT_PASSWORD = password protecting the root account of MySQL
MYSQL_USER = login of the account used to access the database of your Dojo
MYSQL_PASSWORD = password of the account used to access the database of your Dojo
```
Using the terminal go to the `my-dojo/` directory.

`$ cd ~/dojo_dir/docker/my-dojo`

This directory contains a script named `dojo.sh` which will be your entrypoint for all operations related to the management of your Dojo.

Docker and Docker Compose are going to build the images and containers of your Dojo. This operation will take a few minutes (download and setup of all required software components). After completion, your Dojo will be launched and will be ready for connection to your "external" bitcoin full node on your ODROID. 
```
$ cd ~/dojo_dir/docker/my-dojo
$ ./dojo.sh install
```

When the install finished it will start showing logs. You can watch them for a little while if you'd like and then use `Ctrl + C` to exit. Dojo could take a few days to sync from this point, so we will go ahead and shut it down, and prepare to copy the blockchain data from your other computer.

`$ ./dojo.sh stop`

## 11. [SCP]

Right at the beginning we started downloading the Bitcoin mainnet blockchain on your other computer. Check the verification progress directly in Bitcoin Core on this computer. To proceed, it should be fully synced (see status bar).

As soon as the verification is finished, shut down Bitcoin Core on Windows. We will now copy the data from your fully synced bitcoin node to the ODROID. This takes about 6 hours. Copy over the data from your fully synced node to `/mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/`. 

We are using “Secure Copy” (SCP), so download and install WinSCP, a free open-source program. Linux instructions are below.

With WinSCP, you can now connect to your ODROID by using its IP address.

Accept the server certificate and navigate to the `Local` and `Remote` bitcoin directories.
```
Local: C:\bitcoin\bitcoin_mainnet\
Remote: /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/
```
You can now copy the two subdirectories (folders) named `blocks` and `chainstate` from `Local` to `Remote`. This will take about 6 hours. The transfer must not be interupted. Make sure your computer does not go to sleep. Once the data transfer is finished you can close WinSCP or whatever transfer method you used an start dojo.

Now Set ownership of `/mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/` and everything under it to `user 1105` and `group 1108`. 
```
# be sure to copy this entire command including the * at the end
$ chown -R 1105:1108 /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/*
```
 
For linux it would look something like the following.

Go to `.bitcoin` directory on your linux machine, usually `/home/user/.bitcoin`.

`$ cd  /home/user/.bitcoin`

Copy the bitcoin data from this Linux machine to your ODROID. Here we are using `root@192.168.0.35` as and example. You need to put your ODROID local (internal) IP address here.

`$ scp -r blocks/ root@192.168.0.35:~/.bitcoin/blocks`

`$ scp -r chainstate/ root@192.168.0.35:~/.bitcoin/chainstate`

```
Optional Reading: SCP on Linux - https://www.computerhope.com/unix/scp.htm
Optional Reading: WinSCP Windows - https://winscp.net/eng/docs/start
```

## 12. [FINALIZE DOJO]

Now that all the blockchain data has been copied over let's start dojo, check on some things, and get familiar with commands.

`$ docker start`

Check that all containers are up. Begin to troubleshoot now if all containers do not show as up.

`$ docker ps`

You can bring up the logs for all containers at any time by using this command.

`$ ./dojo.sh logs`

Monitor the progress made for the initialization of the database with this command. It is scanning your external bitcoind node. This will take about an hour to complete.

`$ ./dojo.sh logs tracker`

Check that bitcoind is running properly. Among other infos the “verificationprogress” is shown. Once this value reaches almost 1 (0.999…), the blockchain is up-to-date and fully validated. Since `txindex=1` was specified in the `bitcoin.conf` file it will take an hour or more for bitcoin to build the transaction index.

Once you are sync'd up continue to step 11. 

`$ ./dojo.sh logs bitcoind`

Did Tor bootstrap 100%?

` $ ./dojo.sh logs tor`

When the syncing of the database has completed retrieve the Tor onion addresses (v2 and v3) of the API of your Dojo.

`$ ./dojo.sh onion`

A maintenance tool is accessible through your Tor browser at this onion address you have just obtained. Other than maintenance, this tool is what you will use to pair a Samourai Wallet on mobile to your Dojo on ODROID. The tool requires that you allow javascript for the site.

A few lines ago you edited `docker-node.conf.tpl` entered a value for `NODE_ADMIN_KEY`. Go to the v3_address.onion (maintenance tool) and log in using the `NODE_ADMIN_KEY` value. Click the pairing tab and you will see a QR code for pairing. We will utilize in the next step where you will pair your Samourai Wallet with your Dojo.

If everything is running smoothly, this is the perfect time to familiarize yourself with Bitcoin Core, try some bitcoin-cli commands, and do some reading or videos until the blockchain is up-to-date. A great point to start is the book Mastering Bitcoin by Andreas Antonopoulos which is open source. Now is also a great time to backup your system. 

You can go ahead and close Bitcoin Core on your other machine and delete later on when you have a stable system with proper backups.

Take some time to get familiar with Dojo commands and docs below as well.

```
# dojo command help
./dojo.sh command [module] [options]

Available commands:

  help                          Display the help message.

  bitcoin-cli                   Launch a bitcoin-cli console for interacting with bitcoind RPC API.

  clean                         Free disk space by deleting docker dangling images and images of previous versions.

  install                       Install your Dojo.

  logs [module] [options]       Display the logs of your Dojo. Use CTRL+C to stop the logs.

                                Available modules:
                                  dojo.sh logs                : display the logs of all containers
                                  dojo.sh logs bitcoind       : display the logs of bitcoind
                                  dojo.sh logs db             : display the logs of the MySQL database
                                  dojo.sh logs tor            : display the logs of tor
                                  dojo.sh logs api            : display the logs of the REST API (nodejs)
                                  dojo.sh logs tracker        : display the logs of the Tracker (nodejs)
                                  dojo.sh logs pushtx         : display the logs of the pushTx API (nodejs)
                                  dojo.sh logs pushtx-orchest : display the logs of the Orchestrator (nodejs)

                                Available options (for api, tracker, pushtx and pushtx-orchest modules):
                                  -d [VALUE]                  : select the type of log to be displayed.
                                                                VALUE can be output (default) or error.
                                  -n [VALUE]                  : display the last VALUE lines

  onion                         Display the Tor onion address allowing your wallet to access your Dojo.

  restart                       Restart your Dojo.

  start                         Start your Dojo.

  stop                          Stop your Dojo.

  uninstall                     Delete your Dojo. Be careful! This command will also remove all data.

  upgrade                       Upgrade your Dojo.

  version                       Display the version of dojo.
```
```
Dojo Docs - https://github.com/Samourai-Wallet/samourai-dojo/blob/master/doc/DOCKER_setup.md#first-time-setup
```


## 13. [PAIRING WALLET WITH DOJO]

Install Samourai Wallet on your mobile device. Enable Tor when you open the app but do not start a new wallet. Tap the 3 dots in the top right corner and choose to pair with a new Dojo. Now scan your pairing QR code.

Use api logs to watch pairing, it can take a couple minutes to pair.

`$ ./dojo.sh logs api`

Please keep in mind that any time Dojo is started it must be started **BEFORE** bitcoind. 

Make sure you have a back up of your system. I will also suggest at this point that you harden your system further using the SSH Keys to login and disabling the password.

Congratulations! Your mobile Samourai Wallet is now paired to Dojo. If you have not already, I recommend locking down SSH by requiring a key to log in to your dojo, see below.
```
Donations:
SegWit native address (Bech32) bc1q5s6jhl0uz9lsj3vgclvftqqap9p60ztpurpax7
Segwit compatible address (P2SH) 3LdWJ2op2Ba51BndUkUuX7qxoecXaK5FWk
```
