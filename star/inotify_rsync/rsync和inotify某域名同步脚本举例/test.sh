#!/bin/sh
SRC=/data/wwwroot/web/test_tongbu/ #代码发布服务器目录
DST=/data/wwwroot/web/test_tongbu/ #目标服务器目录
IP="192.168.1.244"    #目标服务器IP，多个以空格隔开
#IP="192.168.20.7 192.168.20.3"    #目标服务器IP，多个以空格隔开
USER=www
INOTIFY_EXCLUDE="--fromfile /data/conf/shell/inotify_rsync/test_inotify_exclude.list"
RSYNC_EXCLUDE="--include-from=/data/conf/shell/inotify_rsync/test_rsync_include.list --exclude-from=/data/conf/shell/inotify_rsync/test_rsync_exclude.list"

#test_inotify_exclude.list	【监控和忽略监控】
#test_rsync_include.list	【同步文件夹列表】		
#test_rsync_exclude.list	【不同步文件夹列表】		

#su - $USER
inotifywait -mrq --exclude "(.swp|.inc|.svn|.rar|.tar.gz|.gz|.txt|.zip|.bak)" -e delete,create,close_write,attrib $INOTIFY_EXCLUDE | while read D E F  
	do  
		for i in $IP
		do
			/usr/bin/rsync -e 'ssh -p 22' -ahqzt $RSYNC_EXCLUDE --delete $SRC $USER@$i:$DST
			# echo "/usr/bin/rsync -e 'ssh -p 60920' -ahqzt $RSYNC_EXCLUDE --delete $SRC $USER@$i:$DST";
			# echo "Done---\n";
		done		
	done
