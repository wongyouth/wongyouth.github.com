---
title: 详解Ruby里用到的比较函数(equal?, eql?, ==, ===)
date: 2014-07-05 18:10 +0800
tags: [Ruby]
keywords: Ruby equal? eql? == ===
topic: 技术
---

Ruby里面有4种比较方法，`equal?`, `eql?`, `==`, `===`，而且在不同的类里面表现的很不一样。在使用的时候也特别容易搞糊涂。
这篇博文将演示一些代码来讲解各个方法。

### `==` - 类意义上的 `相等`，需要每个类自己定义实现

在特定类中觉得两个对象是否相同，需要看业务上的逻辑表象，所有由程序员覆盖该方法的定义，决定两个对象是否相同。

比如 `String` 类，他是来计较实际的文字串是否相同，而不在意是否来自同一个内存区域。

```ruby
>> a = "abc"
#=> "abc"

>> b = a + ""
#=> "abc"

?> a == b
#=> true

>> a.object_id
#=> 70255156346640

>> b.object_id
#=> 70255156340640
```

### `===` - 用在 `case` 语句里时会调用的方法

通常用在 `case` 比较调用该方法，比如

```ruby
case some_object
when /a regex/
  # The regex matches
when String
  # some_object is kind of String
when 2..4
  # some_object is in the range 2..4
when lambda {|x| some_crazy_custom_predicate }
  # the lambda returned true
end
```

等同于

```ruby
if /a regex/ === some_object
  # The regex matches
elsif String === some_object
  # some_object is kind of object
elsif (2..4) === some_object
  # some_object is in the range 2..4
elsif lambda {|x| some_crazy_custom_predicate } === some_object
  # the lambda returned true
end
```

### `eql?` - 通常意义上的 `相等`

如果两个对象的值相同将返回 true，如果重新定义了子类的 `==` 方法，一般需要 alias 到 `eql?` 方法。
当然也有例外，整数与小数的比较两个方法的返回值就不同。

```ruby
1 == 1.0   #=> true
1.eql? 1.0 #=> false
```

`eql?` 用在 Hash 里面用来做成员值比较

```ruby
[1] pry(main)> hash = Hash.new
#=> {}
[2] pry(main)> hash[2] = "a"
#=> "a"
[3] pry(main)> hash[2.0] = "b"
#=> "b"
[4] pry(main)> hash[2]
#=> "a"
[5] pry(main)> hash[2.0]
#=> "b"
[6] pry(main)> hash[2.00] = "c"
#=> "c"
[7] pry(main)> hash[2.0]
#=> "c"
```

所以什么时候应该覆盖这个方法就看你想让他在 Hash 比较时如何表现。

### `equal?` - 内存地址相同的对象

- 该方法不应该被子类覆盖
- 比较的是两个对象在内存中是否相同，是否有同一个`object_id`值
- Rails中及时相同的对象

```ruby
q = User.first
  User Load (40.4ms)  SELECT  "users".* FROM "users"   ORDER BY "users"."id" ASC LIMIT 1
#=> #<User id: 1, email: "ryan@wongyouth.com">

q2 = User.first
  User Load (0.4ms)  SELECT  "users".* FROM "users"   ORDER BY "users"."id" ASC LIMIT 1
#=> #<User id: 1, email: "ryan@wongyouth.com">

q.equal? q2
#=> false
```

## 记忆方法

- `==`
  按业务需求覆盖该方法
- `===`
  覆盖 `case` 语句时的表现
- `eql?`
  别名到 `==` 方法, 需要时覆盖方法改变 `Hash` 比较时的表现
- `equal?`
  不改动

## 延伸阅读

http://stackoverflow.com/questions/7156955/whats-the-difference-between-equal-eql-and
