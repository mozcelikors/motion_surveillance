# motion_surveillance
motion_surveillance: Raspberry Pi Surveillance System for your Home. Basic script &amp; config to keep motion running, with data older automatically removed. Also disk space is checked and older data is removed periodically.

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
sudo chmod +x start_motion_surveillance.sh
sudo ./start_motion_surveillance.sh
```

The stream and pictures are located at `/var/lib/motion` by default. Modify the scripts to change it if you like.
