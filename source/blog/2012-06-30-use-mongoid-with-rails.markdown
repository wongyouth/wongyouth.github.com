---
layout: post
title: "在Rails中使用Mongoid"
date: 2012-06-30 12:54
comments: true
categories: [rails, database]
tags: [rails, mongodb, nosql, ubuntu]
---

在我看来noSQL解决方案有一个最大的优点就是可以方便的scale out, Oracle等大型数据库也可以支持Grid，支持集群但是就是配置起来的繁琐而已，可以写一本厚厚的书啦。而今天要使用的mongodb只是简单的一个配置文件就能搞定，简单易用容易让人理解，只就是生产力的极大提升啊。

<!-- more -->

Mongodb可使用的ruby adapter 常用的有Mongoid, Mongo Ruby Driver, Mongo mapper, 在这里不比较两者的异同，我们简单的用现在人气高的一个mongoid。人气值可以在看[这里][1]

## Step 1: Install Mongodb 2.0

目前Ubuntu官方库里的mongodb还没有升级到2.0版，我们用mongodb官方提供[步骤][2]来安装。

```sh
    # 添加mongodb公司10gen的pgp键
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10

    # 增加源到apt
    sudo sh -c "echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/10gen.list"

    # 更新源
    sudo apt-get update

    # 安装mongodb
    sudo apt-get install mongodb-10gen

    # 启动mongodb
    sudo service mongodb start

    # test mongo client
    mongo

    # db.test.save( {a: 1} )
    # db.test.find()
```

## Step 2: Setup Gemfile to install mongoid

在Gemfile中添加mongoid

    gem 'mongoid', '~> 3.0.0.rc'

执行
    bundle install

这样就可以使用了。在[railscasts][]中有mongoid的使用视频，我就不接着举例了。
虽然现在mongoid升级到了3.0rc，有些东西会有变化，但是大的变化不会太大。

mongoid的确是好东西，但是rails社区之前的插件基本都是为mysql特质的，所以很多好插件在mongoid下还不能用，
这个还需要社区在进一步的发展才能达到，重复造轮子代价太大，我们做迁移之前还是要考虑好这个现实问题的。


[1]: https://www.ruby-toolbox.com/categories/mongodb_clients
[2]: http://docs.mongodb.org/manual/tutorial/install-mongodb-on-debian-or-ubuntu-linux/
