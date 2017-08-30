---
title: 配置主从PostgreSQL数据库
date: 2014-09-05 16:47 +0800
comments: true
categories: [Server]
tags: [DB, Postgresql, 数据库, 运维]
topic: 技术
---

# 背景

数据库的数据量开始增多，负载开始变高，需要做一个数据库主从配置。

数据量，单表超过了100万条数据，应用程序做读写分离，写到主数据库，读从从数据库。


# 步骤

* 生成操作用的用户
* 配置主数据库，激活备份模式
* 关停从数据库，复制数据
* 配置从数据库，从主数据库同步数据

<!-- more -->

## 生成操作用的用户

```
sudo apt-get install postgresql
sudo -s postgres
psql -c "CREATE USER rep REPLICATION LOGIN CONNECTION LIMIT 1 ENCRYPTED PASSWORD 'yourpassword';"
```

## 配置主数据库，激活备份模式

切换到配置目录

```
cd /etc/postgresql/9.1/main
```

主从模式

```
cat >> postgresql.conf <<EOF
listen_addresses = 'localhost,IP_address_of_THIS_host'
wal_level = 'hot_standby'
archive_mode = on
archive_command = 'cd .'
max_wal_senders = 1
hot_standby = on
wal_keep_segments = 32
checkpoint_segments = 8
EOF
```

wal_keep_segments 1个16MB 32 就是512M，这个参数用来配置保存wal日志的大小。如果备份期间有很多数据库操作导致旧日志失效时，就需要配置更大的数字才能保证同步数据文件。

允许从数据库连接到主数据库

```
cat >> pg_hba.conf <<EOF
host    replication     rep     IP_address_of_slave/32   md5
EOF
```

重启数据库

```
service postgresql restart
```

## 配置从数据库，从主数据库同步数据

在从数据库机器执行

```
service postgresql stop
```

```
cd /var/lib/postgresql/9.1/main
echo > recovery.conf <<EOF
standby_mode = 'on'
primary_conninfo = 'host=master_IP_address port=5432 user=rep password=yourpassword'
trigger_file = '/tmp/postgresql.trigger.5432'
EOF
```

## 复制数据

在主数据库机器执行

```
psql -c "select pg_start_backup('initial_backup');"
rsync -cva -P --inplace --exclude=*pg_xlog* /var/lib/postgresql/9.1/main/ slave_IP_address:/var/lib/postgresql/9.1/main/
psql -c "select pg_stop_backup();"
```

20G 的数据文件大概复制了3个多小时，要看网络状况好不好。

## 启动从数据库

```
service postgresql start
```

参看log文件，看是否有报错

```
tail -f /var/log/postgresql/postgresql-9.1-main.log
```

## 测试

在主数据库执行

```
CREATE TABLE rep_test (test varchar(40));
INSERT INTO rep_test VALUES ('data one');
INSERT INTO rep_test VALUES ('some more words');
INSERT INTO rep_test VALUES ('lalala');
INSERT INTO rep_test VALUES ('hello there');
INSERT INTO rep_test VALUES ('blahblah');
```

在从数据库执行

```
SELECT * FROM rep_test;
```

查看数据有无同步


### 验证从数据库的只读属性

```
INSERT INTO rep_test VALUES ('oops');
```

```
ERROR:  cannot execute INSERT in a read-only transaction
```

## 查看同步状态

在主数据库中执行

```
select * from pg_stat_replication;
```

## 延伸阅读

[官网文档][2], [Ubuntu 12.04][1], [从0配置主从][3], [主从切换][4]

[1]: https://www.digitalocean.com/community/tutorials/how-to-set-up-master-slave-replication-on-postgresql-on-an-ubuntu-12-04-vps
[2]: http://www.postgresql.org/docs/9.1/interactive/continuous-archiving.html#BACKUP-BASE-BACKUP
[3]: http://www.rassoc.com/gregr/weblog/2013/02/16/zero-to-postgresql-streaming-replication-in-10-mins/
[4]: http://francs3.blog.163.com/blog/static/405767272011724103133766/ '主从切换'
