---
title: Using LVM striped logical volumn
date: 2014-09-04 17:47 +0800
comments: true
categories: [Server]
tags: [Server, LVM, 运维]
topic: 技术
published: false
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

## 查看逻辑盘是否是 `Stripe` 盘

```
jxb@db:~$ sudo lvs --segments
[sudo] password for jxb:
  LV   VG   Attr   #Str Type    SSize
  pg1  db   -wi-ao    3 striped 59.00g
```

## 延伸阅读

[生成Stripe逻辑盘][1],
[迁移LVM硬盘到别的主机上][2]

[1]: http://tldp.org/HOWTO/LVM-HOWTO/recipethreescsistripe.html "生成Stripe逻辑盘"
[2]: http://tldp.org/HOWTO/LVM-HOWTO/recipemovevgtonewsys.html "迁移LVM硬盘到别的主机上"
