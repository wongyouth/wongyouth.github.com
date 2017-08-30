---
layout: post
title: "解决Git stash冲突问题"
date: 2014-03-28 15:39
comments: true
categories: Git
tags: [Git]
topic: 技术
---

本篇博文分享一下`git stash`以及他的实际使用技巧

* Git stash 是什么，他的使用场景，以及如何来使用
* Git stash pop 时冲突的解决方法

<!-- more -->

## 首先了解下什么是 Git stash

考虑这么一个场景，我修改了一些代码用来支持新功能，因为还在进行中所以暂时不想递交代码。
此时发现线上版本出了问题需要在本地查错。这样我需要临时保存修改的文件，然后取出线上版本到工作目录。
此时我们有几种方法可以做

1. 复制修改的代码到备份目录，`reset` 旧代码，`check out`出线上版本。

```sh
cp file /backup/dir
git reset --hard head # 恢复head代码，抛弃工作区的修改
git checkout master

# do your job

# when your job's done
git checkout feature_branch
cp /backup/dir file
```

2. 递交现在的代码（即使还没有做完），取出线上版本，完工后回退临时递交

```sh
git commit -am 'work in process'
git checkout master

# do your job

# when your job's done
git checkout feature_branch
git reset head~
```

Git 自带了对于前一种方案的支持，这就是`stash`命令。我们来看下用stash怎么做。

```sh
git stash
git checkout master

# do your job

# when your job's done
git checkout feature_branch
git stash pop
```

## Git stash 冲突的解决办法

比较一下之后看起来好像没有改变多少，我这里是假设只有修改过一个文件的情况，如果修改的文件比较多，
就需要你找出哪些文件是要备份的，每次来罗列这些文件名是个很吃力的事情，还是让机器来做这些枯燥的工作吧。

说完`stash`的功用，回到正题看看如何解决使用stash时会碰到的冲突问题。
现在考虑另一个场景，假设在工作区修改了一些代码用来支持新功能，因为还在完善中所以暂时不想递交代码。
此时发现同事递交了新功能的代码，而我需要并入他的代码来完成工作。

    git stash
    git pull --all
    git rebase college_branch
    git stash pop

如果同事递交的代码与我修改临时保存到stash中的没有冲突，那么事情完美完工，
如果同事与我修改的代码有冲突，最后一个命令将报 `Merge conflict` 错。
Git 没有提供强制pop出来的功能。我们看下这个时候能做什么。

    git stash show -p | git apply && git stash drop

因为经常会要碰到这种情况，我们把它设置为别名来用

    git config --global alias.unstash '!git stash show -p | git apply && git stash drop'

这样就可以调用 `git unstash` 来使用了。这算是git的一个高级用法，Git可以自定义命令。

