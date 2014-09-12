---
title: When ActiveRecord is not Enough
date: 2014-07-16 09:31 +0800
tags:
published: false
---

## 1.

```
Post
  .joins(:comments)
  .joins(Comment.joins(:author).join_sources)
  .where(
    Author.arel_table[:name].eq("Barack Obama")
      .and(Post.arel_table[:active].eq(true))
  )
```

# ==

```
Post
  .joins(:comments => :author)
  .where([
    "authors.name = ? AND posts.active = ?",
    "Barack Obama", true
  ])
```

```
Post.where(
  Post.arel_table[:title].in(
    Post.select(:title).where(id: 5).ast
  )
).to_sql
```

=>

```
SELECT `posts`.* FROM `posts`
WHERE `posts`.title IN (
  SELECT `title` FROM `posts` WHERE `id` = 5
)
```

### MATCHES

```
Post.where(Post.arel_table[:title].matches('%arel%')).to_sql
```

=>

```
SELECT `posts`.* FROM `posts`
WHERE `posts`.title LIKE x'256172656c25')
```

```
Account.preload(:idol_relations)
```
