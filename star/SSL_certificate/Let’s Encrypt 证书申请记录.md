
# Let’s Encrypt 证书申请记录

对于国内用户来说，可以实用与百度云、腾讯云、阿里云合作的赛门铁克签署的证书，一年免费，申请和使用都很方便。

## Let’s Encrypt是什么？
免费、自动化、开放的证书签发服务

Let’s Encrypt的证书申请和续期都非常方便，默认的证书有效期是90天，通过cron的定时任务可以实现自动化的续期，所以，能通过自动的方式解决的问题都不是问题，这也是这次折腾起https支持的原因


## 第一步 获取Certbot

Certbot 是一个简单易用的 SSL 证书部署工具，由 EFF 开发，前身即 Let’s Encrypt 官方（Python）客户端。简单来说，certbot 就是一个简化 Let’s Encrypt 部署，和管理 Let’s Encrypt 证书的工具。certbot的开源项目在GitHub上，所以，我们的第一步，是clone certbot项目到本地：

```
git clone https://github.com/certbot/certbot
```

## 第二步 申请证书

现在，可以通过脚本来申请证书了，以我的域名为例：
域名需要解析到服务器中

```
cd certbot
./letsencrypt-auto certonly -d ssl.funet8.com
```

显示：选择
```
1: Spin up a temporary webserver (standalone)
2: Place files in webroot directory (webroot)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate number [1-2] then [enter] (press 'c' to cancel):  2 ##########选择

Enter email address (used for urgent renewal and security notices) (Enter 'c' to
cancel): funet8@163.com ##############填写邮箱


```

## 第三步 配置证书
申请好的证书，包含四个文件，默认会放在这里：
```
/etc/letsencrypt/live/www.funet8.com/fullchain.pem
/etc/letsencrypt/live/www.funet8.com/privkey.pem
/etc/letsencrypt/live/www.funet8.com/cert.pem  
/etc/letsencrypt/live/www.funet8.com/chain.pem
```
有了这些证书文件，我们就可以去配置我们的Nginx了，实际上，我们用两个证书文件就行了，一个是带私钥的文件，一个是带公钥的文件。拿我的Nginx配置文件举个栗子：

```
server {
        listen 80 default; #默认监听80的HTTP端口; 
        listen 443 ssl; #确保Nginx监听HTTPS的443端口

        # SSL证书配置
        ssl_certificate /etc/letsencrypt/live/www.funet8.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/www.funet8.com/privkey.pem;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;

        root /home/xiaozhou;
        index index.html index.htm;

        server_name funet8.com www.funet8.com;
}
```

配置好之后，直接用Nginx reload配置即可。

## 第五步 证书的验证

证书配置好了，我们就可以直接用浏览器通过https地址来访问和验证证书了，比如：https://www.funet8.com
我们会看到地址栏的前面有一把小锁，嗯，咱是有证书的人了!

## 第六步 证书的自动续期

最后一步，就是证书的自动续期了。Let’s Encrypt的证书，默认的有效期是90天，不过官方推荐每60天续期。到期之后，我们需要用命令来为证书续期，不过我们是懒人，这种体力活还是交给机器来完成比较合适。所以，我们可以用Linux的cron job来完成这类的任务，配置cron job，每两个月的第一天，执行下面的命令：
```
#minute hour day month day_of_week    command

0  0  1  */2  * /letsencrypt/certbot-auto renew --post-hook "systemctl reload nginx"

```

注意在cron job里面需要用绝对路径



为你的Blog快速开启https支持
https://xiaozhou.net/be-quick-to-enable-ssl-for-your-blog-2016-07-13.html


申请Let's Encrypt通配符HTTPS证书
https://my.oschina.net/kimver/blog/1634575#comment-list

Let’s Encrypt免费泛域名证书申请教程步骤
https://www.xxorg.com/archives/4870


