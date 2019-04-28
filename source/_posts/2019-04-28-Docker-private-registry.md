---
title: 建立自己的 Docker 私有库
date: 2019-04-28 22:17:59
tags: ['Docker']
---

若想在 production 上使用 Docker，必然需要使用使用私有的 Registry。
Docker 提供了一个很棒的 Registry Image, 使用他可以快速的建立自己的私有库。

<!-- more -->

# 准备工作

## htpasswd

因为这个私有库需要从公网进行访问，所以必然要做些鉴权的处理。我们简单实用 htpasswd 实现的 `HTTP Basic Authentication` 来进行鉴权。

使用以下命令来生成一个 md5 加密的密码文件

    docker run --entrypoint htpasswd registry:2 \
    -Bbn testuser testpasswd > auth/htpasswd

你可以多次运行来添加多个账号密码。

## HTTP TLS

因为 `HTTP Basic Authentication` 是以明文来传递密码信息的，所以需要Web应用打开 HTTP TLS。

具体的工作是我们要生成两个文件，可以通过 `Let's Encrypt` 来免费获得。

* server.crt # CA证书文件
* server.key # 秘钥文件

## 执行Docker命令

运行一下命令：

    docker run -d \
      -p 5000 \
      --restart=always \
      --name registry \
      -v "$(pwd)/auth:/auth" \
      -v "$(pwd)/ssl:/ssl" \
      -v registry:/var/lib/registry \
      -e REGISTRY_AUTH=htpasswd \
      -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
      -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
      -e REGISTRY_HTTP_TLS_CERTIFICATE=/ssl/server.crt \
      -e REGISTRY_HTTP_TLS_KEY=/ssl/server.key \
      registry:2


执行后运行 `docker ps` 可以在输出中看到。

## 验证

执行以下命令输入密码后尝试是否能成功。

    docker login -u testuser yourdomain.com:5000


## 发布 image 到私有库

先给本地 image 加标签，再 push 到私有库即可。

    docker pull hello-world
    docker tag hello-world yourdomain.com:5000/hello-world
    docker push yourdomain.com:5000/hello-world

## 使用私有库

就像使用共有库一样只是前面要加上私有库域名信息。

    docker run yourdomain.com:5000/hello-world