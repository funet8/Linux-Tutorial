#!/bin/bash
############################################################
#名字：	centos_samba.sh
#功能：	centos6或者7安装samba文件共享
#作者：	star
#邮件：	star@funet8.com
#时间：      2019/05/24
#Version 1.0
#20190524修改记录：
#脚本初始化
###########################################################

#共享路径和密码
Path="/data/smb"
#共享密码
SmbUser="smb"
SmbPassward="7477"

yum install -y samba samba-client

function SYSTEM6(){
		chkconfig smb on   
		chkconfig nmb on
		/etc/init.d/smb start
}
function SYSTEM7(){
	systemctl enable smb.service
	systemctl enable nmb.service
	systemctl start smb
}
#新建smb用户用于访问Linux共享文件
useradd $SmbUser
#smbpasswd -a $SmbUser
echo "$SmbPassward" | passwd $SmbUser --stdin > /dev/null 2>&1

mkdir -p $Path
chown $SmbUser.$SmbUser -R /data/smb

cp /etc/samba/smb.conf /etc/samba/smb.conf_bak
echo "[global]
        workgroup = MYGROUP
        server string = Samba Server Version %v
        log file = /var/log/samba/log.%m
        # max 50KB per log file, then rotate
        max log size = 50
        security = user
        passdb backend = tdbsam
[smb share]
comment = jishubu Directories
path = $Path
public = no
writeable = yes
browseable = yes
valid users = $SmbUser
">/etc/samba/smb.conf

#防火墙
iptables -A INPUT -p tcp --dport 139 -j ACCEPT
iptables -A INPUT -p tcp --dport 445 -j ACCEPT
iptables -A INPUT -p tcp --dport 137 -j ACCEPT
iptables -A INPUT -p tcp --dport 138 -j ACCEPT

service iptables save
systemctl restart iptables.service
service iptables restart

######################################################################
#检查centos版本，并且执行相关函数
version6=`more /etc/redhat-release |awk '{print substr($3,1,1)}'`
if [ $version6 = 6 ];then
	echo "System is CentOS 6 !"
	SYSTEM6	
	service smb restart
fi 
version7=`more /etc/redhat-release |awk '{print substr($4,1,1)}'`
if [ $version7 = 7 ];then
	echo "System is CentOS 7 !"
	SYSTEM7
	systemctl restart smb
fi