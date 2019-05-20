---
style: summer
---
# star_centos6安装postfix

## 说说在64位CentOS下安装Postfix+Dovecot 配置邮件服务器过程。
Postfix 和Dovecot功能确实很强大，支持各种认证方式， 配置非常灵活， 就因为太过于灵活， 反而安装配置的过程中，容易有各种各样的陷阱，碰到问题了， 日志是最好的解决办法了。我们假设你申请的域名是 funet8.com 

### 设置域名解析

第一个是 ：A记录，  RR值为 @ ,    指向 服务器的IP地址
第二个是：MX记录， RR值为@， 指向 funet8.com
第三个是：A记录，RR值为 www， 指向服务器的IP地址
配置完毕后，  ping    www.funet8.com  如果能提示出你的服务器的IP地址， 证明 www的配置已经生效。
下来还要检查 MX 记录是否生效， 要用nslookup检查一下是否MX记录正确。
在windows系统的命令行输入 ：  nslookup    -qt=mx    funet8.com   回车后，
能显示你的域名    funet8.com  ， 就代表你的 MX记录配置正确。
如果MX记录配置不正确， 那用QQ邮箱发邮件， 你就会收到个退信， 退信原因的内容如下 ：
收件人（zhang@funet8.com）所属域名不存在，邮件无法送达。
Name service error for name=funet8.com type=MX: Host found but no data record of requested type
我没有下载源码进行安装，直接用yum进行的。

```
yum    install    postfix
yum    install    dovecot
yum    install    cyrus-sals
```
###  修改配置
1.第一个是 ：postfix 的配置文件    /etc/postfix/main.cf ，  需要修改的内容如下所示，其他的用默认即可。

```
vi /etc/postfix/main.cf

修改一下配置
myhostname = mail.funet8.com
mydomain = funet8.com
myorigin = $mydomain
inet_interfaces = all
inet_protocols = all
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
mynetworks = 0.0.0.0/0
home_mailbox = Maildir/
smtpd_sender_restrictions = permit_mynetworks,  permit_sasl_authenticated,  reject_sender_login_mismatch, reject_authenticated_sender_login_mismatch, reject_unauthenticated_sender_login_mismatch 
smtpd_sasl_auth_enable = yes
smtpd_sender_login_maps = hash:/etc/postfix/sender_login_maps
```
2.第二个是：dovecot的配置文件  /etc/dovecot/dovecot.conf，需要修改的内容如下所示，其他的默认即可。
```
vi /etc/dovecot/dovecot.conf
修改以下配置：
protocols = imap pop3 lmtp imaps pop3s
ssl_disable = no
mail_location = Maildir:~/Maildir
disable_plaintext_auth = no
```
dovecot.conf 配置好以后，如果直接启动    service  dovecot  start，  会提示警告 ：

Aug 14 17:55:54 master: Warning: Killed with signal 15 (by pid=12829 uid=0 code=kill)
Aug 14 17:55:55 config: Warning: NOTE: You can get a new clean config file with: doveconf -n > dovecot-new.conf
Aug 14 17:55:55 config: Warning: Obsolete setting in /etc/dovecot/dovecot.conf:81: login_user has been replaced by service { user }
Aug 14 17:55:55 config: Warning: Obsolete setting in /etc/dovecot/dovecot.conf:88: add auth_ prefix to all settings inside auth {} and remove the auth {} section completely

这时我们需要在    /etc/dovecot/目录下面执行  ：

```
cd /etc/dovecot/
doveconf -n > dovecot-new.conf
```
该命令会把  dovecot.conf  转化为标准格式的配置文件 。 我们用新生成的文件  dovecot-new.conf 替换掉 dovecont.conf 即可。

在配置的过程中， 还有一些细节需要注意 ：

那就是设置 默认的 MTA，  卸载掉  sendmail ， 把MTA设置为 postfix，  设置开机自动启动  postfix  和  dovecot。

然后用 useradd  命令添加一个用户  zhang ， 密码设置为  123456

启动服务：
```
service    postfix    restart
service    dovecot    restart
service    saslauthd  restart
```
下来配置  outlook，  填写 电子邮件地址为 ： zhang@funet8.com

账号类型选择  POP3，  接收邮件服务器为    funet8.com，  发送邮件服务器也为  funet8.com

然后用户名为    zhang，  密码为  123456

不出意外的话，  应该可以正常收发邮件了。

新邮件会保存在服务器的    /home/zhang/Maildir/new    这个目录里。

我这个配置比较简单， 是用的服务器本身的密码验证机制。  postfix 很强大， 可以支持多种认证方式和其他的加密方式。

本来想用  postfixadmin 进行web管理的，  但是那个配置起来就要更复杂一些了，  通过web的方式添加用户后， 需要在  home 目录创建对应的用户名的文件夹来保存邮件， 有相关的脚本需要执行，另外认证模式得修改为mysql认证， 配置 稍微复杂， 等下一篇文章在写 postfixadmin 相关的东西吧。

**Postfix 日志 connect from unknown错误**

配置postfix， 提示如下错误：

postfix/smtpd[29233]: connect from unknown[58.38.183.244]

解决办法：

关键是postfix配置文件main.cf 里的mynetworks， 修改为如下所有网段都通过就可以了。

mynetworks = 0.0.0.0/0



