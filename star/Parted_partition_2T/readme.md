
# parted分区-分区超过2T的硬盘

fdisk工具他对分区是有大小限制的，它只能划分小于2T的磁盘。
超过2T的磁盘：
其一是通过卷管理来实现；
其二就是通过我们今天谈到的Parted工具来实现对GPT磁盘进行分区操作。

 #获取帮助
```
# parted --help 
```



本地服务器有一块4T的硬盘
```
# parted /dev/sda

# parted
GNU Parted 3.1
Using /dev/sda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted)    
```



 ## 安装 parted
```
# yum install -y parted 安装
```


```
parted -a optimal /dev/sda	#对硬盘sdb进行分区  
mklabel gpt					#使用GPT格式			
mkpart primary 1 -1			#建立一个主分区	
print						#显示分区信息
quit						#退出
mkfs.xfs /dev/sdb1			#格式化为xfs格式
echo "/dev/sdb1	/opt	xfs	defaults	0 0" >> /etc/fstab #加入自动挂载
mount -a					#挂载分区
df -h						#查看磁盘信息

umount /dev/sda
```





【centos 7 挂载大硬盘】
http://www.cnblogs.com/afxcn/p/5289876.html
http://blog.csdn.net/codemanship/article/details/47056673









