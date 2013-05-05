---
layout: post
title: "让你的网站支持SSL"
date: 2013-01-05 20:46
comments: true
categories: [server]
tags: [ssl]
---
ssl是什么，ssl就是你在网址里面看到的https。区别于http，如果是ssl的，那么他所传输的数据是保密的，
别人无法根据监听网络偷取你的信用卡数据，登录密码。现在国内的银行等大型网站基本上都支持ssl了。

我们在用apache作为web服务器来配置一个网站的时候，往往自动忽略掉配置ssl，原因是ssl的CA一把都是收费的。
而且费用也都不低。现在终于好了，startssl.com支持免费的单域名了。

<!-- more -->

startssl.com支持class1级别的ssl服务，如果你的网站没有多个子域名，那就完全可以使用了。
如果的你的网站有多个子域名，那么就无法支持全站的ssl。

当然有个折中的方案就是只让登录的处理支持ssl，别的页面不需要ssl，
下面就是我这个折中方案的做法步骤。

* 首先需要到startssl.com注册
* 验证你的email，domain，30天有效，之后需要重新验证
* 生成csr文件，当然你可以根据网站向导上的工具来生成

      openssl genrsa -des3 -out domain.key 2048        # create key
      openssl req -new -key domain.key -out domain.csr # create certificate sign request
      cat domain.csr # 把输出整个复制到startssl.com生成ssl的输入框内

* 复制网站生成的crt内容，保存到文件 domain.crt
* 下载 [chain][]文件，root [CA][] 文件
* 设置apache
    * a2enmod ssl
    * a2enmod rewrite
    * 修改virtual host配置，当login处理是跳转到ssl，当其他处理时从https跳回到普通的http

```
    <VirtualHost _default_:80>
      ServerName example.com
      ServerAlias *.example.com
      DocumentRoot /home/httpd/private

      ErrorLog /var/log/apache2/example_errors.log
      LogLevel warn
      CustomLog /var/log/apache2/example_ssl_access.log combined

      RewriteEngine On
      RewriteCond %{HTTP:X-Forwarded-Proto} !=https
      RewriteCond %{REQUEST_URI} ^/login
      RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [L]
    </VirtualHost>

    <VirtualHost _default_:443>
      ServerName example.com
      ServerAlias *.example.com
      DocumentRoot /home/httpd/private

      ErrorLog /var/log/apache2/example_errors.log
      LogLevel warn
      CustomLog /var/log/apache2/example_ssl_access.log combined

      SSLEngine on
      SSLCertificateFile /usr/local/apache/conf/ssl.crt
      SSLCertificateKeyFile /usr/local/apache/conf/ssl.key
      SSLCertificateChainFile /usr/local/apache/conf/sub.class1.server.ca.pem
      SSLCACertificateFile /usr/local/apache/conf/ca.pem
      RewriteEngine On

      # assets files should not be redirected.
      RewriteRule \.(css|js|gif|jpe?g|png)(\?[0-9]*)?$ - [NC,L]

      RewriteCond %{HTTP:X-Forwarded-Proto} !=http
      RewriteCond %{REQUEST_URI} !^/login
      RewriteRule (.*) http://%{HTTP_HOST}%{REQUEST_URI} [L]
    </VirtualHost>
```

[chain]: http://www.startssl.com/certs/sub.class1.server.ca.pem
[CA]: http://www.startssl.com/certs/ca.pem
