---
layout: post
title: "Git分支常用操作"
date: 2012-04-26 10:55
comments: true
categories: [Git]
tags: [Git]
topic: 技术
---

在这里我列举了一些日常Git操作时用到的`branch`分支命令。

<!-- more -->

## 生成一个分支，名字为issue1

    git branch issue1

## 切换到一个分支issue1

    git checkout issue1

## 生成一个本地分支并切换到它

    git checkout -b issue1

## 修改后提交

    git commit -am 'fix issue1'

## 切换到主分支

    git checkout master

## 合并issue1到主分支

    git merge issue1

## 递交到远程

    git push origin issue1

## 递交master到远程分支issue1

    git push origin master:issue1

## 复制远程分支到本地

    git checkout -b issue1 origin/issue1

## 删除远程分支

    git push origin :issue1

## 删除本地分支

    git branch -d issue1

## 关联当前分支与一个远程分支(> git 1.8)

    git branch -u origin/foo

## 关联指定分支与一个远程分支

    git branch -u origin/foo bar

## 无需切换更新其他分支

基于多人合作时，当要发合并请求之前，需要更新develop的最新代码到自己的工作分支，此时一般的操作需要4步：

    git checkout develop
    git fetch --rebase
    git checkout work-branch
    git rebase develop

如果不需要切换分支就能更新 develop 代码的话，就能把前3步合并为1步操作：

    git fetch origin develop:develop
    git rebase develop
