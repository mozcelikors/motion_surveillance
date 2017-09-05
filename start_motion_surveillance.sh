#!/bin/bash

#  motion_surveillance: 
#  Motion service with additional features for Rpi
#  Copyright (C) 2017 Mustafa Ozcelikors, mozcelikors@gmail.com
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Help function
helpwindow ()
{
	echo "Arguments for start_motion_surveillance.sh are:"
	echo "#################################################"
	echo "-m or --min-space-left : 	Minimum amount of disk space to start deleting data (in percent)"
	echo "-d or --days-to-keep :	How many days of data to keep.  (e.g. To specify 5 days, write 5d)"
	echo "-h or --help : 		This oh-so-helpful help window!"
	echo "#################################################"
	echo "Example usage: sudo ./start_motion_surveillance.sh -m 95 -d 5d"
}

# Check if help window is called
if [ "$1" == "" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	helpwindow
	exit 0
fi

# Check command line arguments
while [[ $# -gt 1 ]]
do
	key="$1"
	case $key in
		-m|--min-space-left)
			MIN_SPACE_LEFT="$2"
			shift
		;;
		-d|--days-to-keep)
			DAYS_TO_KEEP="$2"
			shift
		;;
		*)
			#Unknown
			helpwindow
		;;
	esac
	shift
done

# Check for the command line args
if [[ -z ${MIN_SPACE_LEFT+x} ]]; then # If non-defined, use default value
	MIN_SPACE_LEFT=95
fi
if [[ -z ${DAYS_TO_KEEP+x} ]]; then # If non-defined, use default value
	DAYS_TO_KEEP=5d
fi

# Start the motion service in another process and discard its output
echo $(date -u) "##### Starting Motion Service"
sudo motion &>/dev/null  & # Discard the stdout to /dev/null

while true; do
	# Extract disk space used on /dev/root
	# Using sed to get the number, and trim whitespaces of df command
	SPACE_USED=$(sudo df --output=pcent / | sed 's/[^0-9]*//g' | tr -d '[:space:]') 	
	
	# Extract raspberry pi cpu temperature (float number) with sed
	# Check if we are able to measure CPU temperature
	if ! type "/opt/vc/bin/vcgencmd measure_temp" > /dev/null; then
  		RPI_CPU_TEMP=$(/opt/vc/bin/vcgencmd measure_temp | sed -r 's/.*_([0-9]*)\..*/\1/g' | tr -d '[:space:]') 
	fi
	
	# Delete data older than five days
	sudo tmpreaper $DAYS_TO_KEEP /var/lib/motion/ 
	
	# Print information
	echo $(date -u)" ##### Motion Server, Tmpreaper - working.."
	echo $(date -u)" ##### Space used on the machine: $SPACE_USED%"
	echo $(date -u)" ##### CPU temperature:           $RPI_CPU_TEMP' "
	
	# Check for disk space
	if [ "$SPACE_USED" -ge "$MIN_SPACE_LEFT" ]; then
		echo $(date -u)" ##### System is running out of space, deleting last 100 files"
		cd /var/lib/motion
		
		# Delete last 100 files to clear up some disk space
		for i in `seq 1 100`; do
			sudo rm "$(ls -t | tail -1)"
		done
		echo $(date -u)" ##### Complete"
	fi
	sleep 60 #Every minute, check 
done
