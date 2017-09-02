# motion_surveillance
motion_surveillance: Raspberry Pi Surveillance System for your Home. Basic script &amp; config to keep motion running, with data older than 1 day automatically removed.

##### How to configure and install
```
sudo apt-get install motion tmpreaper

```
Copy motion to `/etc/default/motion`

Copy motion.conf to `/etc/motion/motion.conf`

We don't want motion to run as daemon, we want to use our script.

So only for once you can start the daemon using the following command, but you'll need to start the script:

```
sudo service motion start
```

To start the motion using script,

```
sudo ./start_motion_surveillance.sh
```
