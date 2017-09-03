#!/bin/bash

# motion_surveillance
# @author Mustafa Ozcelikors
# @contact mozcelikors@gmail.com
#

echo $(date -u) "##### Starting Motion Server"
sudo motion &>/dev/null  & #Discard the stdout to /dev/null

while true; do
	SPACE_USED=$(sudo df --output=pcent / | sed 's/[^0-9]*//g' | tr -d '[:space:]') #Using sed to get the number, and trim whitespaces of df command
	sudo tmpreaper 2d /var/lib/motion/ # Delete data older than two days
	echo $(date -u)" ##### Motion Server, Tmpreaper - working.."
	echo $(date -u)" ##### Space used on the machine $SPACE_USED%"
	if [ "$SPACE_USED" -ge "95" ]; then
		echo $(date -u)" ##### System is running out of space, deleting last 100 files"
		cd /var/lib/motion
		for i in `seq 1 100`; do
			sudo rm "$(ls -t | tail -1)"
		done
		echo $(date -u)" ##### Complete"
	fi
	sleep 60 #Every minute, check 
done
