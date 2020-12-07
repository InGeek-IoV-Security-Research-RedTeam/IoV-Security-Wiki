netinterfaces=`ls /sys/class/net`
for netinterface in $netinterfaces; do
        command='/system/xbin/tcpdump -i '$netinterface' -w '$netinterface'.pcap &'
        echo $command
        $command
done