---
title: 使用 chinacity 从国家统计局官网取最新城市数据
date: 2014-06-30 20:09 CST
comments: true
categories: [Ruby]
tags: [Ruby, 数据, 中国城市]
topic: 技术
---

最近项目里需要用到中国城市数据，看了几个Gem，发现数据都不是最新的，遂写了个Gem [chinacity](http://github.com/wongyouth/chinacity) 用来从国家统计局取最新数据。

因为考虑到城市类基础数据一旦开始使用，id与别的数据关联后就比较难再更新数据了，所以就做成只取数据生成文件的简单小工具。

## 功能

* 从国家统计局官网取最新数据。
* 支持导出 JSON，CSV格式
* JSON 数据 兼容 [china_city](https://github.com/saberma/china_city) Gem 的数据格式
* 支持同时导出拼音缩写

## 用法

### 导出JSON格式

    $ chinacity > areas.json

The result looks like

```
{
  "province": [
    {
      "id": "110000",
      "text": "北京市"
    },
    {
      "id": "120000",
      "text": "天津市"
    },
    ...
  ],

  "city": [
    {
      "id": "110100",
      "text": "市辖区"
    },
    {
      "id": "110200",
      "text": "县"
    },
    ...
  ],
  "district": [
    {
      "id": "110101",
      "text": "东城区"
    },
    {
      "id": "110102",
      "text": "西城区"
    },
    ...
  ]
```

### 导出JSON格式，同时输出拼音缩写.

    $ chinacity -s > areas.json

The Result json looks like

```
{
  "province": [
    {
      "id": "110000",
      "text": "北京市",
      "short": "BJS"
    },
    {
      "id": "120000",
      "text": "天津市",
      "short": "TJS"
    },
    {
      "id": "130000",
      "text": "河北省",
      "short": "HBS"
    },
    ...
  ],
  "city": [...],
  "district": [...]
}

```

### 导出 CSV 格式.

    $ chinacity -sc > areas.csv

The result looks like

```
id, 名称, 缩写, 层级
110000, 北京市, BJS, 1
110100, 市辖区, SXQ, 2
110101, 东城区, DCQ, 3
110102, 西城区, XCQ, 3
110105, 朝阳区, ZYQ, 3
...
```

chinacity主页链接 http://github.com/wongyouth/chinacity

