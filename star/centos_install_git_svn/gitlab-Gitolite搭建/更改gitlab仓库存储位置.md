更改仓库存储位置
默认时GitLab的仓库存储位置在“/var/opt/gitlab/git-data/repositories”，在实际生产环境中显然我们不会存储在这个位置，一般都会划分一个独立的分区来存储仓库的数据，我这里规划把数据存放在“/data/git-data”目录下。

```
# mkdir -pv /data/git-data 
```
更改参数
```
# vi /etc/gitlab/gitlab.rb 
#启用git_data_dirs参数，并修改如下： 

git_data_dirs  路径 "/data/git-data"

git_data_dirs({
   "default" => {
     "path" => "/data/git-data",
     "failure_count_threshold" => 10,
     "failure_wait_time" => 30,
     "failure_reset_time" => 1800,
     "failure_timeout" => 30
    }
 })
```

重新编译
```
gitlab-ctl reconfigure  #重新编译gitlab.rb文件，使用做的修改生效
gitlab-ctl restart

```



--------------------- 
作者：lifeneedyou 
来源：CSDN 
原文：https://blog.csdn.net/lifeneedyou/article/details/84923122 
版权声明：本文为博主原创文章，转载请附上博文链接！

