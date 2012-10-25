---
layout: post
title: "rails开发用 vimfiles 配置"
date: 2012-07-05 09:41
comments: true
categories: [rails, vim]
---

看到很多朋友在烦编辑器的事，就像自己刚开始的时候一样。 我还是选择了vim, 就是喜欢他可以配置到自己喜欢的样子， 不知道你喜欢不喜欢我的配置，但是如果你着急上手，试试我的。

<!-- more -->

虽然只在ubuntu测试过，但是应该在别的系统下也可以用

## 特点

* 单条命令完成安装，免除配置痛苦
* vim插件不包含在repo里，支持一个命令更新所有vimplugins，免除更新插件之苦

## 包含插件

* vundle, vim插件管理器， `:BundleInstall!` 更新所有插件
* rails 必须的
* NERDTree 树形文件管理器 `F7` / `F6` 当前文件文件夹
* NERDComment 注释用` \cc`  / ` \c<space>`
* delimitMate 自动补全右括号
* zencoding HTML垒码利器 `<c-y>,`
* tabular 代码美化。 按 `=` 等对齐 `\a=`， 按 `=>` 对齐 `\a>`
* ~~taglist 标签列表~~ tagbar 标签列表 `F8`
* ctrlp 文件查找 `<c-p>`
* bufExplorer 缓冲列表 `<c-k>`
* preview markdown文件编译结果查看 `\P`
* fugitive 超强大GIT代码仓库查询工具
  * 查状态 `:Gstatus`
  * 查异同 `:Gdiff`
  * 搜pattern `:Ggrep`, 替代ack
  * 查log `:Glog`
  * 打开Github上该文件 `:Gbrowse`
  * 说不完...
* snippets
* 语法支持
  * less, haml
  * markdown
  * sass, scss
  * coffee-script
  * css 文件中颜色color, background-color 自动显示为背景色 （需gvim）
* 配色方案
  * solarized
  * vim-github-colorscheme
  * backboard

## vimrc DIY

* 当前行,列高亮
* `F3` 搜索， `alt-F3` 替换 文件中所有当前光标下文字
* `F4` 插入模式时 切换粘帖模式， 普通模式时 切换 行号

你觉得还少了什么？

最后vim英文帮助看着吃力的话你可以下载VIM的中文说明，那就完美了
[vim中文帮助][vimcdoc]

## Screenshots

![vim-gui][screenshot]

repo 在这里 <https://github.com/wongyouth/vimfiles>

[vimcdoc]: http://vimcdoc.sourceforge.net/
[screenshot]: http://pic.yupoo.com/sinaweibo1332356097/C5k2LdP9/medish.jpg
