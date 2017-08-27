---
title: 当 ActiveRecord 不够用时还有 Arel
date: 2014-07-16 09:31 +0800
tags: ["Ruby", "数据库"]
keywords: ["ActiveRecord", "Arel", "Rails", "Ruby"]
topic: "技术"
published: true
---

## 1. 取反运算符

```
SELECT * FROM posts WHERE title != 'Arel is cool'
```

### ActiveRecord

```
Post.where.not(title: 'Arel is cool')
```

### Arel

```
Post.where(Post[:title].not_eq('Arel is cool')
```

## 2. NULL 运算

```
SELECT * FROM posts WHERE title IS NOT NULL
```

### ActiveRecord

```
Post.where.not(title: nil)
```

### Arel

```
Post.where(Post[:title].not_eq(nil))
```

## 3. 比较运算

```
SELECT * FROM posts WHERE id > 100
```

### ActiveRecord

```
Post.where('id > 100')
```

### Arel

```
Post.where(Post[:id].gt(100))
```

## 4. Like 运算符

标题里含有 arel 的所有博文

MySQL 中默认设定时 `LIKE` 是不区分大小写的，要想使用区分大小写的比较则可以写成


### ActiveRecord 的标准写法

```
Post.where("title LIKE BINARY ?", '%arel%')
```

但是这是 MySQL 特定的写法，如果换成 PostgreSQL 就需要更改查询语句了。

### Arel 的写法

```
Post.where(Post.arel_table[:title].matches('%arel%'))
``
=>

MySQL 时

```
SELECT `posts`.* FROM `posts` WHERE `posts`.title LIKE x'256172656c25')
```
如果是 PostgreSQL 时

```
SELECT posts.* FROM posts WHERE posts.title LIKE '%arel%')
```

## 5. 获得查表SQL文

使用 `count`

```
Post.select(Post[:id].count, :text).to_sql
```
=>

```
SELECT COUNT(posts.id), text FROM posts
```

使用别名 `as`

```
Post.select(Post[:id].count.as(count_id)).to_sql
```

=>

```
SELECT COUNT(posts.id) AS count_id, text FROM posts
```

## 6. 使用自定义命令

```
Post.select(
  Arel::Nodes::NamedFunction.new(
    "LENGTH", [Post[:text]]
  ).as("length")
)
```

=>

```
SELECT LENGTH(posts.text) AS length FROM posts
```

## 7. 全选

```
Post.select(Arel.star)
```

=>

```
SELECT * FROM posts
```

## 8. 子查询

1). 在From 语句里面使用

```
Post.select(:id).from(Post.select([:title, :text]).ast)
```

=>

```
SELECT id FROM SELECT title, text FROM posts
```

2). 在Where 语句里面使用

```
Post.where(Post[:title].eq('Arel is cool').and(Post[:id].eq(22)))
```

=>

```
SELECT id FROM posts WHERE(
  posts.title = 'Arel is cool' AND (Post.id = 22)
)
```

3). 在条件语句里面

查询与第五个博文标题一致的所有博文

```
SELECT posts.* FROM posts WHERE posts.title IN (
  SELECT posts.title WHERE id = 5
)
```

### ActiveRecord 的标准写法

```
WHERE posts.title IN (
  SELECT title FROM posts WHERE id = 5
)
```

### Arel 的写法

```
Post.where(
  Post[:title].in(
    Post.select(:title).where(id: 5).ast
  )
)
```


## 9. JOIN 语句

假设 3 个类的关系是

```
class Post < ActiveRecord::Base
  has_many :comments
  ...
end

class Comment < ActiveRecord::Base
  belongs_to :post
  has_one :author
  ...
end

class Author < ActiveRecord::Base
  belongs_to :comment
  ...
end
```

1). `INNER JOIN` 查询用户"Barack Obama"评论过的所有有效博文

```
SELECT posts.*
  FROM posts
 INNER JOINS comments ON comments.post_id = posts.id
 INNER JOINS authors ON authors.comment_id = comments.id
 WHERE authors.name = 'Barack Obama'
   AND posts.active = true
```

### ActiveRecord 的标准写法

```
Post
  .joins(:comments => :author)
  .where([
    "authors.name = ? AND posts.active = ?",
    "Barack Obama", true
  ])

或

Post
  .joins(:comments => :author)
  .where(author: {name: "Barack Obama"}, posts: {active: true})
```

### Arel 的写法

```
Post
  .joins(:comments)
  .joins(Comment.joins(:author).join_sources)
  .where(
    Author[:name].eq("Barack Obama")
      .and(Post[:active].eq(true))
  )
```


## 备注

`Post[:id]` 写法默认不支持，是使用了 `arel-helpers` 后 `Post.arel_table[:id]` 的缩写方式。

### 延伸阅读

* https://github.com/camertron/arel-helpers
* http://www.slideshare.net/camerondutro/advanced-arel-when-activerecord-just-isnt-enough
