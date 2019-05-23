#!/usr/bin/python
# -*- coding: utf-8 -*-
from fabric.api import *
from fabric.colors import *

env.user ="root"
env.password = "liuxing"
env.port = "61920"
env.hosts =['192.168.1.3','192.168.1.4']

@runs_once      
#多台主机只执行一次
def remote_task():
        with cd("/var/log/"):
             run("ls -lF |grep /$")