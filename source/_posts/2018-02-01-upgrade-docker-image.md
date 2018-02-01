---
title: 更新Docker容器
date: 2018-02-01 14:14:57
tags: ['Docker']
---

[使用 Docker 安装了 Redmine][1] 之后，已经过了很久了，这几天在维护服务器时，发现 Redmine 的版本也升级了。
就想着也升级一下容器吧。

先说下大体思路：

- 升级 Docker Image
- 关闭就容器，并删除之
- 重新开启新的容器，这样才能使用新的代码
- 升级数据库


## 升级 Docker Image

升级Image很简单，只要从服务器拉下来最新的数据就行了

    docker pull quay.io/sameersbn/redmine:latest


## 关闭就容器，并删除之

到工作目录 /data, 使用 docker-compose 来关闭级容器

    cd /data
    docker-compose stop
    docker rm data_redmine_1


## 重新开启新的容器，这样才能使用新的代码


因为代码升级，新增加了些环境参数的配置


    REDMINE_SECRET_TOKEN
    DB_NAME

这两个一个是log提示我的，另一个发现服务升级完后，旧用户登录不了了，查了原因才知道是因为数据库名称的默认值变了。
可能受影响的还有其他不少参数，需要在[详情页](https://hub.docker.com/r/sameersbn/redmine/)仔细看看。

    docker-compose start

## 升级数据库

    docker exec -it data_redmine_1 bash
    cd $WORKDIR
    RAILS_ENV=production bundle exec rake db:migrate

[1]: /2015/10/30/%E4%BD%BF%E7%94%A8-docker-%E6%9D%A5%E5%AE%89%E8%A3%85-redmine-%E5%B9%B6%E7%BB%93%E5%90%88-gitolite-%E4%BD%BF%E7%94%A8/
