---
layout: post
title: "用octopress来写博客并发布到Github上"
date: 2012-04-21 20:54
comments: true
categories: [Blog, Server]
tags: [博客]
---

用过不少博客，MSN spaces，blogger.com，myspace, wordpress，搜狐，总是觉得少了点自由发挥的空间。直到现有有了[octopress][]，就像我这个博客一样，这才是咱程序猿该有的！

<!-- more -->

1. 安装
2. 配置
3. 发布
4. 写第一个博文


## 安装

``` sh
#Install octopress
git clone git://github.com/imathis/octopress.git octopress
cd octopress
bundler install
rake install
```

## 配置

你要先有个github.com的帐号，如果没有赶快注册吧。
注册好后新建一个软件仓库 <https://github.com/new> ，注意仓库名称要以下这种格式哦`yourname.github.com`，这样代码发布后自动这个url就可以访问了。

``` sh
rake setup_github_pages
```

这个命令主要做以下的操作

1. 问你github上的url。 我的是 git@github.com:wongyouth/wongyouth.github.com.git
2. 将原始的`imathis/octopress`远端仓库`origin`名称改为`octopress`
3. 把你输入的url作为远端仓库名`origin`
4. 把当前目录从分支`master`切换到`source`
5. 把当前目录与`origin`的仓库关联，能默认push到github中
6. 配置`_deploy`目录作为github仓库的`master`分支

要做的就是把原始的blog代码放在`source`分支中，当要发布时会自动生成发布代码到`_deploy`目录下以`master`分支更新到github上。github会以`master`中的代码作为blog的原始代码。

## 发布

``` sh
# Deploy blog
rake generate
rake deploy
```

当你发布之后，你就可以到 <http://yourname.github.com> 上看到你的博客了，是不是很酷呢。

## 写第一个博文

``` sh
# Create first post
rake new_post['first post']
```

引号里面是博文的标题，这个命令会在`source/_posts`下面生成一个markdown为后缀的文件，我们要做的就是编辑这个文件的内容，然后

``` sh
#Start a local server for preview
rake preview
```

会在本地启动sinatra服务，用浏览器打开 <http://localhost:4000> 就可以看到效果了。如果都没有问题就可以发布了。

有时候写了一半的博文想要先留为草稿放到服务器但是不发布这样情况。
我们可以在单独的这篇博文开头的yaml里面追加设置

    published: false

这样deploy的时候就不会发布了。

## 其他

你可以仔细查看以下三个文件，如果觉得有必要就按照自己的配置修改。

1.  \_config.yml
2.  config.rb
3.  config.ru

\_config.yml中有关联其他一些社区的配置，比如github.com帐号，facebook帐号等。我认为比较有用的是[disqus][]的评论帐号。到disqus注册一下，然后设置好`disqus_short_name`这样你的博客就有了评论功能了，而不是你一个人在唱独角戏了。

## 在其他电脑里面同步时的操作

    git clone git@github.com:wongyouth/wongyouth.github.com.git
    cd wongyouth.github.com
    git checkout source
    git clone git@github.com:wongyouth/wongyouth.github.com.git _deploy

`_deploy`目录是用来与远程代码库同步的目录，所以我们要把它checkout出来预先做好关联

make a new post and something else ...

    rake generate
    rake deploy

[octopress]: http://octopress.org/
[github pages]: http://pages.github.com/
[disqus]: http://disqus.com/
