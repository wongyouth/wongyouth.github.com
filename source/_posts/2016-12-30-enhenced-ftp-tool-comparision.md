---
title: Ftp 增强工具比较
date: 2016-12-30 15:13 +0800
tags: ["ftp"]
keywords: ["Server", "Admin"]
topics: '技术'
---

现在与主机交互的首选工具应该是 `ssh` 相关的工具了，比如 `scp`, `rsync`。因为他们都是建立在传输层基础上的安全协议。
而老牌的 `ftp` 则不然，因为他们访问主机时的登录交互容易被窃听，有泄密的可能性。
`ftp` 也有对应的安全版本 `sftp`, 但是用的就很少了，因为 `sftp` 也是基于 `ssh` 的，但是 `ssh` 自带传输特效，所有 `sftp` 就很少用的了。

本篇为什么要写 `ftp`，是因为对接老的系统的时候，是超出我们控制的。
最近的项目中就需要把本地的数据包传到服务器上，因此找了几个 `ftp` 工具来分析了下。

<!-- more -->

主要的需求是

* CUI 非 GUI，因为需要结合 Shell 来写脚本
* 容易上传整个目录
* 可以指定上传路径
* 最好密码不要显示在命令行里

找了3个来分析了下功能 `ftp`, `ncftp`, `lftp`

## `ftp`

首先当然是用系统自带的 `ftp`，

* `put` 命令不能指定目标路径，需要先登录后 `cd` 到目标路径
* 不能指定整个目录上传，多个文件可以用 `mput`
* 密码可以带入 `user@pass:host` 中，放在 ~/.netrc 里面
在 ~/.netrc 里的格式是

        machine host/ip
          login USERNAME
          password PASSWORD

## `ncftp`

`ncftp` 可以满足上面的所有需求

* 上传整个目录，包括子目录

        ncftpput -u user -p pass -R  host /host/dir /local/dir

* 上传到指定路径

        ncftpput -u user -p pass host /host/dir /local/path

* 隐藏密码

  * 提示输入密码

        ncftpput -u user host /host/dir /local/path

  * 放入配置文件

        ncftpput -f login.cfg host /host/dir /local/path

      login.cfg 文件是这个格式

        host example.com
        user USERNAME
        pass PASSWORD

## `lftp`

`lftp` 满足了我的所有需求

* 镜像整个目录，包括子目录

        lftp -e 'mirror -R /local/dir /host/dir' host

* 上传到指定路径

        lftp -e 'put -O /host/dir/ /local/path; bye' host

* 密码方式与 `ftp` 相同

## 其他比较

使用 `ncftp` 或者 `lftp` 登录后，都可以使用上下键历史命令回显，`Tab` 键显示候选文件，文件补全等功能。他们的功能比较相近，由于满足了我要的需求，没有再深入比较了。
