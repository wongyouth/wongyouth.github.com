---
layout: post
title: "Git revisions"
date: 2013-07-03 16:01
comments: true
categories: Git
tags: [Git]
topic: 技术
---

这篇博文将使用一些代码来讲述Git使用中比较中级的技巧。

* Git中 ^ 与 ~ 的区别
* 假设从一个分支衍生出了另一个分支，如何取得该分支的所有递交列表

<!-- more -->

## Git中 ^ 与 ~ 的区别

我们看Git履历会用到`git log head~2`，`git log head^2`，可能搞不清楚这两者之间有什么区别。
先来看一段代码：

    # Dummy repository
    $ git log --oneline
    77bc990 Third commit
    25d4fc4 Second commit
    f0faab6 First commit

    $ git log --oneline HEAD~
    25d4fc4 Second commit
    f0faab6 First commit

    $ git log --oneline HEAD^
    25d4fc4 Second commit
    f0faab6 First commit

    $ git log --oneline HEAD^^
    f0faab6 First commit

    $ git log --oneline HEAD^2
    fatal: ambiguous argument 'HEAD^2': unknown revision or path not in the working tree.

从这里可以看出来`^` 与 `~` 是有区别的

`HEAD^2` 与 `HEAD~2` 的区别

`HEAD^2` 表示的是当前HEAD的第二个父节点
`HEAD~2` 表示的是当前HEAD的第一个父节点的第一个父节点

记住`~`永远在第一个父节点上回溯。

什么是第二个父节点？通过命令`git log --graph`我们看下有代码Merge后的日志

<pre>
* abe6b95 add post for speed-spider (Ryan Wang, 10 months ago)
* ad57324 add copyright for seo (Ryan Wang, 11 months ago)
*   302f545 update octopress (Ryan Wang, 11 months ago)
|\
| * 09558c6 Sinatra now correctly returns code 404 when a page is not found. Closes #1198 (Brandon Mathis, 12 months ago)
| * 1bd2b62 Added support for deploying to github.io (Brandon Mathis, 12 months ago)
* 9c80295 move CNAME to source/ (Ryan Wang, 11 months ago)
</pre>

* HEAD 是最后一个递交，也就是`abe6b95`
* HEAD的父节点只有一个，所以也就是 `ad57324`，记为 HEAD~ 或者 HEAD^
* `ad57324`的父节点也只有一个，`302f545`，记为 HEAD~2, HEAD~~ 或者 HEAD^^
* `302f545`有两个父节点, 第一个为 `9c80295`, 记为 HEAD~3，第二个父节点 `09558c6`，记为 HEAD~2^2
* `09558c6`有一个父节点 ``，记为 HEAD~2^2~，或者 HEAD~2^2^


那么如果要表示第二代父节点的第10代祖先的第2个父节点如何表示呢

    HEAD^2~10^2


## 假设从一个分支衍生出了另一个分支，如何取得该分支的所有递交列表

    $ git checkout -b other f0faab6
    Switched to a new branch 'other'

    $ #touch file
    $ git add file
    $ git commit -m "Adding file" file

    $ git log --oneline
    1762164 Adding file
    f0faab6 First commit

    $ git log --oneline other..master
    77bc990 Third commit
    25d4fc4 Second commit

    $ git log --oneline master..other
    1762164 Adding file

可以看出 `..` 前后分支对换，结果是不一样的
这段代码的意思是找出在一个分支上有，但是在另一个分支上没有的递交。
其原理是先回溯到两者的共同祖先，然后用这个祖先比较分支，这样就得出来只属于那个分支的递交履历。


再看第三段代码：

    $ git log master...other
    1762164 Adding file
    77bc990 Third commit
    25d4fc4 Second commit

    $ git log other...master
    1762164 Adding file
    77bc990 Third commit
    25d4fc4 Second commit

比较之前的代码，可以看出来结果与前后关系相同，两者的履历都会显示。

