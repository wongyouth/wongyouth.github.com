---
title: 与 Docker 一起使用 Rails
date: 2015-07-02 08:28 +0800
tags: ["Rails", "Docker"]
keywords: ["Rails", "服务器 Server", "部署 Deployment"]
topic: "技术"
---

最近 Docker 很火，好像只要是服务器端相关的东西都有要搬到 Docker 上的趋势，
似乎要把从开发，安装，部署，维护的问题全都要解决掉的那个意思。

按我的理解，Docker 架构在服务器之上，从服务器上多衍生出了一层，
所以可以跨平台运行在各个系统之上，达到一致的用户体验。
并且 Docker 可以快速导入一个定制好系统，
比如可以把开发人员的系统环境复制一份给测试人员使用，体验真的很好。

Docker 发展很快，但我觉得就目前的阶段还是不太适合商用环境，
毕竟真正商用时是多主机配合工作的，这点上 Docker 还有很大的空间需要完善。
作为一个开发，测试用环境或者小范围商用时是 Docker 的确带来了巨大的用户体验。

<!-- more -->

在这篇博文里简单记录下 Docker 如何与 Rails 一起配合使用。以下是在 Mac OSX 的环境里使用时为例。


## 安装

    brew install boot2docker

## 启动 Docker 环境

    boot2docker up

返回结果

    Waiting for VM and Docker daemon to start...
    .................ooooooo
    Started.
    Writing /Users/ryan/.boot2docker/certs/boot2docker-vm/ca.pem
    Writing /Users/ryan/.boot2docker/certs/boot2docker-vm/cert.pem
    Writing /Users/ryan/.boot2docker/certs/boot2docker-vm/key.pem

    To connect the Docker client to the Docker daemon, please set:
        export DOCKER_HOST=tcp://192.168.59.103:2376
        export DOCKER_CERT_PATH=/Users/ryan/.boot2docker/certs/boot2docker-vm
        export DOCKER_TLS_VERIFY=1


这个命令实际上时启动了一个 `Virtual Box` 虚拟机，跑了一个 Linux 内核的系统。
如果你是使用的是一个 Linux 内核的电脑，就可以少这一部分开销了。

## 设置系统变量给终端使用

复制上一步的返回结果到终端上执行。如果有多个终端需要使用时，每个都要设置这些系统变量

    export DOCKER_HOST=tcp://192.168.59.103:2376
    export DOCKER_CERT_PATH=/Users/ryan/.boot2docker/certs/boot2docker-vm
    export DOCKER_TLS_VERIFY=1

## 创建一个 PostgreSQL 容器

    docker run --name my-postgres -e POSTGRES_PASSWORD=postgres -d postgres

这里把 postgres 的密码设为 postgres, 可以配合在 Rails app 厘米使用这个账号。

如果第一次执行该命令，Docker 会先从社区共享的 Image 里下载 postgres 最新的数据，
来创建 PostgreSQL 容器，所以需要花费几分钟时间。

    docker ps

返回结果

    CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                    NAMES
    139f96ea6d0e        postgres:latest     "/docker-entrypoint.   2 minutes ago       Up 2 minutes        5432/tcp                 my-postgres

## 生成 Rails 应用的 Docker Image

在终端进入 Rails 主目录，
修改 config/database.yml 文件里数据库的设置

    host: ENV['DB_PORT_5432_TCP_ADDR']
    username: postgres
    password: postgres

`DB_PORT_5432_TCP_ADDR` 这个环境变量是在 Docker 链接数据库容器到 Rails 应用容器时自动设置的，通过该地址可以找到数据库

生成 Dockerfile 文件，供 build 使用

    echo 'FROM rails:onbuild' > Dockerfile

执行 build 来生成 docker image

    docker build -t my-rails .


## 创建 Rails console 容器，用来执行 Rails 任务

    docker run --name my-bash --link my-postgres:db -v "$PWD":/usr/src/app -it my-rails /bin/bash

此时已经进入了 Docker 容器内的一个交互环境下，我们可以运行 Rails 命令来生成数据表结构

    rake db:create db:migrate

要退出容器时，运行 `exit` 就可以了

## 创建 Rails 容器

    docker run --name my-rails --link my-postgres:db -v "$PWD":/usr/src/app -p 3000:3000 -d my-rails

## 打开浏览器查看结果

    open http://192.168.59.103:3000

为什么是 `192.168.59.103` 地址而不是 `localhost` ?
因为 Docker 实际上是运行在虚拟机里面的，所有要访问虚拟机的 IP 才可以访问到。
这个地址是在运行 `boot2docker up` 时的返回结果里面有显示。
