#!/bin/bash

# motion_surveillance
# @author Mustafa Ozcelikors
# @contact mozcelikors@gmail.com
#

echo $(date -u) "##### Starting Motion Server"
sudo motion &>/dev/null  & #Discard the stdout to /dev/null

while true; do
	sudo tmpreaper 1d /var/lib/motion/ # Delete last day's data
	echo $(date -u)" ##### Motion Server, Tmpreaper - working.."
	sleep 3600 #Every hour, clear 
done
