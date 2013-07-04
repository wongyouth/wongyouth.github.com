---
layout: post
title: "git revisions"
date: 2013-07-03 16:01
comments: true
categories: git
---

这篇博文记录Git使用中比较中级的技巧，不太容易记住。

先来看一段代码：

    # Dummy repository
    $ git log --oneline
    77bc990 Third commit
    25d4fc4 Second commit
    f0faab6 First commit
    $ git log --oneline HEAD^
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

那么如果要表示第二代父节点的第10代祖先的第2个父节点如何表示呢

    HEAD^2~10^2


再来看第二段代码:

    $ git checkout -b other f0faab6
    Switched to a new branch 'other'
    $ touch file
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

比较之前的代码，可以看出来结果与前后关系相同，两者的履历都会显示
