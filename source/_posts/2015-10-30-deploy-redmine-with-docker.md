---
title: 使用 Docker 来安装 Redmine 并结合 gitolite 使用
date: 2015-10-30 11:16 +0800
tags: ["Docker"]
keywords: ["Redmine", "gitolite", "服务器 Server", "部署 Deployment"]
topic: "技术"
---

[上一篇](/2015/07/02/与-docker-一起使用-rails/)介绍了 Docker 之后，仅仅过了3个月时间，Docker又增加了很多变化:
比如 [Docker Machine](https://docs.docker.com/machine/install-machine/), [Docker Compose](https://docs.docker.com/compose/install/)。

最近项目里要把 Redmine 从盛大云到阿里云，正好可以发挥 Docker 的强项。这里分析一下需要实现的功能：

- Redmine 服务
- Postgres 数据库服务
- [gitolite](https://github.com/sitaramc/gitolite) Git repo 服务
- 迁移老数据到新的服务里
- Redmine 服务自启动

<!-- more -->

### Install gitolite

虽然 gitolite 也有docker 提供，但是 redmine 需要访问 git 下面的 repo 文件，所以会有权限问题。
Docker 现在对 权限映射 这方面的支持还不是很好。所以我决定把 gitolite 安装在宿主机器内部。
所以 gitolite 按照官网的安装步骤安装。旧的 repo 数据只要复制覆盖 /home/git/repositories 就可以了。

### Docker for Redmine

在 [Docker hub](https://hub.docker.com) 里搜了一下可用的 Redmine 之后，
发现 [sameersbn/redmine 版本](https://hub.docker.com/r/sameersbn/redmine/) 比[官方版本](https://hub.docker.com/_/redmine/) 多了很多星，
连下载量也比官方多了一倍不止。比较了下内容之后发现官方版无法支持外发邮件，所以只有选择 `sameersbn` 版了。

如果是完全新安装不需要迁移数据的话，可以直接使用提供的样例 [docker-compose.yml](https://raw.githubusercontent.com/sameersbn/docker-redmine/master/docker-compose.yml) 文件了。
所以 Redmine 这部分还是比较简单，使用了

```
redmine:
  image: quay.io/sameersbn/redmine:latest
  links:
    - postgresql:postgresql
  environment:
    - USERMAP_UID=1001
    - USERMAP_GID=1001
    - TZ=Asia/Beijing
    - REDMINE_PORT=3000
    - SMTP_ENABLED=true
    - SMTP_DOMAIN=example.com
    - SMTP_HOST=smtp.exmail.qq.com
    - SMTP_PORT=25
    - SMTP_USER=user@example.com
    - SMTP_PASS=exampass
    - SMTP_AUTHENTICATION=:login
    - IMAP_ENABLED=false
    - IMAP_USER=mailer@example.com
    - IMAP_PASS=password
    - IMAP_HOST=imap.gmail.com
    - IMAP_PORT=993
    - IMAP_SSL=true
    - IMAP_INTERVAL=30
  ports:
    - "80:80"
  volumes:
    - /data/redmine:/home/redmine/data
    - /home/git/repositories:/home/redmine/repositories
  restart: always
```

- 其中老服务器中用户上传的文件需要迁移到 /data/redmine/files 文件夹中就可以了。
- `USERMAP_UID=1001 USERMAP_GID=1001` 1001 是 git 用户的 uid, gid。
这样 docker 内的 redmine 的 uid,gid 就与git的一致，解决了权限问题。
- `restart: always` 让这个 container 自启动

### Docker for Postgres

上面的样例中数据库使用的是被定制化过的 Postgres ，但是我觉得官方的版本完全够用了。
迁移的策略是这样的，

1. 先用 docker 启动一个最基本的 postgres image: `docker-compose up -f /data/pg.yml`

        postgresql:
          image: postgres
          environment:
            - POSTGRES_USER=redmine
            - POSTGRES_PASSWORD=secret
            - PGDATA=/data
          volumes:
            - /data/pg:/data

2. 开启一个 postgres client 导入数据库旧数据，默认数据库名字是redmine

        $ docker run --link data_postgresql_1:db -v /data:/data -it postgres bash
        $ psql -h $DB_PORT_5432_TCP_ADDR -U redmine redmine < /data/pg_old_data.sql

3. 链接 Redmine docker 到 postgresql docker 就可以完工了。

完整的 docker-compose.yml 文件

{% include_code 'docker-compose.yml' %}
