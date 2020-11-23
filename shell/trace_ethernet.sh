echo 'Usage: sh trace_ethernet.sh'
# get Ethernet card number
num=`ls /sys/class/net | awk 'END{print NR}'`
echo 'ethernet card num '$num
for((i=1;i<=num;i++));
do
	# get card 
	encard=`ls /sys/class/net | sed -n $i'p'`
	# execute
	echo 'tcpdump -i '$encard' -w /tmp/'$encard.pcap '&'
	/tmp/tcpdump -i $encard -w /tmp/$encard.pcap &
done