---
title: 使用 Ruby 来调用 Windows DLL 函数
date: 2017-11-10 10:11:42
tags: ['Ruby']
---

正好项目中要使用外部的 `DLL` 接口，如果用 `C` 来写固然是可以的。
但是也好多年没用了，觉得再拿起来也要些时间。就搜了下 `Ruby` 来怎么对接。

基本上网上推荐了2种方法：

* `fiddle`
* `ffi`

`fiddle` 是 `Ruby` 标准库自带的，用法比较简单，但是官方文档特别少。
`ffi` 是一个独立的 `Gem`，他是基于 `libffi` 的一个外部扩展来实现的，官网文档比较多。

感觉 `fiddle` 使用比较简单，我用的 `DLL` 也不是很复杂，就只试了 `fiddle`。
首先推荐看下这篇[基础教程][tutorial] ，大体就知道怎么用了。

但是很快就遇到了一个问题，`int[]` 这种数组怎么传过去。
搜了下，看到了[这篇文章][array]，试了一下用 `a.pack('i' * a.size)` 方法的确可以。

遇到的第二个问题是如何传 `UNICODE` 字符串，搜了一下没有搜到。
于是我就想说不定 `ffi` 这边的文档会有些提示。
果然官方`Wiki` 里有一篇[例子][unicode]讲到了，使用需要`encode('UTF-16LE')`一下，
有一点我试的时候不在末尾加 `\0` 也是没问题的。

{% include_code 'message_box.rb' %}


[tutorial]: http://blog.honeybadger.io/use-any-c-library-from-ruby-via-fiddle-the-ruby-standard-librarys-best-kept-secret/
[unicode]: https://github.com/ffi/ffi/wiki/windows-examples
[array]: https://ruby-china.org/topics/24821
