# Ronin Dojo Guides
Ronin Dojo is the RPi4 and Odriod N2 installation variant of Samourai Wallet's Dojo. This is not a change to their code or application, rather the installation process modified specifically for RPi4/Odroid. 

Our Mission is to bring full on-chain self-sovereignity at an afforable price!

> A Ronin was a samurai warrior in feudal Japan without a master or lord — known as a daimyo. A samurai could become a ronin in several different ways: his master might die or fall from power or the samurai might lose his master's favor or patronage and be cast off.

Be Your own MASTER!

# What is Samourai Dojo?
As stated by the Samourai Team:
>Samourai Dojo is the backing server for Samourai Wallet. Provides HD account & loose addresses (BIP47) balances & transactions lists. Provides unspent output lists to the wallet. PushTX endpoint broadcasts transactions through the backing bitcoind node.

This implementation connects to your wallet via Tor for increased privacy and allowing for connectivity anywhere without forwarding ports and exposing your home IP address.

For more information on Samourai Wallet, Dojo, and Whirlpool visit the [Samourai Wallet Github](https://github.com/Samourai-Wallet).

## Recommended Hardware
The Full Dojo installation, which includes a fresh sync of the Bitcoin blockchain, requires a little over 3GB of RAM during the initial sync. Then it drops to a little less than 2GB after sync is complete. Thusly we recommend: [Odroid N2](https://www.hardkernel.com/shop/odroid-n2-with-4gbyte-ram/) or the [Raspberry Pi4](https://www.canakit.com/raspberry-pi-4-4gb.html?cid=usd&src=raspberrypi). 
>**NOTE: We do not endorse any particular supplier or product.**

## External Drives
Given the increased performance and longevity of use: we recommend 1TB SSD such as: [Samsung T5](https://www.amazon.com/Samsung-T5-Portable-SSD-MU-PA1T0B/dp/B073H552FJ/ref=sr_1_1?fst=as%3Aoff&qid=1571081118&refinements=p_n_feature_three_browse-bin%3A6797521011&rnid=6797515011&s=pc&sr=1-1) or [Seagate Fast SSD](https://www.amazon.com/Seagate-External-Reversible-Type-C-STCM1000400/dp/B07DX7D744). 

However, if you are looking to run a node a budget, you can use external HDD's such as: [Toshiba Canvio 1TB](https://www.amazon.com/Toshiba-HDTB410XK3AA-Canvio-Portable-External/dp/B079D359S6/ref=sr_1_4?crid=27WAK2Y8TLQEX&keywords=external+hard+drive&qid=1571082291&refinements=p_n_feature_two_browse-bin%3A5446812011&rnid=562234011&sprefix=external%2Caps%2C234&sr=8-4) or [Seagate Expansion 1TB](https://www.amazon.com/Seagate-Expansion-Portable-External-STEA1000400/dp/B00TKFEEAS/ref=sr_1_14?crid=27WAK2Y8TLQEX&keywords=external+hard+drive&qid=1571082291&refinements=p_n_feature_two_browse-bin%3A5446812011&rnid=562234011&sprefix=external%2Caps%2C234&sr=8-14). 

>**Do your own research to find out which SSD/HDD you believe is best for you, these are recommendations.**

## SD cards
You'll need a SD card to flash the OS of choice (we will cover Raspbian and Manjaro-ARM).
For this we recommend: [Samsung EVO+ 64GB](https://www.amazon.com/Samsung-MicroSDXC-Memory-Adapter-MB-MC64GA/dp/B06XFWPXYD/ref=sr_1_4?keywords=EVO%2B+SD+card&qid=1571081610&s=electronics&sr=1-4). You'll need at least 16GB but for the price this is a great deal for a high quality SD card. 

## Flashing Operating System
This guide will cover [Raspbian](https://www.raspberrypi.org/downloads/raspbian/), [Manjaro Desktop GUI](https://osdn.net/projects/manjaro-arm/storage/rpi4/), and [Debian](https://github.com/s2l1/Headless-Samourai-Dojo/blob/master/Default_Dojo_Setup.md#1-hardware-requirements) Installations. Follow the links for more information and installation instructions.
>For Manjaro-Arm: **NOTE**: The XFCE is the desktop version and Minimal is best for headless use. The XFCE version is resource heavy and will likely not be able to handle Dojo+Whirlpool+Electrs. For that option install Minimal [here](https://osdn.net/projects/manjaro-arm/storage/rpi4/minimal/19.10/)

## Cases
We strongly recommend getting a case that keeps the Pi or Odroid cool. 
1. For RPi4: 
   - Either with active cooling cases such as:[Flirc](https://www.amazon.com/Flirc-Raspberry-Pi-Case-Silver/dp/B07WG4DW52/ref=sr_1_8?keywords=pi4+case&qid=1571082492&sr=8-8) 
   - Or a case with a fan such as [Miuzei](https://www.amazon.com/Miuzei-Raspberry-Cooling-Heat-Sinks-Supply/dp/B07TTN1M7G/ref=sr_1_5?crid=2FLR4GW4Y32PN&keywords=pi4%2Bcase%2Bwith%2Bfan&qid=1571082607&sprefix=pi4%2Bcase%2B%2Caps%2C222&sr=8-5&th=1) 

2. For Odroid:
   - [KSSB Case](https://ameridroid.com/products/kksb-odroid-n2-case)
   - [ODROID-N2 Case](https://ameridroid.com/products/odroid-n2-case)

## Installation
Once you have obtained your hardware and assembled it, you can choose from a few different installation options:
1. Complete Installation of Dojo *referred to as Internal Dojo*
   - RPi4
     - [Raspbian](https://github.com/BTCxZelko/Samourai-Dojo-RPi4-and-Odroid-Install-Guides/tree/master/RPi4/Raspbian)
     - [Manjaro-ARM XFCE](https://github.com/BTCxZelko/Samourai-Dojo-RPi4-and-Odroid-Install-Guides/blob/master/RPi4/Manjaro/XFCE/Internal-Dojo.md)
     - [Manjaro-ARM Minimal](https://github.com/BTCxZelko/Samourai-Dojo-RPi4-and-Odroid-Install-Guides/blob/master/RPi4/Manjaro/Minimal/Internal-Dojo.md)
   - Odroid
     - [Debian](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/README.md#1-internal-dojo-install-guide)
2. Installation of Dojo utilizing an external Bitcoin Core node *referred to as External Dojo*
   - RPi4
     - Raspbian
     - Manjaro-ARM XFCE(coming)
   - Odriod
     - [Debian](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/README.md#2-external-bitcoind-install-guide)
