---
layout: post
title: "Ubuntu环境下在Rails项目中使用postgresql时的初始配置"
date: 2012-06-25 14:28
comments: true
categories: [Database, Rails, Server]
tags: [DB, Postgresql, Server, 运维]
---

在我们的rails服务器配置中经常用的是 MySQL，
今天使用开源社区的另一款数据库软件 postgresql 来做一个实验。

测试环境： ubuntu 12.04

<!-- more -->

安装与配置postgresql数据库。
    # 安装 postgresql 和开发库（pg.gem使用）
    sudo apt-get install postgresql libpq-dev

    # 修改配置文件使TCP/IP来的链接可用

    # /etc/postgresql/9.1/main/postgresql.conf 文件中去掉以下行开头的 `#'
    # listen_addresses = 'localhost'

    # 重启 postgresql
    sudo /etc/init.d/postgresql restart

生成rails里面使用的postgrelsql的帐号密码，这里我们用MySQL的帐号root。
    # 创建root帐号
    # -d 可以创建数据库
    # -R 不可以创建角色
    # -S 不是超级用户
    sudo -u postgres createuser -d -R -S root

postgres 是 postgresql 的超级帐号，使用他就可以做任何事了，包括找回密码哦，因为默认配置是不需要输入密码的。

    # 修改root帐号密码
    echo "alter role root password 'root';" | sudo -u postgres psql

    # 测试帐号登录
    psql -U root -h localhost template1
template1 是安装 postgresql 时自动生成的一个模板，这里为什么要指定 template1 是因为不指定一个操作对象时会报错。


配置rails程序，使其使用postgresql

    gem pg

config/database.yml

    adapter: postgresql
    host: localhost
    database: xxx_development
    username: root
    password: root
    encoding: utf8
    pool: 5

生成数据库启动rails

    rake db:create
    rails server

后面的操作就与MySQL时是一样的啦。
