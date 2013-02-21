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

sudo apt-get install lvm2
sudo pvcreate /dev/xvdd
sudo vgcreate yun /dev/xvdd
sudo lvcreate -L 50G -n pg yun

sudo mkfs.ext4 /dev/mapper/yun-pg

sudo mount /dev/mapper/yun-pg /mnt


[how-to]:http://www.howtogeek.com/howto/40702/how-to-manage-and-use-lvm-logical-volume-management-in-ubuntu/
[recipies]:http://docstore.mik.ua/manuals/hp-ux/en/5992-4589/ch03s03.html
[pvreduce]:http://www.cclove.me/Create_Extend_and_Reduce_LVM_on_Ubuntu1204.html
