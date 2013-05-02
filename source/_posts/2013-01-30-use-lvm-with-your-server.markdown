---
layout: post
title: "use lvm with your server"
date: 2013-01-30 11:22
comments: true
categories: [ubuntu, lvm]
---

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


how-to: <http://www.howtogeek.com/howto/40702/how-to-manage-and-use-lvm-logical-volume-management-in-ubuntu/><br/>
recipies: <http://docstore.mik.ua/manuals/hp-ux/en/5992-4589/ch03s03.html><br/>
pvreduce: <http://www.cclove.me/Create_Extend_and_Reduce_LVM_on_Ubuntu1204.html><br/>
