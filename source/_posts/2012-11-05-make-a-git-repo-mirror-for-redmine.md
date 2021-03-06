---
layout: post
title: "Redmine用Git repo镜像脚本"
date: 2012-11-05 14:11
comments: true
categories: Git
tags: [Redmine, Git, 项目管理]
topic: 技术
---

一般我用[git][]来管理代码，后台用[gitolite][]，[redmine][]来管理项目，redmine中可以结合git来参看git提交信息时，非常有用。

<!-- more -->

以下代码参照了<http://blog.buginception.com/blog/2012/04/02/redmine-use-git-code-review>
{% include_code 'make-mirror.sh' %}

使用时需要用root权限

    sudo sh make-mirror.sh <REPO-NAME> # REPO-NAME 中不带.git后缀

如果不需要特别强大的项目管理功能，可以用[gitlabhq][]，这是一个类似[github][]的代码管理应用，支持fork，pull request功能，非常实用，选择哪个用来管理也就见仁见智了。

[git]: http://git-scm.com
[redmine]: http://redmine.org
[github]: https://github.com
[gitolite]: https://github.com/sitaramc/gitolite
[gitlabhq]: https://github.com/gitlabhq/gitlabhq
