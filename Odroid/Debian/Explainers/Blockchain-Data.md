The Bitcoin blockchain records all transactions and basically defines who owns how many bitcoin. This is the most crucial of all information and we should not rely on someone else to provide this data. To set up our Bitcoin Full Node on mainnet, we need to download the whole blockchain (~ 250 GB), verify every Bitcoin transaction that ever occurred, every block ever mined, create an index database for all transactions, so that we can query it later on, calculate all bitcoin address balances (called the UTXO set). Look up "running a bitcoin full node" for additional information.

The ODROID is up to the big task of downloading the blockchain. So you may wonder, why have the option for downloading on a faster machine, and copying over the data? The download is not the problem, but to initially process the whole blockchain would take a long time due to its computing power and memory. Probably a few days time.

Therefore we give the option to download and verify the blockchain with Bitcoin Core on your regular computer, and then transfer the data to the ODROID. This needs to be done only once. After that the ODROID can easily keep up with new blocks.

This guide assumes that many will use a Windows machine, but it should also work with most operating systems. I have done my best to provide Linux or Mac instructions where possible. You need to have about 250+ GB free disk space available, internally or on an external hard disk (but not the SSD reserved for the ODROID). As indexing creates heavy read/write traffic, the faster your hard disk the better. If you are using linux as a main machine I will assume that you are comfortable lookup up how to download Bitcoin Core.

Using SCP, you will have the option to copy the blockchain from the Windows computer, over the local network a bit later in this guide after Dojo is installed.

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
Check this hash "3bac067..." against the SHA256SUMS.asc file which can be found [here as an example](https://bitcoincore.org/bin/bitcoin-core-0.18.1/).

Open Bitcoin Core, leave it to sync, and now you can finish your Dojo install.
