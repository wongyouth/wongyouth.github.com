---
title: Use swapfile with lower memory VPS
date: 2020-07-31 14:32:43
tags: ['Docker', 'VPS']
---

最近用到用云主机来做应用的自动发布处理。
就是那种当你提交了代码到代码库后，自动跑CI，然后自动发布到服务器上去，一切都是自动运行。

<!-- more -->

这时候一般会选择一台最便宜的云主机自搭一台做 CI 或 CD。
为什么不用第三方服务？

因为

1. 有的时候真的不便宜
2. 大部分在国外，如果要回访到国内主机操作，可能会有网络问题，你懂得
3. 云主机可以一机多用，最大化利用其价值
4. 云主机真的超便宜，每月5刀吧，1T流量，1G内存，20G硬盘，真香！

说回到主题。配置这么低的云主机当然会有所限制，碰到的问题是编译打包 javascript 文件。
我用 docker build 都能编译 Dockerfile，却在 webpack 打包 JS 文件是内存不足！
1年前这个问题困扰我很久，我以为没有硬件问题办法解决，直接缴械投降了。
1年后看到别人的方案： 使用 swapfile 交换内存区来解决。嗯，真香现场啊。

马上复制一份留作后用:

    # Allocate a file for swap
    sudo fallocate -l 2048m /mnt/swap_file.swap
    # Change permission
    sudo chmod 600 /mnt/swap_file.swap
    # Format the file for swapping device
    sudo mkswap /mnt/swap_file.swap
    # Enable the swap
    sudo swapon /mnt/swap_file.swap

原文链接：
https://medium.com/@dpaluy/the-ultimate-guide-to-dokku-and-ruby-on-rails-5-9ecad2dba4a3
