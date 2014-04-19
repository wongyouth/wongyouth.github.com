---
layout: post
title: "Git中如何退回到旧版本"
date: 2012-10-25 09:34
comments: true
categories: Git
tags: [Git]
---

使用Git用来管理版本时，有时候会有不小心递交了错误的代码，想回退到旧的版本中的场景。让我们看看在Git中应该如何正确操作。

<!-- more -->

先来说一下如何保存当前工作区的修改。
## 保留当前修改

    git stash                 # 保留当前工作区的修改
    git stash pop             # 恢复保存的修改到工作区

## 递交的代码没有push到远程的仓库时

    git reset --mixed REVISION # 返回到旧版本REVISION，版本间的差异会到工作区
    git reset --soft REVISION  # 返回到旧版本REVISION，版本间的差异会到index
    git reset --hard REVISION  # 返回到旧版本REVISION，包括当前工作区里的修改

## 递交的代码已经push到远程的仓库，协同者未同步时

如果递交的代码已经push到了远程，我们不能用上面的方法，因为上面的方法只是让你的本地状态变成一个没有同步远程的协同者的状态相似。你下次pull远程时会把远程代码库的更新取回来。
所以我们必须要把远程的代码也返回到旧版。

    remote$ git config receive.denyCurrentBranch ignore # 登录到远程代码库，设置取消拒绝当前分支，否则以下的操作无法删除远程master分支

    local$ git push origin :master       # 删除远程master分支
    local$ git reset --hard REVISION     # return to old revision
    local$ git push origin master:master # 递交旧版到远程master分支

或者回到旧版再强制推到远程

    local$ git reset --hard REVISION
    local$ git push --force

## 递交的代码已经更新到协同者的代码库时

这个时候让每个协同者返回旧版不是一个好的选择项时，我们只有把旧代码取出，加到当前版之上，push到远程，再让协同者同步。


