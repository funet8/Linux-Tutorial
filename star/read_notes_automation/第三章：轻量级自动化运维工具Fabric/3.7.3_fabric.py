#!/usr/bin/python
# -*- coding: utf-8 -*-
from fabric.api import *
from fabric.colors import *

env.user ="root"
env.password = "liuxing"
env.hosts =['192.168.1.6','192.168.1.9']

@runs_once      
#多台主机只执行一次
def local_task():
        local("hostname")
        print red ("hello,world!")

def remote_task():
        with cd("/var/log/"):
             run("ls -lF |grep /$")