---
layout: post
title: "Git分支常用操作"
date: 2012-04-26 10:55
comments: true
categories: git
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

## 复制远程分支到本地

    git checkout -b issue1 origin/issue1

## 删除远程分支

    git push origin :issue1

## 删除本地分支

    git branch -d issue1

