---
layout: post
title: "Ubuntu下安装ruby开发环境"
date: 2012-04-21 14:41
comments: true
categories: [ruby, ubuntu]
published: true
---

开始的时候我也是用Windows作为Rails项目开发的。
但是在Windows下会碰到各种各样的问题，最常见的就是Gem包可能只工作在类Unix的环境下。
有的时候按照官方说明一步一步做仍然有各种各样的不成功。痛定思痛用Ubuntu做为开发环境。

使用Ubuntu有个好处，每天跟Ubuntu打交道会提高整体的服务器排错水平，因为每天用的就是服务器一样的环境，遇到问题每天都要去解决，久而久之水平也就上去了。

闲话休提。让我们看看如何设置ruby环境吧。

1. 预安装库文件
2. 安装`rbenv`
3. 安装`ruby`
4. 创建第一个`Rails`项目

## 预安装库文件

#### 预安装一些编译时用到的库文件和工具

```sh
    sudo apt-get -y install git-core curl \
    build-essential openssl libreadline6 libreadline6-dev \
    libmysqlclient-dev zlib1g zlib1g-dev libssl-dev libyaml-dev \
    libsqlite3-0 libsqlite3-dev sqlite3 \
    libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake \
    libtool bison subversion libxslt1-dev
```

如果使用jruby的话，安装一个jdk环境
    sudo apt-get install default-jdk

## 安装`rbenv` 

我使用[rbenv]而不是rvm来作为ruby的版本管理软件。理由在rbenv的项目页面说明的很清楚了，更安全也更简单

[rbenv-installer]: https://github.com/fesplugas/rbenv-installer
[rbenv]: https://github.com/sstephenson/rbenv

```sh
    curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
```

## 安装`ruby`

假设你使用ruby-1.9.3

```sh
    rbenv install 1.9.3-p125
    rbenv global 1.9.3-p125
```

常用rbenv命令

```sh
    rbenv versions # 查看可以安装的ruby版本列表
    rbenv version  # 查看当前的ruby版本
    rbenv rehash   # 更新rbenv里的链接指向gems的可执行文件的映射,安装了新gem包时使用

    rbenv global jruby-1.6.5         # 切换到jruby-1.6.5，下次登录系统后仍有效
    export RBENV_VERSION=jruby-1.6.5 # 切换到jruby-1.6.5环境，只适用于这一次使用
```


## 创建第一个`Rails`项目

```sh
    gem update --system       # 更新gem到最新版本
    gem install bundler rails # 安装bundler和rails
    rbenv rehash              # 刷新rbenv记录的可执行文件，这样rails命令就可以直接使用了
    rails new blog
```
