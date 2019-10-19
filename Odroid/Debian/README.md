# README
## for Odroid N2

If you are new to many of these concepts that is ok, no prior experience is required. This guide should help you get started and point you in the right directions for researching.

Choose between the 2 guides [Internal Dojo Install Guide](https://github.com/BTCxZelko/Samourai-Dojo-RPi4-and-Odroid-Install-Guides/blob/master/Odroid/Raspbian/Internal-Dojo-Install-Guide.md) or [External Bitcoind Install Guide](https://github.com/BTCxZelko/Samourai-Dojo-RPi4-and-Odroid-Install-Guides/blob/master/Odroid/Raspbian/External-Bitcoind-Install-Guide.md) below. This choice is based on your needs and preferences. If you need to do something more advanced like run bitcoind outside of Docker then I do recommend the Advanced Setup guide.

## 1. [Internal Dojo Install Guide](https://github.com/BTCxZelko/Samourai-Dojo-RPi4-and-Odroid-Install-Guides/blob/master/Odroid/Raspbian/Internal-Dojo-Install-Guide.md)

This is inspired by what is considered to be the "default dojo deployment". This setup is recommended to Samourai users who feel comfortable with a few command lines. If you are not willing to learn these basic command line steps this is not for you and you might want to check out a "plug 'n play" Dojo like [this one](https://shop.nodl.it). Samourai Dojo is the backing server for Samourai Wallet. It provides HD account, loose addresses (BIP47) balances, and transactions lists. Also provides unspent output lists to the wallet. PushTX endpoint broadcasts transactions through the backing bitcoind node. 

MyDojo is a set of Docker containers providing a full Samourai backend composed of:
* a bitcoin full node accessible as an ephemeral Tor hidden service
* a backend database
* a backend modules with an API accessible as a static Tor hidden service
* a maintenance tool accessible through a Tor web browser

## 2. [External Bitcoind Install Guide](https://github.com/BTCxZelko/Samourai-Dojo-RPi4-and-Odroid-Install-Guides/blob/master/Odroid/Raspbian/External-Bitcoind-Install-Guide.md)

This setup will be running bitcoind externally, which is a bit more advanced, versus leaving the default option enabled where bitcoind will run inside Docker. This setup is useful for a many reasons like using pre-existing full node, it is faster than waiting for a full blockchain sync with ODROID N2, and Docker can be confusing to connect things like an electrum server to. This setup will also teach new users some very useful skills involving networking, hardware, linux, and bitcoin. Samourai Dojo is the backing server for Samourai Wallet. It provides HD account, loose addresses (BIP47) balances, and transactions lists. Also provides unspent output lists to the wallet. PushTX endpoint broadcasts transactions through the backing bitcoind node. 

In this case MyDojo is a set of Docker containers providing a full Samourai backend composed of:
* a backend database
* a backend modules with an API accessible as a static Tor hidden service
* a maintenance tool accessible through a Tor web browser

If you have some spare time please make a github account and edit these guide. You can also fork the guide to your own version, maybe for a purpose such as adding more detailed notes, or perhaps for making more drastic changes like a different method of deployment. It was a community effort that helped me bring this guide together, and it may take the same effort to keep this guide polished and up to date.  Feel free to revise things, make suggestions, become contributor, update versions, et cetera. Thank you!
