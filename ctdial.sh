#!/bin/sh
echo 1 > /sys/class/leds/hg255d:usb/brightness
nec=0
#declare -i tem=0
ping qq.com -c 2 -W 1 | grep -q "ttl=" && nec=1
ping 192.168.7.77 -c 4 -W 1 | grep -q "ttl=" && tem=$((tem+1))
ping 192.168.7.78 -c 2 -W 1 | grep -q "ttl=" && tem=$((tem+2))
echo 0 > /sys/class/leds/hg255d:wps/brightness
echo 0 > /sys/class/leds/hg255d:voice/brightness
if [ "$tem" -gt "0" ] ;then
	if [ $nec -eq 0 ] ; then
		ifup wan
		echo -en '\r\n\r\n' >> /tmp/connect.log
		echo "+Code " >> /tmp/connect.log
		echo $tem >> /tmp/connect.log
		echo " connected at:" >> /tmp/connect.log
		date >> /tmp/connect.log
	fi
	if [ "$((tem%2))" -eq "1" ] ; then echo 1 > /sys/class/leds/hg255d:wps/brightness; fi
	if [ "$tem" -gt "1" ] ; then echo 1 > /sys/class/leds/hg255d:voice/brightness; fi
elif [ "$nec" -eq "1" ] ; then
	ifdown wan
	echo -en '\r\n' >> /tmp/connect.log
	echo "-Net disconnected at:" >> /tmp/connect.log
	date >> /tmp/connect.log
fi
echo 0 > /sys/class/leds/hg255d:usb/brightness