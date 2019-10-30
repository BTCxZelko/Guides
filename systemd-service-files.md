# systemd service files to auto start programs

Assuming we have our `dojo` folder at `${HOME}/dojo`, we'll create a shell script in `${HOME}/bin` to start this program as needed:

```
${HOME}/bin/dojo:

#!/bin/bash

cd ${HOME}/dojo/docker/my-dojo/
./dojo.sh $*
```

Once we have our little script we can create the service script in /etc/systemd/system:

```
/etc/systemd/system/dojo.service:

[Unit]
Description=Samourai Dojo
After=bitcoind.service

# Substitute XXXX with your user

[Service]
ExecStart=/home/XXXX/bin/dojo start
User=XXXX
Group=XXXX
Type=simple
KillMode=process
TimeoutSec=60
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
```

Let's enable and start our service:

```
$ systemctl enable dojo.service
$ systemctl start dojo.service
```

From now on dojo should be started automatically with every system boot
