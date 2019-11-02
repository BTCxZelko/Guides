## NFS Shares
<sub> By Jaimefoo

If you already have a NAS at home and don't want to buy another hard drive, there is always the possibility of serving bitcoin blocks over the local network on an NFS shared storage. We are asuming your `bitcoind` installation is external to Dojo.

Procedure:

1. Stop the `bitcoind` daemon

   `$ systemctl stop bitcoind`
   
2. Create a `bitcoin` volume in your NAS device (type: NFS) and share it to your local network. Create the folder `blocks` in that volume.

3. Mount that external NFS storage in the device (Raspberry PI, Odroid, Intel NUC, etc.) where your bitcoind is running

   ```
   $ sudo echo "nas:/volume1/bitcoin	/mnt/bitcoin	nfs	nolock,rw,intr,_netdev,user,auto	0 0" >> /etc/fstab
   $ mount /mnt/bitcoin
   ```
4. Move the already existing blocks in the $HOME directory to the new location and delete that blocks directory

   ```
   $ mv ${HOME}/.bitcoin/blocks/* /mnt/bitcoin/blocks
   $ rmdir ${HOME}/.bitcoin/blocks
   ```

5. Go to the configuration directory of bitcoind and substitute the `blocks` directory with the new `blocks` directory in the share: 

   ```
   $ cd ${HOME}/.bitcoin`
   $ ln -s /mnt/bitcoin/blocks blocks
   ```
6. Start the `bitcoind` daemon

   ```
   $ systemctl start bitcoind
   ```
