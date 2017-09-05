#!/bin/sh
echo 1 > /sys/class/leds/hg255d:usb/brightness
ok=0
ping qq.com -c 1 | grep -q "ttl=" && ok=2 || echo "###connection lost!###"
while [ $ok -eq 0 ]
do
ping bras.seu.edu.cn -c 1 | grep -q "ttl=" && ok=0 || ok=3
echo -en '\r\n' >> /tmp/connectlog.txt
echo "~Connection lost at:" >> /tmp/connectlog.txt
date >> /tmp/connectlog.txt
/etc/init.d/bras start
ping qq.com -c 1 | grep -q "ttl=" && ok=1 || echo "###connection failed, retry...###"
done
if [ $ok -eq 2 ] ; then
	echo 1 > /sys/class/leds/hg255d:wps/brightness
	echo "###connection fine!###"
fi
if [ $ok -eq 1 ] ; then
	echo 1 > /sys/class/leds/hg255d:wps/brightness
	echo -en '\r\n' >> /tmp/connectlog.txt
	echo "*Connection back at:" >> /tmp/connectlog.txt
	date >> /tmp/connectlog.txt
	echo -en '\r\n' >> /tmp/connectlog.txt
	echo "###connection recovered!###"
fi
if [ $ok -eq 3 ] ; then
	echo 0 > /sys/class/leds/hg255d:wps/brightness
	echo -en '\r\n' >> /tmp/connectlog.txt
	echo "#IPv6 link error at:" >> /tmp/connectlog.txt
	date >> /tmp/connectlog.txt
	echo -en '\r\n' >> /tmp/connectlog.txt
	echo "###IPv6 is off, stop retrying!###"
fi
echo 0 > /sys/class/leds/hg255d:usb/brightness