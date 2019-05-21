Centos7安装gitlab，rpm安装

## 系统介绍
官方强烈建议至少4 gb的空闲内存GitLab运行，虚拟机只有2G，测试一下是否可以安装
```
IP地址：192.168.0.4
内存：2G
系统：centos7（Linux node4 3.10.0-957.1.3.el7.x86_64 #1 SMP Thu Nov 29 14:49:43 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux）
```
### 1.安装依赖关系
```
yum install -y curl policycoreutils-python openssh-server
systemctl enable sshd
systemctl start sshd

firewall-cmd --permanent --add-service=http
systemctl reload firewalld


```
### 2.安装postfix邮件通知作用,此步可跳过

```
yum install postfix
systemctl enable postfix
systemctl start postfix
```
### 3.添加GitLab包存储库和安装包
```
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash

```
接下来,安装GitLab包。改变“http://gitlab.example.com”的URL你想访问你GitLab实例。安装将自动配置和启动GitLab URL。HTTPS需要额外的配置安装。

```
EXTERNAL_URL="http://gitlab.tools.7477.me" yum install -y gitlab-ee
```
### 通过浏览器登录gitlab
```
在你的第一次访问,将重置root密码
在这里设置root
密码为12345678
```

官方参考网址：
https://about.gitlab.com/install/#centos-7
