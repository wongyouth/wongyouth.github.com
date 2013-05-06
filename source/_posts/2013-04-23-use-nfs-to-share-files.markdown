---
layout: post
title: "use nfs to share files"
date: 2013-04-23 14:33
comments: true
categories: [server]
tags: [nfs]
---

当一个服务器不能负载的时候，就需要增加一个服务器来做负载均衡，这个时候就需要做文件共享。
这一次我们来看看如何在ubuntu12.04上用nfs来做文件共享

<!-- more -->

## 服务器端配置

Step 1. 安装nfs服务

    sudo apt-get install nfs-kernel-server

Step 2. 设置共享文件夹

    sudo mkdir -p /exports/files
    #sudo vi /etc/exports
    /exports/files *(rw,async,anonuid=1000,anongid=1000)

为什么要做一个映射，而不直接使用实际的文件夹，是因为不需要暴露太多的信息给客户端。
这里我们把默认的权限设置为uid为1000的用户帐号，这样如果客户端新加一个文件的时候就能自动设置文件所有者属性

Step 3. 映射共享文件夹到实际的文件夹

    # sudo vi /etc/fstab
    /path/to/files /exports/files none bind 0 0 # 这里的/path/to/files是实际你要共享的文件夹

Step 4. 启动服务

    sudo exportfs  -ra
    sudo service nfs-kernel-server restart

## 客户端配置

Step 1. 安装nfs客户端

    sudo apt-get install nfs-common

Step 2. 做文件映射

    sudo mkdir -p /data/files
    #sudo vi /etc/fstab
    server:/exports/files /data/files nfs proto=tcp,port=2049

在/etc/fstab写的好处是下次系统自启动后会自动加载该配置

    sudo mount /data/files

最后要说的是现在的配置是没有做安全设置的，还需要用防火墙做ip过滤，这个设置方法本片就略过了。

该篇博文参考： <https://help.ubuntu.com/community/SettingUpNFSHowTo>
