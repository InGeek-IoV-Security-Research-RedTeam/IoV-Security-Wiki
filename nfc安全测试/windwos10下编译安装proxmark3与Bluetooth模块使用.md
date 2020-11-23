# windwos10下编译安装proxmark3与Bluetooth模块使用

## bluetooth模块安装

蓝牙模块长这样：

![](.\images\10.jpg)

安装好后长这样：

![image-20201030113043228](.\images\11.jpg)

下面我们开始拼装：

先拆开上半部分的外壳，再卸下螺丝：

![image-20201030113908144](.\images\12.jpg)

安装软排线：

![image-20201030114105761](.\images\13.jpg)

扣好上半部分（这个金属按钮下面稍微垫点纸，不然按键接触不良，按下去不起作用），然后安装下半部分的天线：

![image-20201030114508873](.\images\14.png)

扣上天线外壳，完成：

![image-20201030114648341](.\images\15.png)

## windows10 安装wsl编译pm3

1. 首先安装windows terminal

   打开microsoft store搜索安装windows terminal

2. 安装wsl

   win+x选择应用和功能-程序和功能-启用或关闭windows功能，勾选

   ![image-20201030115111848](.\images\16.png)

按照提示重启系统，进入microsoft store搜索安装ubuntu18，等待安装完成，按照提示配置账户密码。

启动Windows terminal，选择下拉-ubuntu

![image-20201030115540679](.\images\17.png)

你的windows 下的各个盘挂载在mnt下面，所以你要切换盘符的话，`cd /mnt/*`就可以了。

先更新系统安装依赖:

```bash
$ sudo apt-get update
$ sudo apt-get install p7zip git ca-certificates build-essential libreadline5 libreadline-dev libusb-0.1-4 libusb-dev perl pkg-config wget libncurses5-dev gcc-arm-none-eabi libstdc++-arm-none-eabi-newlib libqt4-dev libboost-all-dev libbz2-dev
```

再下载proxmark3编译安装

```bash
$ cd Downloads
$ sudo git clone https://github.com/RfidResearchGroup/proxmark3.git
$ cd proxmark3
$ git pull
$ sudo cp -rf driver/77-pm3-usb-device-blacklist.rules /etc/udev/rules.d/
$ sudo udevadm control --reload-rules
$ exit
```

重新打开一个teminal

```bash
$ sudo adduser $USER dialout
$ cd proxmark3
# 打开蓝牙支持
$ cp Makefile.platform.sample Makefile.platform
$ nano Makefile.platform
# uncomment #PLATFORM_EXTRAS=BTADDON
$ make clean; make -j5
$ pm3-flash-fullimage
```

尝试usb连接pm3

```bash
$ pm3
[=] Session log /home/alex/.proxmark3/logs/log_20201030.txt
[+] loaded from JSON file /home/alex/.proxmark3/preferences.json
[=] Using UART port /dev/ttyS3
[=] Communicating with PM3 over USB-CDC


  ██████╗ ███╗   ███╗█████╗
  ██╔══██╗████╗ ████║╚═══██╗
  ██████╔╝██╔████╔██║ ████╔╝
  ██╔═══╝ ██║╚██╔╝██║ ╚══██╗
  ██║     ██║ ╚═╝ ██║█████╔╝       Iceman ☕
  ╚═╝     ╚═╝     ╚═╝╚════╝    ❄️ bleeding edge

  https://github.com/rfidresearchgroup/proxmark3/


 [ Proxmark3 RFID instrument ]

 [ CLIENT ]
  client: RRG/Iceman/master/v4.9237-1885-g60b12ca9 2020-10-30 11:00:28
  compiled with GCC 7.5.0 OS:Linux ARCH:x86_64

 [ PROXMARK3 ]
  firmware.................. PM3RDV4
  external flash............ present
  smartcard reader.......... present
  FPC USART for BT add-on... present

 [ ARM ]
  bootrom: RRG/Iceman/master/v4.9237-1885-g60b12ca9 2020-10-30 10:48:57
       os: RRG/Iceman/master/v4.9237-1885-g60b12ca9 2020-10-30 11:00:23
  compiled with GCC 6.3.1 20170620

 [ FPGA ]
  LF image built for 2s30vq100 on 2020-07-08 at 23: 8: 7
  HF image built for 2s30vq100 on 2020-07-08 at 23: 8:19
  HF FeliCa image built for 2s30vq100 on 2020-07-08 at 23: 8:30

 [ Hardware ]
  --= uC: AT91SAM7S512 Rev B
  --= Embedded Processor: ARM7TDMI
  --= Nonvolatile Program Memory Size: 512K bytes, Used: 298680 bytes (57%) Free: 225608 bytes (43%)
  --= Second Nonvolatile Program Memory Size: None
  --= Internal SRAM Size: 64K bytes
  --= Architecture Identifier: AT91SAM7Sxx Series
  --= Nonvolatile Program Memory Type: Embedded Flash Memory


[usb] pm3 --> hw tune
[=] Measuring antenna characteristics, please wait...
 🕛   9
[=] ---------- LF Antenna ----------
[+] LF antenna: 68.95 V - 125.00 kHz
[+] LF antenna: 31.89 V - 134.83 kHz
[+] LF optimal: 68.95 V - 125.00 kHz
[+] Approx. Q factor (*): 12.0 by frequency bandwidth measurement
[+] Approx. Q factor (*): 12.0 by peak voltage measurement
[+] LF antenna is OK
[=] ---------- HF Antenna ----------
[+] HF antenna: 47.33 V - 13.56 MHz
[+] Approx. Q factor (*): 8.3 by peak voltage measurement
[+] HF antenna is OK

(*) Q factor must be measured without tag on the antenna

[+] Displaying LF tuning graph. Divisor 88 (blue) is 134.83 kHz, 95 (red) is 125.00 kHz.
```

一切正常，现在我们尝试使用android手机通过蓝牙连接pm3

手机下载安装RFID Tools[apk](https://github.com/RfidResearchGroup/RFIDtools/releases/tag/v1.4.9)，打开电源与蓝牙开关

![image-20201030121327110](.\images\18.png)

尝试连接这个设备，密码1234：

![image-20201030121743507](.\images\19.png)

然后打开app选择如下图：

![image-20201030121917914](D:\Workflow\技术文档\车辆安全测试\nfc安全测试\images\20.png)

在已连接中寻找设备，点击连接：

![image-20201030122227018](.\images\21.png)

继续

![image-20201030122311939](.\images\22.png)

成功后如下图:

![image-20201030122413474](.\images\23.png)

尝试使用`hw tune`查看连接是否通畅：

![image-20201030122512778](.\images\24.png)

## 使用手机进行抓包

先扫一下目标卡是什么类型：

```bash
$ auto
[usb] pm3 --> auto

[=] NOTE: some demods output possible binary
[=] if it finds something that looks like a tag
[=] False Positives ARE possible
[=]
[=] Checking for known tags...
[=]
 🕐 Searching for MOTOROLA tag...
[-] ⛔ No data found!
[=] Signal looks like noise. Maybe not an LF tag?

 🕖  Searching for ISO14443-A tag...
[+]  UID: 2B 1E A4 00
[+] ATQA: 00 04
[+]  SAK: 08 [2]
[+] Possible types:
[+]    MIFARE Classic 1K
[=] proprietary non iso14443-4 card found, RATS not supported
[+] Prng detection: weak

[+] Valid ISO14443-A tag found
```

尝试使用pm3抓包

```bash
[usb] pm3 --> hf 14a list
[=] downloading tracelog data from device
[+] Recorded activity (trace len = 968 bytes)
[=] start = start of start frame end = end of frame. src = source of transfer
[=] ISO14443A - all times are in carrier periods (1/13.56MHz)

      Start |        End | Src | Data (! denotes parity error)                                           | CRC | Annotation
------------+------------+-----+-------------------------------------------------------------------------+-----+--------------------
          0 |       1056 | Rdr |26(7)                                                                    |     | REQA
     542080 |     543136 | Rdr |26(7)                                                                    |     | REQA
    1084800 |    1085856 | Rdr |26(7)                                                                    |     | REQA
    1627888 |    1628944 | Rdr |26(7)                                                                    |     | REQA
    2191344 |    2192400 | Rdr |26(7)                                                                    |     | REQA
    2193588 |    2195956 | Tag |04  00                                                                   |     |
    2742368 |    2743424 | Rdr |26(7)                                                                    |     | REQA
    3496928 |    3497984 | Rdr |26(7)                                                                    |     | REQA
    3499556 |    3501540 | Tag |00! 20                                                                   |     |
    4092816 |    4093872 | Rdr |26(7)                                                                    |     | REQA
    4653840 |    4654896 | Rdr |26(7)                                                                    |     | REQA
    4656468 |    4658452 | Tag |00! 20                                                                   |     |
    5382336 |    5383392 | Rdr |26(7)                                                                    |     | REQA
    6010160 |    6011216 | Rdr |26(7)                                                                    |     | REQA
    6012420 |    6014788 | Tag |04  00                                                                   |     |
    6219568 |    6222032 | Rdr |93  20                                                                   |     | ANTICOLL
    6223204 |    6229092 | Tag |2b  1e  a4  00  91                                                       |     |
    6476576 |    6487104 | Rdr |93  70  2b  1e  a4  00  91  b4  7a                                       |  ok | SELECT_UID
    6488292 |    6491812 | Tag |08  b6  dd                                                               |     |
    6639760 |    6644528 | Rdr |e0  21  b2  c7                                                           |  ok | RATS
    6645716 |    6646356 | Tag |04(4)                                                                    |     |
    6802704 |    6807472 | Rdr |50  00  57  cd                                                           |  ok | HALT
    7134096 |    7135088 | Rdr |52(7)                                                                    |     | WUPA
    7136324 |    7138692 | Tag |04  00                                                                   |     |
    7341696 |    7344160 | Rdr |93  20                                                                   |     | ANTICOLL
    7345348 |    7351236 | Tag |2b  1e  a4  00  91                                                       |     |
    7577584 |    7588112 | Rdr |93  70  2b  1e  a4  00  91  b4  7a                                       |  ok | SELECT_UID
    7589300 |    7592820 | Tag |08  b6  dd                                                               |     |
    7758832 |    7763600 | Rdr |e0  21  b2  c7                                                           |  ok | RATS
    7764772 |    7765412 | Tag |04(4)                                                                    |     |
    7963360 |    7968128 | Rdr |50  00  57  cd                                                           |  ok | HALT
    8568288 |    8569344 | Rdr |26(7)                                                                    |     | REQA
    8570516 |    8572884 | Tag |04  00                                                                   |     |
    8883152 |    8885616 | Rdr |93  20                                                                   |     | ANTICOLL
    8886804 |    8892692 | Tag |2b  1e  a4  00  91                                                       |     |
    9119296 |    9129824 | Rdr |93  70  2b  1e  a4  00  91  b4  7a                                       |  ok | SELECT_UID
    9131012 |    9134532 | Tag |08  b6  dd                                                               |     |
    9879984 |    9881040 | Rdr |26(7)                                                                    |     | REQA
   10464944 |   10466000 | Rdr |26(7)                                                                    |     | REQA
   10467188 |   10469556 | Tag |04  00                                                                   |     |
   10752928 |   10755392 | Rdr |93  20                                                                   |     | ANTICOLL
   10756580 |   10762468 | Tag |2b  1e  a4  00  91                                                       |     |
   10989712 |   11000240 | Rdr |93  70  2b  1e  a4  00  91  b4  7a                                       |  ok | SELECT_UID
   11001428 |   11004948 | Tag |08  b6  dd                                                               |     |
   11618176 |   11619232 | Rdr |26(7)                                                                    |     | REQA
   12238448 |   12239504 | Rdr |26(7)                                                                    |     | REQA
   12240692 |   12243060 | Tag |04  00                                                                   |     |
   12439152 |   12441616 | Rdr |93  20                                                                   |     | ANTICOLL
   12442804 |   12448692 | Tag |2b  1e  a4  00  91                                                       |     |
   12675040 |   12685568 | Rdr |93  70  2b  1e  a4  00  91  b4  7a                                       |  ok | SELECT_UID
   12686756 |   12690276 | Tag |08  b6  dd                                                               |     |
   13314256 |   13315312 | Rdr |26(7)                                                                    |     | REQA
   13831760 |   13832816 | Rdr |26(7)                                                                    |     | REQA
   13833988 |   13836356 | Tag |04  00                                                                   |     |
   14033728 |   14036192 | Rdr |93  20                                                                   |     | ANTICOLL
   14037380 |   14043268 | Tag |2b  1e  a4  00  91                                                       |     |
   14260912 |   14271440 | Rdr |93  70  2b  1e  a4  00  91  b4  7a                                       |  ok | SELECT_UID
   14272628 |   14276148 | Tag |08  b6  dd                                                               |     |
   14781088 |   14782144 | Rdr |26(7)                                                                    |     | REQA
   15322656 |   15323712 | Rdr |26(7)                                                                    |     | REQA
   15324900 |   15327268 | Tag |04  00                                                                   |     |
   15517584 |   15520048 | Rdr |93  20                                                                   |     | ANTICOLL
   15521236 |   15527124 | Tag |2b  1e  a4  00  91                                                       |     |
   15741712 |   15752240 | Rdr |93  70  2b  1e  a4  00  91  b4  7a                                       |  ok | SELECT_UID
   15753412 |   15756932 | Tag |08  b6  dd                                                               |     |
   16271872 |   16272928 | Rdr |26(7)                                                                    |     | REQA
   16832128 |   16833184 | Rdr |26(7)                                                                    |     | REQA
   16834356 |   16836724 | Tag |04  00                                                                   |     |
   17026928 |   17029392 | Rdr |93  20                                                                   |     | ANTICOLL
   17030580 |   17036468 | Tag |2b  1e  a4  00  91                                                       |     |
   17249376 |   17259904 | Rdr |93  70  2b  1e  a4  00  91  b4  7a                                       |  ok | SELECT_UID
   17261092 |   17264612 | Tag |08  b6  dd                                                               |     |
   17905104 |   17906160 | Rdr |26(7)                                                                    |     | REQA
   18469824 |   18470880 | Rdr |26(7)                                                                    |     | REQA
   18472068 |   18474436 | Tag |04  00                                                                   |     |
   18664768 |   18667232 | Rdr |93  20                                                                   |     | ANTICOLL
   18668420 |   18674308 | Tag |2b  1e  a4  00  91                                                       |     |
   18887472 |   18898000 | Rdr |93  70  2b  1e  a4  00  91  b4  7a                                       |  ok | SELECT_UID
   18899188 |   18902708 | Tag |08  b6  dd                                                               |     |
   19530016 |   19531072 | Rdr |26(7)                                                                    |     | REQA
```

