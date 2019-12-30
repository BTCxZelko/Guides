# Welcome to the Whirlpool Installation Guide
<sub>by @BTCxZelko</sub>

Source: https://github.com/Samourai-Wallet/Whirlpool

This guide will allow you to set up the Whirlpool-client-cli, serving as a backend for continous mixing, even when you GUI is not running.

## Prepare your Pi
   1. First install openjdk

```
sudo pacman -S jdk11-openjdk
```

   2. Create a whirlpool directory and pull the latest whirlpool-client-cli file

```
cd $HOME
mkdir whirlpool
cd whirlpool
wget -O whirlpool.jar https://github.com/Samourai-Wallet/whirlpool-client-cli/releases/download/0.10.0/whirlpool-client-cli-0.10.0-run.jar
```

   3. Install Tor outside docker if you haven't already.
      - NOTE: it is recommended to create a new user for tor for security purposes
      - Luckily, Manjaro-ARM automatically creates a new user for this!

```
sudo pacman -S tor
```

Edit the torrc file

```
sudo nano /etc/tor/torrc
-------------
# uncomment:
ControlPort 9051
CookieAuthentication 1

# add:
CookieAuthFileGroupReadable 1
```

**Save and exit: Ctrl+X, y, Enter**

```
sudo systemctl restart tor
```

   4. Install tmux to allow us to close out the window but keep whirlpool running

```
sudo pacman -S tmux
````

## Mobile Pairing Code

Open up your Samourai Mobile Wallet
Press 3 dots on top right -> Settings -> Transactions-> Pair to Whirlpool GUI. Copy the code to clipboard
Send the code to yourself, how you feel is most secure.

## Back to Pi

Make sure we are in the correct directory and initiate the whirlpool client

```
cd whirlpool
tmux new -s whirlpool
java -jar whirlpool.jar --init --tor
```
   - This will ask for your pairing code, Paste it when prompted with Ctrl+Shift+V
   - When it displays the API key. Copy that key and send to your main computer however is most secure for you. 
      - You will need this to pair with GUI

The whirlpool client with then close and ask to run again.

But first we need to edit the configuration file to point to tor
```
nano whirlpool-cli-config.properties
-----------------
### Copy and Paste the following to the end of the file ###

cli.torConfig.executable=/usr/bin/tor

```
**Save and exit: Ctrl+X, y, Enter**

This time we run a different command:

```
java -jar whirlpool.jar --server=mainnet --tor --auto-mix --authenticate --mixs-target=0 --listen
### NOTE: If you want the mixing target to be a different number other than infinity change the mixs-target to desired number
```

This time it will ask for your Mobile wallet passpharase to authenticate the wallet
   - Enter it when prompted

It should load all your potential mixs. and be running.

Close out the tmux window with:
   **Ctl+B , D**

**NOTE: To get back in later simply enter the following command:**

```
tmux a -t 'whirlpool'
```

## Pairing your with the Whirlpool GUI

Let's install the Whirlpool GUI on a your main computer for a beautiful interface.

Go to https://github.com/Samourai-Wallet/whirlpool-gui/releases and grab the appropriate file for your system. For this guide: I'll just use the App.Image

```
wget https://github.com/Samourai-Wallet/whirlpool-gui/releases/download/0.9.1/whirlpool-gui.0.10.0.AppImage
sudo chmod +x whirlpool-gui.0.10.0.AppImage
```

And now let's launch it:

```
./whirlpool-gui.0.10.0.AppImage
```

Ok so you'll be shown with two options: Standalone CLI or Remote CLI. Select remote CLI (our pi)

Next you'll need to enter your Pi's IP address: https://192.168.X.XXX 

**NOTE: If you do not know your Pi's IP address, go into terminal and type:**

```
ip a
### if you are connected via ethernet, look for eth0 
### if you are connected via wifi, look for wlan0 
```

API Key you saved earlier, copy the code, click on the api box and hit Ctrl+V. 

_Leave the Port as is_

Now connect. May take a minute or so, but you'll see the wallet ask for your passphrase again. This is your Mobile wallet BIP39 
passphrase you entered in the CLI. 

Once it registers you'll be connected for self-sovereign continuous mixing!

## Support

If you appreciate our work and wish to support our continued efforts in providing free, unencumbered, open source code that enhances your sovereignty please consider a donation.

### Address

3MbsfzyXG1xeojmH5jju8XRePdfZLu6gwa

[![address](http://api.qrserver.com/v1/create-qr-code/?color=000000&bgcolor=FFFFFF&data=bc1qma3vyljvz0n3n0e7czaewx8tq5heugv2kvrcq2&qzone=1&margin=0&size=200x200&ecc=L)](https://oxt.me/address/3MbsfzyXG1xeojmH5jju8XRePdfZLu6gwa)

### PayNym (BIP47)

+supersnowflake4DD
PM8TJgV7iwMBnEUEQemstA74aXas17M5uF4JvN1Q36SknCqSxgs6VHMb6ftGcKh2Xrb6kppJvzjSqDtwWRSAkn7v6YejN8D4Fi1jk6nBsCDRqSQrWkD5 

[![BIP47 payment code](http://api.qrserver.com/v1/create-qr-code/?color=000000&bgcolor=FFFFFF&data=PM8TJgV7iwMBnEUEQemstA74aXas17M5uF4JvN1Q36SknCqSxgs6VHMb6ftGcKh2Xrb6kppJvzjSqDtwWRSAkn7v6YejN8D4Fi1jk6nBsCDRqSQrWkD5&qzone=1&margin=0&size=200x200&ecc=L)](https://paynym.is/+supersnowflake4DD)
