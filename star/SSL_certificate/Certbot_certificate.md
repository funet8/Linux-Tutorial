# 使用Certbot获取免费泛域名(通配符)证书

## 泛域名证书

```
# git clone https://github.com/certbot/certbot
# cd certbot
# certbot certonly --preferred-challenges dns --manual  -d *.funet8.com --server https://acme-v02.api.letsencrypt.org/directory
```

讲解下参数:

*   --preferred-challenges dns: 认证方式选择DNS, 泛域名支持DNS
*   --manual: 手动模式, 这里为了简单就使用手动认证了, 下面会说自动模式的使用.
*   -d *.funet8.com: 就是要申请的泛域名了
*   --server [https://acme-v02.api.letsencrypt.org/directory](https://acme-v02.api.letsencrypt.org/directory): 泛域名证书是新功能, 如果要使用就得加上这个参数

注意这一步需要手动配置TXT记录, 在域名解析服务商添加一个泛解析就可以了, 设置好了再敲下回车.

最后就会将生成好的证书保存到本地.




参考： https://www.jianshu.com/p/1eb7060c5ede