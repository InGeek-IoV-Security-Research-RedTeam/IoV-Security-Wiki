find命令排除文件夹

```bash
# Android排除proc文件夹
# -path ./proc 找到proc 为真
# -a -prune 排除 -a表示and，数学上and的话都需要为真，所以计算-prune
# -o **** 表示or，数学上or的话，前面为真就会发生短路，不计算后面，因为or的话只要一个为真就返回真
#  如果前面匹配到假，即没有发现proc文件夹，就计算后面
# -print数据输出
$ find ./ -path ./proc -a -prune -o -type f -iname *.pem -print
# 排除多个文件使用括号
$ find ./ \( -path ./proc -o -path ./sys \) -a -prune -o -type f -iname *.pem -print
```

find命令寻找特殊权限文件

```bash
# 完全匹配
$ find ./ -perm 0677 -type f 
# 模糊匹配
$ find ./ -perm -0677 -type f
```

