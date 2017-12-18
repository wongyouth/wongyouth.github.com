---
title: 深度学习笔记
date: 2017-12-18 15:46:47
tags: 技术
---

深度学习笔记。

## 公式

h(x) = XW + b


方阵尺寸
X = (100,784),  batch size: 100, 特征尺寸： 784
W = (784,10),   特征尺寸，输出个数
b = (10,1),     输出个数，1
h = (100,10)    batch size, 输出个数

## 分类方法

softmax，确定图像是属于10个数字中的哪一个

## 激活函数

tanh, sigmoid, relu，深度神经网络中推荐使用 relu

输出值范围
* tanh
  -1 ~ 1
* sigmoid
  0 ~ 1,  1 / (1 + e^-x)
* relu
  0 ~ 正无穷, max(0, x)

## Loss function

交叉熵 Cross entropy:
        - reduce\_sum(Y\_ * log(Y))

## 训练算法

梯度下降算法： GSD
步长： 0.01, 太大速度快但可能取不到最精确值，太小则速度慢

## 最大池化

max pooling， 比如 5x5 的池中取最大一个值作为输出值

## strides 步长

步长的意义在于缩小特征尺寸。比如输入 28x28 的方阵如果使用 2x2 的步长，则输出的方阵缩小为 14x14

## 输入通道，输出通道

在建立深度学习的层中，一般是缩小特征尺寸，增大通道大小。整个特征个数是呈现变小的趋势。

<pre>
No.     方阵              kernel 和通道       步长
1       28x28x1           5x5,1,4             1x1                                             
2       28x28x4           4x4,4,8             2x2                                             
3       14x14x8           4x4,8,12            2x2                                             
4       7x7x12            全连接                                                              
5       200               softmax                                                             
6       10                用于10个数字                                                        
</pre>

## 如何确定通道大小

比如手写的数字 4 个通道是比较小的，需要增加到6个，是个经验值

<pre>
No.     方阵              kernel 和通道       步长
1       28x28x1           5x5,1,6             1x1                                             
2       28x28x6           4x4,6,12            2x2                                             
3       14x14x12          4x4,12,24           2x2                                             
4       7x7x24            全连接                                                              
5       200               softmax                                                             
6       10                用于10个数字                                                        
</pre>

## 例子

https://www.tuicool.com/articles/vieuIbi
https://www.tuicool.com/articles/bayI7ne
