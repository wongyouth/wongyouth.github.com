---
layout: post
title: "Config DNS server for development"
date: 2013-04-22 19:28
comments: true
categories: [Server]
tags: [运维, DNS, Bind9]
---

开发的时候我们很多时候需要配置一个与线上相同的环境来做测试。
其中一项就是我们需要用线上相同的域名在做测试，这样就需要在开发环境里面配置域名映射。
最为简单的情况就是使用/etc/hosts，但是如果是有一团队来做测试，需要所有的人有相同的配置，
特别是有新成员来的时候，相同的工作要不厌其烦的重复做重复说明。

还有一种办法就是找一台机器来做域名解析服务，其实配置起来也不是很麻烦，下面就让我来讲一个简单的例子。

<!-- more -->

Step 1. 安装bind9

    sudo apt-get install bind9

Step 2. 配置bind

    #sudo vi /etc/bind/named.conf.options

    # 本DNS不知道的域名会到8.8.8.8服务器问
    forwarders {
      8.8.8.8;
    };

    # 允许递归访问
    recursion yes;

    # 允许外部访问
    allow-query {anry;};

step 3. 配置本地DNS

假如我们要配置一个 taobao.com 的DNS

    #sudo vi /etc/bind/named.conf.local

    zone "taobao.com" {
      type master;
      file "/etc/bind/db.taobao.com";
    };

    #sudo vi /etc/bind/db.taobao.com

    ;
    ;$TTL    604800
    $TTL    7d
    @       IN      SOA     taobao.com. admin.taobao.com. (           # admin.taobao.com 表示 admin@taobao.com 管理员email
                                  2         ; Serial
                             604800         ; Refresh
                              86400         ; Retry
                            2419200         ; Expire
                             604800 )       ; Negative Cache TTL
    ;
            IN      NS      ns.taobao.com.                            # 设置域名DNSip 最后有个.结尾表示一个全的URL
    @       IN      A       192.168.0.100
    ns      IN      A       192.168.0.100
    mx      IN      MX      192.168.0.100
    www     IN      A       192.168.0.100
    m       IN      CNAME   www                                       # 设置别名
    *       IN      A       192.168.0.100                             # 没有设置过的子域名都转到这个IP

通过以上的配置，只要在系统里面把DNS设置好，在浏览器里面输入 `taobao.com` 就会解析到 192.168.0.100这个IP，而不是真正的淘宝网了。
如果有路由器的配置权限，只要把路由器的DHCP地址设为这个DNS服务器的IP，这样系统里面设置DNS这一步也可以省略，真正即插即用。
