# README
## for Odroid N2

Welcome!

If you are new to many of these concepts that is ok, no prior experience is required. This guide should help you get started and point you in the right directions for researching.

Choose one of the methods of deployment below. What is it that you want, need, or prefer?

## 1. [Internal Dojo Install Guide](https://github.com/BTCxZelko/Samourai-Dojo-RPi4-and-Odroid-Install-Guides/blob/master/Odroid/Raspbian/Internal-Dojo-Install-Guide.md)

This is inspired by what is considered to be the "default dojo deployment". This setup is recommended to Samourai users who feel comfortable with a few command lines and want to learn about running a Dojo. If you are not willing to learn these basic command line steps this is not for you. You might want to check out option [1A](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Convenience-Scripts/Internal-Dojo-Install-Script.sh) (see below) or a "plug 'n play" Dojo like [this one](https://shop.nodl.it). 

Samourai Dojo is the backing server for Samourai Wallet. It provides HD account, loose addresses (BIP47) balances, and transactions lists. Also provides unspent output lists to the wallet. PushTX endpoint broadcasts transactions through the backing bitcoind node. 

MyDojo is a set of Docker containers providing a full Samourai backend composed of:
* a bitcoin full node accessible as an ephemeral Tor hidden service
* a backend database
* a backend modules with an API accessible as a static Tor hidden service
* a maintenance tool accessible through a Tor web browser

## 1A. [Internal Dojo Convenience Script](https://github.com/BTCxZelko/Ronin-Dojo/blob/master/Odroid/Debian/Convenience-Scripts/Internal-Dojo-Install-Script.sh)

Minimal effort required. If you are looking for the easiest method then this script is probably what you want. This script is inspired by what is considered to be the "default dojo deployment". It is for those that do not want to manually deploy or learn about Dojo. 

## 2. [External Bitcoind Install Guide](https://github.com/BTCxZelko/Samourai-Dojo-RPi4-and-Odroid-Install-Guides/blob/master/Odroid/Raspbian/External-Bitcoind-Install-Guide.md)

This setup will be running bitcoind externally, which is a bit more advanced, versus leaving the default option enabled where bitcoind will run inside Docker. This setup is useful for a many reasons like using pre-existing full node, it is faster than waiting for a full blockchain sync with ODROID N2, and Docker can be confusing to connect things like an electrum server to. This setup will also teach new users some very useful skills involving networking, hardware, linux, and bitcoin. Samourai Dojo is the backing server for Samourai Wallet. It provides HD account, loose addresses (BIP47) balances, and transactions lists. Also provides unspent output lists to the wallet. PushTX endpoint broadcasts transactions through the backing bitcoind node. 

In this case MyDojo is a set of Docker containers providing a full Samourai backend composed of:
* a backend database
* a backend modules with an API accessible as a static Tor hidden service
* a maintenance tool accessible through a Tor web browser

## 2B. [Coming Soon]
