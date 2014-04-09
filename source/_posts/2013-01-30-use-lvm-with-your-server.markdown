---
layout: post
title: "use lvm with your server"
date: 2013-01-30 11:22
comments: true
categories: [server]
tags: [ubuntu, lvm]
---

我们在使用服务器的时候会遇到各种各样的问题，比如今天要说的硬盘管理。

在服务器刚开始使用的时候一般只装配了现阶段要使用的容量，究其原因

1. 资金有限，不能一步到位
2. 前期无法得知需要多大容量，需要使用一段时间才能评估
3. 类似需要时增加配额的策略

而如果当发现硬盘容量不够需要增加时，如果安装普通mount方法，需要准备一个更大的硬盘，把原始盘的内容复制过来。
这个操作会带来一定的风险：

1. 复制需要一定的时间，在复制过程中原始盘内容可能又会增加
2. 使用新盘后，原始盘多了出来，不能重复使用。
3. 无法使用多盘来有效分散IO读写压力

使用LVM就可以克服以上的问题。

<!-- more -->

LVM(Logical Volume Manager) 是逻辑卷管理的简写。LVM是建立在硬盘和分区之上的一个逻辑层，来提高磁盘分区管理的灵活性。
这里涉及到几个概念

* 物理介质
* 物理卷
* 卷组
* 逻辑卷

朴素的原理是：物理卷建立在物理介质上，一个或者几个物理卷组成一个卷组，从卷组里分割出一个或者几个逻辑卷。
通过这种方式，可以动态增加物理介质从而增加逻辑卷的大小。

based on:
  * a disk /dev/xvdd more than 50G
  * ubuntu 12.04 LTS

    # install lvm2
    sudo apt-get install lvm2

    # create a pysical volume
    sudo pvcreate /dev/xvdd

    # create a volume group with name `yun`
    sudo vgcreate yun /dev/xvdd

    # create a logical volume named `gp` from vg yun with 50 giga bytes
    sudo lvcreate -L 50G -n pg yun
    # use max size of vg to create a lv
    sudo lvcreate -l 100%FREE -n pg yun #

    # format the logical volume
    sudo mkfs.ext4 /dev/mapper/yun-pg

    # mount the lv
    sudo mount /dev/mapper/yun-pg /mnt

    # add new device
    sudo pvcreate /dev/xvde

    # extend vg
    sudo vgextend yun /dev/mapper/yun-pg

    # extend lv to 8G
    sudo lvextend -L8G yun-pg

    # extend lv with extra 8G
    sudo lvextend -L+8G /dev/mapper/yun-pg

## References

* http://www.howtogeek.com/howto/40702/how-to-manage-and-use-lvm-logical-volume-management-in-ubuntu/
* http://docstore.mik.ua/manuals/hp-ux/en/5992-4589/ch03s03.html
* http://www.cclove.me/Create_Extend_and_Reduce_LVM_on_Ubuntu1204.html
