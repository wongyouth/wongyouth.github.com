---
title: PostgreSQL Tips
date: 2014-10-15 09:28 +0800
tags: [ DB, PostgreSQL, 数据库 ]
category: [Server]
topic: 技术

---

PostgreSQL 查询

## PostgreSQL 后台进程状态

当一个 postgres 进程查询很花时间时，可以在后台看一下到底是什么处理导致慢。

```
SELECT datname,usename,procpid,client_addr,waiting,query_start,current_query FROM pg_stat_activity where procpid = $PID;
```

## 查询 PostgreSQL 存储过程源码

查询一个 PostgreSQL 的存储过程的源码。

```
select prosrc from pg_proc where proname = '$PRONAME';
```
