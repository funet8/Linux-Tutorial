#!/bin/bash

#################
##重启svn
## svnadmin create /home/svn/kmreader_iOS
## 新增账号：cd ./conf  修改 vi  svnserve.conf 和vi authz
#
# svnadmin create /home/svn/XiaoHuaLaiLe_iOS

# vi  /home/svn/XiaoHuaLaiLe_iOS/conf/svnserve.conf
#修改以下参数
#anon-access =  none    #read改为none
#auth-access = write
#password-db = passwd
#authz-db = authz
# 
#realm = XiaoHuaLaiLe_iOS            #改成版本库名字

#修改authz 文件，创建svn组和组用户的权限
#vi  /home/svn/XiaoHuaLaiLe_iOS/conf/authz
# 添加：
#[groups]
#program = liuhui,chenyihai
#[/]
#@program = rw
#* = r

#修改密码
#vi  /home/svn/XiaoHuaLaiLe_iOS/conf/passwd
# chenyihai = chenyihai7477
# liuhui = yxkj7477

################


killall svnserve
svnserve -d -r /home/svn

echo "svn RESTART Done"

