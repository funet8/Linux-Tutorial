# Centos6.5 使用mail配合smtp发送邮件

安装
```
#  yum -y install mailx
# yum -y install sendmail
# /etc/init.d/sendmail start
# chkconfig sendmail on
```



去163邮箱打开SMPT服务，并且获取授权密码

```
# vi /etc/mail.rc
在底部添加：
set from="xxx@163.com"
set smtp=smtp.163.com
set smtp-auth-user=xxx@163.com
set smtp-auth-password=自己填写的授权码
set smtp-auth=login
```




测试发送：
```
echo -e "你好！n我来看看你n哈哈" | mail -s "测试邮件" xxx@163.com

echo -e "你好！n我来看看你n哈哈" | mail -s "测试邮件" funet8@163.com

mail  -s "`date +%F-%T`" funet8@163.com </tmp/messages.txt
```




[Centos6.5 使用mail配合smtp发送邮件](https://segmentfault.com/a/1190000007650386)

