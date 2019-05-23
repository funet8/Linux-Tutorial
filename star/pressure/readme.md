# ab是压力测试工具

ab是apache自带的一个很好用的压力测试工具，当安装完apache的时候，就可以在bin下面找到ab
吞吐率：单位时间内服务器处理的请求数，通常使用 "reqs/s" (服务器每秒处理请求的数量)表示

ab工具的参数比较多，常用的有以下几个：
```
-n:表示测试请求总数,默认执行一个请求
-c:要创建的并发用户数,默认创建一个用户
-t:等待Web服务器相应的最大时间（单位：秒），默认没有时间限制
-k:使用Keep-Alive 特性
```

![结果显示](%E7%BB%93%E6%9E%9C%E6%98%BE%E7%A4%BA.gif)


(一) 在windows 执行一次压力测试
```
C:\Documents and Settings\Administrator>ab -c10 -n 1000 http://localhost/abtest.php

This is ApacheBench, Version 2.3 <$Revision: 655654 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests
```


Server Software:        Apache/2.2.22 #表示被测试的Web服务器软件名称
Server Hostname:        localhost	#表示请求的URL主机名
Server Port:            80	#表示被测试的Web服务器软件的监听端口

Document Path:          /abtest.php #表示请求的URL中的根绝对路径，通过该文件的后缀名，我们一般可以了解该请求的类型
Document Length:        698 bytes #表示HTTP响应数据的正文长度

Concurrency Level:      10 #表示并发用户数，这是我们设置的参数之一，即-c参数中的指定
Time taken for tests:   0.563 seconds #表示所有这些请求被处理完成所花费的总时间
Complete requests:      1000	#表示总请求数量，这是我们设置的参数之一
Failed requests:        1	#表示失败的请求数量，这里的失败是指请求在连接服务器、发送数据等环节发生异常，以及无响应后超时的情况。如果接收到的HTTP响应数据的头信息中含有2XX以外的状态码，则会在测试结果中显示另一个名为       “Non-2xx responses”的统计项，用于统计这部分请求数，这些请求并不算在失败的请求中。
   (Connect: 1, Receive: 0, Length: 0, Exceptions: 0)
Write errors:           0
Total transferred:      887000 bytes # 表示所有请求的响应数据长度总和，包括每个HTTP响应数据的头信息和正文数据的长度。注意这里不包括HTTP请求数据的长度，仅仅为web服务器流向用户PC的应用层数据总长度。
HTML transferred:       698000 bytes	# 表示所有请求的响应数据中正文数据的总和，也就是减去了Total transferred中HTTP响应数据中的头信息的长度
Requests per second:    1777.78 [#/sec] (mean)	# 吞吐率，计算公式：Complete requests / Time taken for tests 
Time per request:       5.625 [ms] (mean) # 用户平均请求等待时间，计算公式：Time token for tests/（Complete requests/Concurrency Level） 如果加大并发用户的数量这个等待时间相应会加长
Time per request:       0.563 [ms] (mean, across all concurrent requests) # 服务器平均请求等待时间，计算公式：Time taken for tests/Complete requests，正好是吞吐率的倒数。也可以这么统计：Time per request/Concurrency Level
Transfer rate:          1539.93 [Kbytes/sec] received	# 表示这些请求在单位时间内从服务器获取的数据长度，计算公式：Total trnasferred/ Time taken for tests，这个统计很好的说明服务器的处理能力达到极限时，其出口宽带的需求量。

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   1.2      0      16
Processing:     0    5   7.4      0      16
Waiting:        0    5   7.4      0      16
Total:          0    6   7.5      0      16

Percentage of the requests served within a certain time (ms)	# 这部分数据用于描述每个请求处理时间的分布情况，比如以上测试，80%的请求处理时间都不超过6ms，这个处理时间是指前面的Time per request，即对于单个用户而言，平均每个请求的处理时间。
  50%      0
  66%     16
  75%     16
  80%     16
  90%     16
  95%     16
  98%     16
  99%     16
 100%     16 (longest request)
 
 (二) 使用长连接的一次测试

```
C:\Documents and Settings\Administrator>ab -c10 -n 1000 -k http://localhost/abte
st.php
This is ApacheBench, Version 2.3 <$Revision: 655654 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        Apache/2.2.22
Server Hostname:        localhost
Server Port:            80

Document Path:          /abtest.php
Document Length:        698 bytes

Concurrency Level:      10
Time taken for tests:   0.391 seconds  # 使用长连接时间明显变短
Complete requests:      1000
Failed requests:        0
Write errors:           0
Keep-Alive requests:    995   # 长连接时间
Total transferred:      922782 bytes
HTML transferred:       698000 bytes
Requests per second:    2560.00 [#/sec] (mean) # 吞吐量明显变大
Time per request:       3.906 [ms] (mean)
Time per request:       0.391 [ms] (mean, across all concurrent requests)
Transfer rate:          2306.95 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:     0    4   7.2      0      47
Waiting:        0    4   7.2      0      47
Total:          0    4   7.2      0      47

Percentage of the requests served within a certain time (ms)
  50%      0
  66%      0
  75%      0
  80%     16
  90%     16
  95%     16
  98%     16
  99%     16
 100%     47 (longest request)
```

 
 
 
一般访问网站静态文件或页面多的时候开启Keep-Alive ，动态页面多则关闭

