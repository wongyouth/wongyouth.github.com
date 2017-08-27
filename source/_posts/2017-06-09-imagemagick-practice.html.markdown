---
title: 使用 ImageMagick 处理图片小记
date: 2017-06-09 20:38 +0800
tags: ['ImageMagick']
keywords: ['image', 'convert']
topics: 'Image processing'
---

[ImageMagick](http://imagemagick.org) 是强大的图片处理工具，
可以用来处理图转换，旋转，放大，缩小，模糊等很多处理。

本篇准备用一个案例来说明 `ImageMagick` 的用法。

## 需求描述

* 给定一张底图图片，白色背景，黑色散列点小黑子，大小为6400x6400
* 要求把这张图片8x8的切成64小块，打乱排序后重新得到一张图片。
* 在每张小图片底部叠加一张中间有序号的图片，用于确认图片顺序。

## 解题思路

1. 去掉白色背景改为透明，叠加后可显示底下图片
2. 复制一张同样大小的白色图片
3. 切分白色图片为8x8大小的图片
4. 在每张小图片中间添加红色序号文字，依次为00 ~ 63
5. 合并小图片为一张大图片
6. 叠加透明图片到有序号的图片上
7. 切分叠加后的图片为 8x8 的64张图片
8. 合并打乱顺序后的小图片为一张图片

以下为每个处理的命令

假设 图片名为 base.png

1. 去掉白色背景改为透明，叠加后可显示底下图片

        convert base.png -transparent white base.nobg.png

2. 复制一张同样大小的白色图片

        # 用白色填充全部范围
        convert base.png -fill white -draw 'rectangle 0,0 6400,6400' base.white.png

3. 切分白色图片为8x8大小的图片

        # +repage 用于消除虚拟画布大小
        convert base.white.png -crop 12.5%x12.5% +repage sp-%02d.png

4. 在每张小图片中间添加红色序号文字，依次为00 ~ 63

        for f in sp-*.png
        do
          no=${f:3:2}
          convert $f -gravity center -fill red -pointsize 30 -annotate 0 $no label-${no}.png
        done
        rm sp-*.png

5. 合并小图片为一张大图片

        # 增加 -goemetry +0+0 参数是为了不添加padding
        # -tile 8x8 指定 8行8列
        montage label-*.png -goemetry +0+0 -tile 8x8 concat.label.png
        rm label-*.png

6. 叠加透明图片到有序号的图片上

        composite base.nobg.png -gravity center concat.label.png base.label.png

7. 切分叠加后的图片为 8x8 的64张图片

        convert base.label.png -crop 12.5%x12.5% +repage sp-%02d.png

8. 合并打乱顺序后的小图片为一张图片

        montage `ls sp-*.png | ruby -e 'puts STDIN.readlines.shuffle'` -goemetry +0+0 -tile 8x8 out.png
        rm sp-*.png

        # shell 没有可以打乱顺序的命令，这里使用了ruby的一行代码来搞定

