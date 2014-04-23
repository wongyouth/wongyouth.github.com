---
title: 新版博客发布，使用Middleman做为博客引擎
date: 2014-04-23 12:46 +0800
tags: [博客]
---

在使用 [`Octopress` 写博客][blogging] 2年之后，有很多的新技术涌现，我决定更新一下博客引擎，并重新设计界面。

## 我需要的功能

-   支持博客
-   支持分类标签
-   支持markdown，语法高亮
-   支持Sass, CoffeScript
-   支持开发，商业代码分离
-   方便发布
-   容易扩展
-   容易升级依赖包，使用最新技术
-   支持开发状态代码有改动时浏览器自动刷新（LiveReload）

<!-- more -->

## 比较各个工具的优缺点

调查了一下几个可以使用写静态博客的工具

-   [Jekyll][]
-   [Octopress][]
-   [Yeoman][]
-   [Middleman][]

### Jekyll

-   优点

    集成了博客系统

-   缺点

    Octopress 对Sass不支持，而且对livereload不友好

### Octopress

-   优点

    所有的功能都已经集成

-   缺点

    没有使用最新的Jekll，还在使用很早的版本；
    目录结构独立设计难以转换成Rails代码。

### Yeoman

-   优点

    轻量，方便，可配置度高

-   缺点

    没有集成可以的blog系统

### Middleman

-   优点

    与 Rails 目录架构相似，很多方法名字用法都相同，很容易以后改成 Rails 框架的动态页面。

-   缺点

    没有提供Octopress内所有的功能，需要自己完善，但是难度不是很大。

## 最终方案

在尝试使用 `Jekyll` 之后，最终决定使用 `Middleman`。

-   使用 `middleman-blog` 作为博客引擎;
-   使用 `middleman-syntax` 高亮语法;
-   使用 `middleman-deploy` 快速部署，增强国内用户体验部署移到 [Gitcafe][];
-   原有`Octopress`使用了分类列表，`middleman-blog` 不支持分类，所有使用了标签云;
-   使用 [Bootstrap][] 作为CSS框架，重新设计了UI，支持手机用户访问;
-   每个页面支持 QRcode，支持微信扫一扫分享;
-   博文页面支持 [百度分享][baidushare];
-   移植了 `include_code` 功能。`Octopress`中是使用 `liquid` 来实现的，移植后的代码是直接使用ruby代码来实现的，所以需要把文件名加上 `.erb` 作为后缀。

```ruby
require 'pathname'

class IncludeCode < Middleman::Extension
  def initialize(app, options_hash={}, &block)
    super

    app.set :code_dir, 'downloads/code'
  end

  helpers do
    def include_code(filename, title: nil, lang: nil)
      code_path = Pathname.new( __FILE__ + "../../../source/#{code_dir}/").expand_path
      file = code_path + filename
      filetype = lang

      if File.symlink?(code_path)
        return "Code directory '#{code_path}' cannot be a symlink"
      end

      unless file.file?
        return "File #{file} could not be found"
      end

      Dir.chdir(code_path) do
        code = file.read
        filetype = file.extname.sub('.','') if filetype.nil?
        title = title ? "#{title} (#{file.basename})" : file.basename
        url = "/#{code_dir}/#{filename}"
        source = "<figure class='code'><figcaption><span>#{title}</span> <a href='#{url}'>源码</a></figcaption>"
        source += "\n\n``` #{filetype}\n"
        source += code
        source += "\n```\n"
        source += "</firgure>"
      end
    end
  end
end

::Middleman::Extensions.register(:include_code, IncludeCode)
```

## TODO

-   移植其他代码，比如显示gist
-   首页单独设计

[blogging]:   /blog/2012/04/21/install-octopress-to-write-blogs-and-deploy-on-github-dot-com/
[Octopress]:  http://octopress.org
[Jekyll]:     http://jekyllrb.com
[Yeoman]:     http://yeoman.io
[Middleman]:  http://middlemanapp.com
[Gitcafe]:    http://gitcafe.com
[Bootstrap]:  http://getbootstrap.com
[baidushare]: http://share.baidu.com
