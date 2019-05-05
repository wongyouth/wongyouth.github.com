---
title: 'xhyve, 苹果电脑下轻量级虚拟机方案'
date: 2019-04-28 22:48:40
tags: ['Docker']
---

Docker 底层是跑在 Linux 基础上的，但是我们开发的电脑常用 Apple Mac,
如果想在 OSX 上跑 Docker 的话，一般使用 `Virtual Box` 或者 `VMware` 来运行一个VM。
因为这层软件也不是原生的，相当于多加了一层，
开启一个 VM 常常很耗时，运行在上面的应用的性能并不好。

常常让人觉得 Docker 对 OSX 的亲和力不够。

最近才看到有一个基于 OSX 原生底层的 VM 叫做 [xhyve](https://github.com/machyve/xhyve)。我尝鲜了一把，虽然遇到了一个小坑，但是克服之后用起来感觉很不错，赶紧来看看吧。

<!-- more -->

## Install

    brew install xhyve docker-machine-driver-xhyve docker docker-machine

如果之前有安装过 docker 系列的的，推荐升级或者重新安装一遍。

## create a VM

    docker-machine create default --driver xhyve
    eval $(docker-machine env)


网上有推荐加 nfs 参数的，如果需要在host机和VM之间互传数据的话。

    docker-machine create default --driver xhyve -—xhyve-experimental-nfs-share

## 验证

    docker ps
    docker run hello-world

# 遇到的坑

参数 `-v` 带的本地 volume 映射不上去。


    docker run -v .:/usr/app sh

运行后进入到 container 时发现并没有相应的文件。

## 解决办法：

执行

    grep Virtio9p ~/.docker/machine/machines/default/config.json


如果该值是 `false` 改成 `true`，再重启 VM 就解决了。

    docker-machine restart

很好奇为什么不是默认开启？可以关注下官方的[issue](https://github.com/machine-drivers/docker-machine-driver-xhyve/issues/136)

# 后续

使用 vhyme 后极大的降低了 VM 的开启速度。
他也极好的支持了使用 `swarm` 的来增加 node 的测试。我在后面篇幅将进行尝试。
