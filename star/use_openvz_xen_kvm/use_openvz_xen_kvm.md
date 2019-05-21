
# 判断虚拟机使用的是openvz、xen、kvm

```
wget http://people.redhat.com/~rjones/virt-what/files/virt-what-1.15.tar.gz
tar zxf virt-what-1.15.tar.gz
cd virt-what-1.15/
./configure
make && make install
```

检测
```
# virt-what
```


阿里云、腾讯云、AWS使用的是 kvm

参考地址：
https://yq.aliyun.com/articles/293602
