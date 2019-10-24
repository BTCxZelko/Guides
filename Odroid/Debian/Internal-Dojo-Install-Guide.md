# Introduction
**for ODROID N2**
<sub><sup>by @GuerraMoneta</sup></sub>

This guide will be installing Dojo with all settings left at their defaults. I recommend this guide to Samourai users who feel comfortable with a few command lines. I have tried to give as much detail as possible for newer users. More advanced users may find [this guide](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/External-Bitcoind-Install-Guide.md) helpful for things like running bitcoind outside of docker. 

Don't want to go through this guide? Already familiar or just looking to get deployed ASAP? Check out this [Convenience Script](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Convenience-Scripts/Internal-Dojo-Install-Script.sh). It should have Dojo up and bitcoind syncing within in ~30 minutes.

# Table of Contents
* [**1. HARDWARE REQUIREMENTS**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#1-hardware-requirements)
* [**2. OPERATING SYSTEM**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#2-operating-system)
* [**3. BLOCKCHAIN DATA**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#3-blockchain-data)
* [**4. NETWORK**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#4-network)
* [**5. SSH SUDO AND ROOT**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#5-ssh-sudo-and-root)
* [**6. SYSTEM SETUP**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#6-system-setup)
* [**7. UFW**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#7-ufw)
* [**8. PIP**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#8-pip)
* [**9. DOCKER**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#9-docker)
* [**10. DOJO**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#10-dojo)
* [**11. SCP**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#11-scp)
* [**12. FINALIZE DOJO**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#12-finalize-dojo)
* [**13. PAIRING WALLET WITH DOJO**](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#13-pairing-wallet-with-dojo)

```
# My sources:

Dojo Telegram - https://t.me/samourai_dojo
Dojo Docs - https://github.com/Samourai-Wallet/samourai-dojo/blob/master/doc/DOCKER_setup.md#first-time-setup
Advanced Setups - https://github.com/Samourai-Wallet/samourai-dojo/blob/master/doc/DOCKER_advanced_setups.md
```

**NEWBIE TIPS:** Each command has `$` before it, and the outputs of the command are marked `>` to avoid confusion. `#` is symbol fo a comment. Do not enter these as part of a command. If you are not sure about commands, stuck, learning, etc. try visiting the information links and doing the Optional Reading. Look up terms that you do not know. The Dojo Telegram chat is also very active and helpful.

## 1. [HARDWARE REQUIREMENTS]

* [ODROID N2 4gb](https://forum.odroid.com/viewtopic.php?f=176&t=33781)
* [Samsung T5](https://www.amazon.com/Samsung-T5-Portable-SSD-MU-PA1T0B/dp/B073H552FJ/ref=sr_1_1?fst=as%3Aoff&qid=1571081118&refinements=p_n_feature_three_browse-bin%3A6797521011&rnid=6797515011&s=pc&sr=1-1) or [Seagate Fast SSD](https://www.amazon.com/Seagate-External-Reversible-Type-C-STCM1000400/dp/B07DX7D744)
* [Samsung EVO+ 64GB](https://www.amazon.com/Samsung-MicroSDXC-Memory-Adapter-MB-MC64GA/dp/B06XFWPXYD/ref=sr_1_4?keywords=EVO%2B+SD+card&qid=1571081610&s=electronics&sr=1-4)

I suggest adding a UPS battery back up later on to be sure your ODROID wont lose power during bad weather etc.

More info on Hardware can be found [here](https://github.com/BTCxZelko/Ronin-Dojo#recommended-hardware).

## 2. [OPERATING SYSTEM]

* [Debian Stretch](https://forum.odroid.com/viewtopic.php?f=179&t=33865)

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

Please take some time to learn as this is used to verify things often. Watch the playlist below if you are a newbie and working on getting comfortable using the Windows CMD or Linux Terminal.
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
Flash the image on to an SD card and boot up. Give the ODROID some time. As meveric says [here](https://forum.odroid.com/viewtopic.php?f=179&t=33865) "it will automatically reboot after the initial setup after which this image is ready to use."

## 3. [BLOCKCHAIN DATA]

If you don't have problem with waiting for the Odroid to sync the bitcoin blockchain, skip this section, and go to part [4](https://github.com/s2l1/Headless-Samourai-Dojo/blob/master/Default_Dojo_Setup.md#4-network).

Syncing the data for bitcoind can take a few days, or you can copy over the data in about ~6 hours. See details in this [explainer](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Explainers/Blockchain-Data.md). 

If you wish to copy the Blockchain data over you will need a Windows, Linux, or Mac machine with decent specs. It must be connected to the same network as the ODROID. Go ahead and download bitcoin core, get the sync process started, and continue with part 4.

## 4. [NETWORK]

Log in to your router and set a static IP address for your ODROID. Take a look at this [explainer](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Explainers/Network.md) if you need help.

## 5. [SSH, SUDO, AND ROOT]

Go ahead and login with a USB Keyboard, or SSH into your ODROID by using Putty on Windows or Terminal on Mac/Linux. SSH is encouraged as it is very helpful. Now is also a great time to update your system, install sudo, add a new user with sudo privelege, and lock the root account.

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

```
$ apt-get update && apt-get upgrade && apt-get dist-upgrade
$ apt-get install sudo 
```
Now use the terminal to setup sudo permission on a new user and disable the root account. @Nicholas does a great job [explaining](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Explainers/SSH-Sudo-Root.md) why you should do this.

Now let's add the main user, you could think of it as the "admin" user, and add it to the sudo group.

``` 
$ adduser XXX
$ adduser XXX sudo
# replace XXX with any username you want
```
Reboot and SSH or login again. This time with new user "XXX" instead of "root".
```
$ shutdown -r now
$ ssh XXX@IP.OF.ODROID.HERE
# example admin@192.168.4.20
```
Now lock the “root” account with the following command.

`$ sudo passwd -l root`

Modify the command to `-u` if you ever need to unlock the root account.

`$ sudo passwd -u root`

```
Optional Reading: Installing Images - https://www.raspberrypi.org/documentation/installation/installing-images/
Optional Reading: Backup - https://www.raspberrypi.org/magpi/back-up-raspberry-pi/
```


## 6. [SYSTEM SETUP]

Install fail2ban, git, curl, unzip, net-tools, python3, some useful libs, and dependencies. We are using python3 as python2 is now end of life.

`$ sudo apt-get install fail2ban git curl unzip net-tools python3-dev libffi-dev libssl-dev build-essential`

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
Assuming you only have one drive connected, the `NAME` will be `/dev/sda`. Double-check that `/dev/sda` exists, and that its storage capacity is what you expected.

`$ lsblk -o NAME,FSTYPE,SIZE,LABEL,MODEL`

Format the external SSD with Ext4. Use the `NAME` from the command you just ran, example is `/dev/sda1`.

`$ sudo mkfs.ext4 /dev/sda1`

Copy the `UUID` that is provided as a result of this format.

`$ lsblk -o UUID,NAME,FSTYPE,SIZE,LABEL,MODEL`

Edit the fstab file using nano, add the line at the end, replace the `UUID=123456` with your own.
```
$ sudo nano /etc/fstab
# replace `UUID=123456` with the `UUID` that you just took note of
UUID=123456 /mnt/usb ext4 rw,nosuid,dev,noexec,noatime,nodiratime,auto,nouser,async,nofail 0 2
```
Create the directory to add the SSD. Here we will use `/mnt/usb` as the example.

`$ sudo mkdir /mnt/usb`

**NEWBIE TIPS:** `/mnt/usb/` is simply a desired path, and you can choose any path you want for the mounting of your SSD. If you chose a different path, then any time you see `/mnt/usb/`, you should know to change it to your SSD's file path.

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
Optional Reading: SSH Key Info - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#login-with-ssh-keys
Optional Reading: SSH Key Info - https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2
```

```
# during setup you can move the swapfile to SSD or disable swap if you wish
Optional Reading: Swap File - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#moving-the-swap-file
Optional Reading: Extend Life of SD Card - https://raspberrypi.stackexchange.com/questions/169/how-can-i-extend-the-life-of-my-sd-card
Optional Reading: Mounting External Drive - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#mounting-external-hard-disk 
Optional Reading: Fstab Guide -https://www.howtogeek.com/howto/38125/htg-explains-what-is-the-linux-fstab-and-how-does-it-work/
```


## 7. [UFW]

Enable the Uncomplicated Firewall, which controls what traffic is permitted, and closes some possible security holes. 

The lines that start with `ufw allow from 192.168.0.0/24...` below assume that the IP address of your ODROID is something like 192.168.0.???, the ??? being any number from 0 to 255. If your IP address is 12.34.56.78, you must adapt this line to `ufw allow from 12.34.56.0/24...`. 
```
$ sudo su -
$ apt-get install ufw
$ ufw default deny incoming
$ ufw default allow outgoing
$ ufw allow from 192.168.0.0/24 to any port 22 comment 'SSH access restricted to local LAN only'
$ ufw allow from 192.168.0.0/24 to any port 8899 comment 'allow whirlpool-gui on local network to access whirlpool-cli on Odroid'
$ ufw enable
$ systemctl enable ufw
$ ufw status
$ exit
```
```
Optional Reading: Connecting to the Network - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#connecting-to-the-network
Optional Reading: Connecting to ODROID - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#connecting-to-the-pi
Optional Reading: Access restricted for local LAN - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#enabling-the-uncomplicated-firewall
Optional Reading: Login with SSH keys - https://stadicus.github.io/RaspiBolt/raspibolt_20_pi.html#login-with-ssh-keys
```


## 8. [PIP] 

Now we will install the Python Package Installer, which we will utilize soon.

To install pip, securely download get-pip.py. “Secure” in this context means using a modern browser or a tool like curl that verifies SSL certificates when downloading from https URLs.

`$ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py`

Then run the following.

`$ sudo python3 get-pip.py`

In the future, when you need to update software with PIP, you will use a command similar to the following. 

`$ sudo pip install SoftwareNameHere --upgrade`

`Optional Reading: Installing PIP - https://pip.pypa.io/en/stable/installing/`


## 9. [DOCKER]

Now install docker using the get-docker convenience script. This script is meant for quick and easy install.

First download the script using curl.

`$ curl -fsSL https://get.docker.com -o get-docker.sh`

**NEWBIE TIPS:** Make sure to verify the contents of this or any script you download! At least check that it matches the contents of `install.sh` located at the [docker github](https://github.com/docker/docker-install). Take this and all security measures seriously by doing some research when necessary.

Then run it.

`$ sudo sh get-docker.sh`
```
# when you run get-docker.sh, the latest git commit from https://github.com/docker/docker-install will show
# use this to help verify, example, https://github.com/docker/docker-install/commit/f45d7c11389849ff46a6b4d94e0dd1ffebca32c1
> SCRIPT_COMMIT_SHA="f45d7c11389849ff46a6b4d94e0dd1ffebca32c1"
```

Now check your docker version. An outdated version can cause problems. 

`$ docker -v`

Now we will use PIP to install docker-compose. I have noticed that apt-get can install an old version. Better to use the docker-compose install instructions which you can look at in Optional Reading. I will walk you through the PIP install approach, though there are a few ways to install the latest version.
```                         
$ sudo python3 -m pip install --upgrade docker-compose
# Let the install finish
# --upgrade part is only useful if you already have it, which some people may.
```

Take a look at what PIP has installed on your system.

`$ python3 -m pip list`

Now configure docker to use the external SSD. Create a new file in text editor. 

`$ sudo nano /etc/docker/daemon.json`

Add the following 3 lines.
```
{
                  "data-root": "/mnt/usb/docker"
}
```
Save and exit the text editor.

Restart docker to accept changes.

`$ sudo systemctl daemon-reload`

`$ sudo systemctl stop docker`

`$ sudo systemctl start docker`

Use this command to check that docker is using the SSD.
```
$ sudo docker info | grep "Docker Root Dir:" 
> "data-root": "/mnt/usb/docker/"
```

```
Optional Reading - Install docker-compose - https://docs.docker.com/compose/install/
Optional Reading - Install docker-compose using pip - https://docs.docker.com/compose/install/#install-using-pip
```


## 10. [DOJO]

Download and unzip latest Dojo release.
```
$ curl -fsSL https://github.com/Samourai-Wallet/samourai-dojo/archive/master.zip -o master.zip
$ unzip master.zip
```
Create a directory for Dojo. We will name it `dojo_dir` for this guide.

`$ mkdir dojo_dir`

Copy samourai-dojo-master directory contents to `dojo_dir` directory. 

`$ cp -rv samourai-dojo-master/* dojo_dir/`

Now remove all the old downloads that you used earlier in the guide.
```
$ rm -rvf samourai-dojo-master/ master.zip get-pip.py get-docker.sh
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
`$ nano docker-node.conf.tpl`
```
# Using nano edit docker-node.conf.tpl and provide a new value for the following parameters:
NODE_API_KEY = API key which will be required from your Samourai Wallet / Sentinel for its interactions with the API of your Dojo
NODE_ADMIN_KEY = API key which will be required from the maintenance tool for accessing a set of advanced features provided by the API of your Dojo
NODE_JWT_SECRET = secret used by your Dojo for the initialization of a cryptographic key signing Json Web Tokens. These parameters will protect the access to your Dojo. Be sure to provide alphanumeric values with enough entropy
```

Using the terminal, go to the back to the `my-dojo/` directory.

`$ cd ..`

The directory `~/dojo_dir/docker/my-dojo` contains a script named `dojo.sh` which will be your entrypoint for all operations related to the management of your Dojo.

Now it is time to begin the Dojo install. Docker and Docker Compose are going to build the images and containers of your Dojo. This operation will take a few minutes to download and setup of all required software components.
```
$ sudo ./dojo.sh install
```

When the install finishes it will start showing logs. Go ahead and pat yourself on the back, your Dojo is set up!

Watch the logs for some time then use `Ctrl + C` to exit. If you do not wish to do step [11](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#11-scp), which copies the blockchain data over from a faster machine, skip ahead to the to part [12](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#12-finalize-dojo).

Dojo could take a few days to sync from this point, so shut it down now if you wish to proceed with step [11](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#11-scp).

`$ sudo ./dojo.sh stop`


## 11. [SCP]

This part is optional, skip ahead to the to part [12](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Internal-Dojo-Install-Guide.md#12-finalize-dojo) if you don't mind waiting.

At the beginning, you had the option of downloading the Bitcoin mainnet blockchain on a faster computer, and copying it to over. Check the verification progress directly in Bitcoin Core on this computer. To proceed, it should be fully synced, see the status bar.

As soon as the verification is finished, shut down Bitcoin Core on Windows. We will now copy the data from your fully synced bitcoin node to the ODROID. This takes ~6 hours. Copy over the data from your fully synced node to `/mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/`. 

We are using “Secure Copy” (SCP), so download and install WinSCP, a free open-source program. Mac and Linux instructions are below.

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
For Linux or Mac check out @BTCxZelko's well written instructions [here](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Bitcoin-Blockchain-Transfer.md).
```
Optional Reading: SCP on Linux - https://www.computerhope.com/unix/scp.htm
Optional Reading: WinSCP Windows - https://winscp.net/eng/docs/start
```


## 12. [FINALIZE DOJO]

Once your Dojo has done a full sync or the data has been copied over, let's check on some logs. Now is also a good time to get familiar with commands.

Start up if you need to.

`$ sudo ./dojo.sh start` 

Check that all containers are up. Begin to troubleshoot now if all containers do not show as up.

`$ sudo docker ps`

You can bring up the logs for all containers at any time by using this command. It can take some time as it attach to all containers and give output.

`$ sudo ./dojo.sh logs`

Check on tracker.

`$ sudo ./dojo.sh logs tracker`

Check that bitcoind is running properly.

`$ sudo ./dojo.sh logs bitcoind`

Did Tor bootstrap 100%?

` $ sudo ./dojo.sh logs tor`

If everything looks ok, go ahead and retrieve the Tor onion addresses (v2 and v3) of the API of your Dojo.

`$ sudo ./dojo.sh onion`

A maintenance tool is accessible through your Tor browser at this onion address you have just obtained. Other than maintenance, this tool is what you will use to pair a Samourai Wallet on mobile to your Dojo on ODROID. The tool requires that you allow javascript for the site.

A few lines ago you edited `docker-node.conf.tpl` entered a value for `NODE_ADMIN_KEY`. Go to the v3_address.onion (maintenance tool) and log in using the `NODE_ADMIN_KEY` value. Click the pairing tab and you will see a QR code for pairing. We will utilize in the next step where you will pair your Samourai Wallet with your Dojo.

Take some time to get familiar with Dojo commands and docs below.

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
