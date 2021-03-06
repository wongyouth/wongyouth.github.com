---
layout: post
title: "使用Chef来自动化部署"
date: 2013-11-22 23:55
comments: true
categories: Ruby
tags: [Ruby, Chef, 运维]
topic: 技术
---

本篇主要分享一下如何使用Chef进行快速部署一个应用到服务器。
为了讲解的需要这里做了一些假定。

* 使用Vagrant作为一个测试服务器
* 使用Rails开发了一个应用
* 该应用使用了一台Postgresql数据库服务器
* 该应用有一台memcached用来做缓存服务
* 该应用使用Nginx作为Web服务器

<!--more-->

先来说一下Vagrant是什么？Vagrant可以看做是一个接口，是他Vagrant提供的接口可以方便的操作VirtualBox虚拟机。
VirtualBox虚拟机是一个免费的支持Windows, Linux, Mac 的全平台虚拟机。VirtualBox的使用场景多种多样。
在这里我们可以用来当做一台干净的测试机。

# 准备Vagrant环境

首先从各自官网安装软件

* [Install VirtualBox](http://www.virtualbox.org/)
* [Install Vagrant](http://www.vagrantup.com/)

## Vargrant file

配置一个Vagrantfile，这里我指定使用Ubuntu12.04 64位系统，该文件将会从网上自动下载。

{% include_code lang:ruby "Vagrantfile" %}

## Vagrant常用命令

    vagrant up # 启动Vagrant的虚拟机
    vagrant suspend # 休眠虚拟机，可以快速恢复
    vagrant resume # 恢复虚拟机，可快速恢复到休眠前状态
    vagrant halt # 关闭虚拟机电源。不使用额外空间保存状态，但是启动时间延长

    # 增加Vagrant虚拟机的信息到SSH配置里
    vagrant ssh-config --host chef_rails >> ~/.ssh/config

# 使用Chef

Chef是一个功能强大的自动花部署工具，facebook的大公司也都在用它，官方的Chef是需要有个Chef Server来存放
所有服务器信息，当Chef Client需要部署一台机器时会询问Chef Server服务器该台机器的信息。商用许可证自然价格不菲。
社区里面开发了一个单机版的 Chef Solo，无需服务器配合，所有配置信息全部存放在一起，基本也能很好地满足普通的需求了。
Chef使用ruby代码编写脚本，接口设计花了很多功夫，让不知道ruby的人也能方便使用。毕竟Chef的目标用户是服务器管理员不是程序员。

## Chef的常用命令

使用 Chef 时还有一些相应地工具需要来熟悉一下，清楚他们各自的作用。

* Berkshelf，脚本包管理工具，用来分享使用别人写好的脚本
* Knife，一个远程工具，使用他我们无需登录到目标服务器即可完成所有操作
* Chef，实际的部署工具

来看看各个工具的实际使用情况

    # berkshelf包管理工具，类似GemBundler
    gem install berkshelf
    berks install # 安装 chef 包

    # knife solo 是 knife 的solo版本，可以生成项目，上传项目文件到目标机器，远程执行部署命令
    gem install knife-solo

    # 生成一个部署项目
    knife solo init chef-rails

## 以下摘录一段chef片段

{% include_code 'chef_rails.json' %}

In this example above, we install `build-essential`, `git`, `rbenv`, and setup ruby 2.0.0-p353 as the default ruby version.

## 一个完成可用的例子

`chef-rails` 是我写好的一个配置rails项目的工具，能够自动配置nginx, postgresql, memcached, ruby, rails

    git clone https://github.com/wongyouth/chef-rails
    cd chef-rails
    bundle

    # install chef on target server
    knife solo bootstrap vagrant@chef_rails # 假设安装到之前设置好的Vagrant虚拟机服务器上

最后一步比较慢，可以华丽的起身喝一杯咖啡了。

P.S. 最近网络不太好，可能有些文件被墙掉下载很慢需要多次尝试。

参考

* https://github.com/wongyouth/chef-rails
* https://github.com/ouyangzhiping/railsbox-example
* http://ruby-china.org/topics/13211
