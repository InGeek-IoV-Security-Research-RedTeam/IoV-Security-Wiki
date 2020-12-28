# ubuntu18.04编译安装qemu5.2.0与初步测试使用

```bash
##安装依赖 
$ sudo apt-get install build-essential pkg-config zlib1g-dev 
$ sudo apt-get install libglib2.0-0 libglib2.0-dev 
$ sudo apt-get install libsdl1.2-dev 
$ sudo apt-get install libpixman-1-dev libfdt-dev 
$ sudo apt-get install autoconf automake libtool 
$ sudo apt-get install librbd-dev 
$ sudo apt-get install libaio-dev 
$ sudo apt-get install flex bison 
$ sudo apt-get install re2c
## 安装ninja
$ git clone https://github.com/ninja-build/ninja.git
$ cd ninja
$ ./configure.py --bootstrap   #在ninja目录中执行
$ sudo cp ./ninja  /usr/bin  #在ninja目录中执行
##下载源码并编译 
wget https://download.qemu.org/qemu-5.2.0.tar
$ tar zxvf qemu-5.2.0.tar
$ cd qemu-5.2.0
$ ./configure
$ make -j4
$ sudo make install
##下载initrd.gz
wget http://ftp.debian.org/debian/dists/stable/main/installer-mips/current/images/malta/netboot/initrd.gz
##下载kernel boot
wget http://ftp.debian.org/debian/dists/stable/main/installer-mips/current/images/malta/netboot/vmlinux-4.19.0-13-4kc-malta
##创建qemu image file
##不需要桌面的话，按照https://markuta.com/how-to-build-a-mips-qemu-image-on-debian/推荐创建一个2G的硬盘
$ qemu-img create -f qcow2 hda.img 2G
$ qemu-system-mips -M malta -m 512 -hda hda.img -kernel vmlinux-4.19.0-13-4kc-malta -initrd initrd.gz -append "console=ttyS0 nokaslr" -nographic
##按照提示安装，默认安装ssh
##最后一步，选择go back，选择‘Execute Shell’，然后shell中输入'poweroff'
##挂载镜像
$ sudo modprobe nbd max_part=63
$ sudo qemu-nbd -c /dev/nbd0 hda.img
$ sudo mount /dev/nbd0p1 /mnt
##拷贝boot分区文件到当前目录
$ cp -r /mnt/boot/initrd.img-* ./
$ cp -r /mnt/boot ./
##卸载
$ sudo umount /mnt
$ sudo qemu-nbd -d /dev/nbd0
##配置网络
$ sudo apt-get install uml-utilities bridge-utils
##配置interfaces
$ sudo gedit /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)
auto lo
iface lo inet loopback

auto ens33 #ens33这里是你自己的网卡
iface ens33 inet dhcp #ens33这里是你自己的网卡
#auto br0
iface br0 inet dhcp
    bridge_ports ens33 #ens33这里是你自己的网卡
    bridge_maxwait 0
##配置/usr/local/etc/qemu-ifup
$ sudo gedit /usr/local/etc/qemu-ifup
#!/bin/sh
sudo /sbin/ifconfig $1 0.0.0.0 promisc up
sudo /sbin/brctl addif br0 $1
sleep 2
##启动br0网卡
$ sudo chmod +x /usr/local/etc/qemu-ifup
$ sudo /etc/init.d/networking restart
$ sudo ifdown ens33 #这里是你自己的网卡
$ sudo ifup br0
##启动虚拟机
$ sudo qemu-system-mips -M malta -m 512 -hda hda.img -kernel vmlinux-* -initrd initrd.img-* -append "root=/dev/sda1 console=ttyS0 nokaslr" -net nic,macaddr=00:16:3e:00:00:02 -net tap -nographic
##使用账号密码登录，测试网络是否OK
$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s11: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 1000
    link/ether 00:16:3e:00:00:02 brd ff:ff:ff:ff:ff:ff
    inet 192.168.110.132/24 brd 192.168.110.255 scope global dynamic enp0s11
       valid_lft 1609sec preferred_lft 1609sec
    inet6 fe80::216:3eff:fe00:2/64 scope link 
       valid_lft forever preferred_lft forever
$ ping www.baiu.com
##外部登录虚拟机
$ ssh alex@192.168.110.132
##尝试拷贝文件
$ scp aboot.img alex@192.168.110.132:/tmp/
alex@192.168.110.132's password: 
aboot.img  
```





参考：

> https://markuta.com/how-to-build-a-mips-qemu-image-on-debian/
>
> https://blog.csdn.net/weixin_43194921/article/details/104702724