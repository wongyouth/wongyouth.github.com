---
layout: post
title: "配置一个新的Ubuntu开发环境"
date: 2012-06-20 14:09
comments: true
categories: [ server ]
tags: [ubuntu, ruby, rbenv]
---

今天刚申请到[linode](http://linode.com)的`vps`主机，就迫不及待的安装了ubuntu，于是有要配置安装一大堆东西，
在这里给总结一下。

<!-- more -->

## 更新源
```sh
sudo apt-get update
```

## 安装系统包

```sh
sudo apt-get -y install git-core curl zsh exuberant-ctags vim autoconf automake openssl \
build-essential libc6-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev \
mysql-server libmysqlclient-dev libsqlite3-0 libsqlite3-dev sqlite3 \
ncurses-dev libtool bison libxslt1-dev libxml2-dev libqt4-dev
```

nokogiri.gem        need libxml2 libxml2-dev libxslt1-dev
mysql2.gem          need libmysqlclient-dev
capybara-webkit.gem need libqt4-dev


## 安装`oh-my-zsh`，如果你使用`bash`可以跳过此步骤

```sh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | bash
```

## 切换到`zsh`

```sh
chsh -s `which zsh`
```

## 配置主目录里面常用的dotfiles文件

```sh
git clone git://github.com/wongyouth/dotfiles ~/.dotfiles
cd ~/.dotfiles
rake install
```

## 设置`vim`文件，安装常用的`vim`插件

```sh
curl https://raw.github.com/wongyouth/vimfiles/master/install.sh | bash
```

## 安装`ruby`环境管理工具`rbenv`

```sh
curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
rbenv bootstrap-ubuntu-12-04
```

## 安装ruby1.9

```sh
rbenv install 1.9.3-p194
rbenv global 1.9.3-p194
```

##  更新`gem` 并安装 `bundler` `rake`

```sh
gem update --system
gem install bundler rake
```

## 更新`rbenv`的`shim`，使`rake`, `bundle`命令可以直接使用

```sh
rbenv rehash
```

