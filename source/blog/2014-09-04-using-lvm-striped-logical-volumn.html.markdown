---
title: Using LVM striped logical volumn
date: 2014-09-04 17:47 +0800
comments: true
categories: [Server]
tags: [Server, LVM, 运维]
topic: 技术
---

之前写过一篇关于 LVM 的[博文](/blog/2013/01/30/use-lvm-with-your-server/)。
今天要说的是有关 LVM 的一个应用。

# 原理

当系统需要很多读写操作，需要更高效率的磁盘读写能力，完全升级磁盘等级会没有太多意义。
因为无论多好的磁盘读写能力，总会达到峰顶。

这时候我们需要另一种的解法。

挂载更多的磁盘到一个目录，这样写到一个磁盘的数据会分散到各个磁盘中，
这样子理论上可以达到无限扩展。

能够实现这个技术的，有RAID0, LVM Stripe。这里我只说LVM。

# 操作

## 确认 vg 所有 物理盘数量

```
jxb@pg2:~$ sudo vgs
  VG   #PV #LV #SN Attr   VSize  VFree
  db     3   1   0 wz--n- 59.99g 1008.00m
```

这里可以确认 PV 的数量是 3 个。

## 生成 `Stripe` 逻辑盘

```
# lvcreate -n pg1 -L 59G -i 3 db
```

生成由 3 个物理盘组成的 `striped` 的逻辑盘

## 查看逻辑盘是否是 `Stripe` 盘

```
jxb@db:~$ sudo lvs --segments
[sudo] password for jxb:
  LV   VG   Attr   #Str Type    SSize
  pg1  db   -wi-ao    3 striped 59.00g
```
这是一个由3个盘组成的 `Stripe` 盘。总共的容量是59G。

# 扩展Striped逻辑盘

扩展Striped逻辑盘的时候需要准备与生成时相同数量的物理盘，我们现在用了3个盘，所以一定要准备3个物理盘

```
jxb@pg2:~$ sudo pvcreate /dev/xvdg
  Physical volume "/dev/xvdg" successfully created
jxb@pg2:~$ sudo vgextend db /dev/xvdg
  Volume group "db" successfully extended
jxb@pg2:~$ sudo lvextend db/pg1 -L 70G
  Using stripesize of last segment 4.00 KiB
  Rounding size (17920 extents) down to stripe boundary size for segment (17919 extents)
  Extending logical volume pg1 to 70.00 GiB
  Insufficient free space: 2814 extents needed, but only 2811 available
```

可以看到只有一个物理盘的时候无法扩展逻辑盘

```
jxb@pg2:~$ sudo pvcreate /dev/xvdi
  Physical volume "/dev/xvdi" successfully created
jxb@pg2:~$ sudo pvcreate /dev/xvdh
  Physical volume "/dev/xvdh" successfully created
jxb@pg2:~$ sudo vgextend db /dev/xvdi
  Volume group "db" successfully extended
jxb@pg2:~$ sudo vgextend db /dev/xvdh
  Volume group "db" successfully extended
jxb@pg2:~$ vgs
  WARNING: Running as a non-root user. Functionality may be unavailable.
  No volume groups found
jxb@pg2:~$ sudo vgs
  VG   #PV #LV #SN Attr   VSize  VFree
  db     6   1   0 wz--n- 89.98g 30.97g
jxb@pg2:/u$ sudo lvextend -l+100%free db/pg1
  Using stripesize of last segment 4.00 KiB
  Extending logical volume pg1 to 89.98 GiB
  Logical volume pg1 successfully resized
```

## 查看 `Stripe`  逻辑盘信息

```
jxb@pg2:/u$ sudo lvs --segments
  LV   VG   Attr   #Str Type    SSize
  pg1  db   -wi-ao    3 striped 59.99g
  pg1  db   -wi-ao    3 striped 29.99g
```

## 调整逻辑盘大小

调整前已经使用了 76%

```
jxb@pg2:/u$ df -h
Filesystem          Size  Used Avail Use% Mounted on
/dev/mapper/db-pg1   59G   43G   14G  76% /u
```

执行调整操作

```
jxb@pg2:/u$ sudo resize2fs /dev/mapper/db-pg1
resize2fs 1.42 (29-Nov-2011)
Filesystem at /dev/mapper/db-pg1 is mounted on /u; on-line resizing required
old_desc_blocks = 4, new_desc_blocks = 6
Performing an on-line resize of /dev/mapper/db-pg1 to 23586816 (4k) blocks.
The filesystem on /dev/mapper/db-pg1 is now 23586816 blocks long.
```

调整后 降为 51%

```
jxb@pg2:/u$ df -h
Filesystem          Size  Used Avail Use% Mounted on
/dev/mapper/db-pg1   90G   43G   43G  51% /u
```

到此 Stripe 逻辑盘扩展成功

注意事项：`resize2fs` 在 Kernel2.6 之前是需要 `umount` 盘之后才可操作，执行该项操作做好数据备份工作。

## 延伸阅读

[生成Stripe逻辑盘][1],
[迁移LVM硬盘到别的主机上][2]

[1]: http://tldp.org/HOWTO/LVM-HOWTO/recipethreescsistripe.html "生成Stripe逻辑盘"
[2]: http://tldp.org/HOWTO/LVM-HOWTO/recipemovevgtonewsys.html "迁移LVM硬盘到别的主机上"
[3]: http://www.softpanorama.org/Commercial_linuxes/LVM/resizing_the_lvm_filesystem.shtml "调整LVM逻辑盘大小"
