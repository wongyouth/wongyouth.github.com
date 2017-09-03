---
title: 切换到新的博客引擎 Hexo
date: 2017-09-03 10:25:28
tags: Blog
---

是的，又换了一个博客引擎。

从 Octopress -> middleman-blog -> Hexo，博客没写几篇引擎倒是换的很勤，自嘲一下！

自从 2014 年切换到 [middleman-blog][], 已经有3年时间了，但是 `middleman-blog` 发展却停滞了。
究其原因，我想到了几点：

<!-- more -->

* 毕竟 Ruby 是个小众语言，使用的人基数就不大
* middleman-blog 是 middleman 的一个扩展项目，所以很多东西还要受限于 middleman，如果 middleman 不发展， middleman-blog 也发展不了

我之前还提交过一个 [PR][] 给 `middleman-blog`，
没想到新版本更新后竟然被忽略掉了，有点莫名其妙。

说下体验

* 主题比较少，网上搜索文章比较少，遇到问题肯定想找到答案也难，自己看源码。
* 每次升级 Ruby 环境时，感觉升级会有点小麻烦，自己用着也不是很爽。
* 想装些 JavaScript 的包，比较麻烦，我之前还是用 `bower` 来管理的，现在主流已经换到 `npm` 了。

所以想换一个基于 `nodejs` 的微博引擎，其实我是想用基于 `nuxt` 的，但是目前还没有，所以用了 `hexo`，专门用于生成博客的，毕竟术业有专攻，没有什么坏处。

## 迁移到 Hexo

如果按 [官方Migration][migration] 来， 出来的网址是这样的：

http://localhost:4000/2017/09/03/2017-09-03-title

但是我们要的是这样的：

http://localhost:4000/2017/09/03/title

所以还要配置

        #permalink: :year/:month/:day/:title/
        permalink: :year/:month/:day/:post_title/

感觉 `Hexo` 3 出来后文档有点乱。这个也是我看了源码查到的，之前烦恼了好几天。

## 主题

其他主要就是自己选个 [主题][theme] 就行了，我选的是 [next][] 主题。

## RSS

为了网址加上 RSS， 搜了下需要要加 `next-generator-feed`，但是加了后会报错，说找不到 `process-nextick-args`，于是 npm i process-nextick-args --save

## 结论

总体感觉 `Hexo` 小问题比较多，但是社区是很活跃的，Star 有 18k，希望以后不用再换博客引擎了。

[migration]: https://hexo.io/docs/migration.html
[next]: https://github.com/iissnan/hexo-theme-next
[middleman-blog]: https://github.com/middleman/middleman-blog
[PR]: https://github.com/middleman/middleman-blog/pull/212
[theme]: https://hexo.io/themes/
