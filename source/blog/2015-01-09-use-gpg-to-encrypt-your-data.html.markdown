---
title: 使用 GPG 加密数据
date: 2015-01-09 16:18 +0800
tags: ["数据", "安全"]
keywords: ["安全", "Security"]
topic: "技术"
---

什么是 `GPG` 加密，以下来自百度的解释

> PGP加密系统是采用公开密钥加密与传统密钥加密相结合的一种加密技术。
> 它使用一对数学上相关的钥匙，其中一个（公钥）用来加密信息，另一个（私钥）用来解密信息。
> PGP采用的传统加密技术部分所使用的密钥称为“会话密钥”（sek）。
> 每次使用时，PGP都随机产生一个128位的IDEA会话密钥，用来加密报文。
> 公开密钥加密技术中的公钥和私钥则用来加密会话密钥，并通过它间接地保护报文内容。

<!-- more -->

## 1. 生成个人 gpg 密钥

```
gpg --gen-key

# 根据输入信息生成密钥

jxb@jxbtest:~$ gpg --gen-key
gpg (GnuPG) 1.4.11; Copyright (C) 2010 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
Your selection? 1
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048)
Requested keysize is 2048 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0)
Key does not expire at all
Is this correct? (y/N) y

You need a user ID to identify your key; the software constructs the user ID
from the Real Name, Comment and Email Address in this form:
    "Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"

Real name: Ryan Wang
Email address: test@gmail.com
Comment:
You selected this USER-ID:
    "Ryan Wang <test@gmail.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o
You need a Passphrase to protect your secret key.

```

## 2. 密钥操作

#### 查看公钥

gpg --list-keys

#### 查看密钥

gpg --list-secret-keys

#### 导出公钥

gpg -a --export [Email] > public.key

#### 导出密钥

gpg -a --export-secret-key [Email] > private.key


#### 导入公钥

gpg --import public.key

#### 导入密钥

gpg --allow-secret-key-import --import private.key


#### 删除公钥

gpg --delete-key "User Name"

#### 删除密钥

gpg --delete-secret-key "User Name"

## 3. 加密解密

1). 加密

在发送方加密文件。 必须先导入发送者的密钥，接受者的公钥

gpg -e -u "Sender User" -r "Receiver User" mydata.tgz

2). 解密

在接收方解密文件。必须先导入接受者的密钥

gpg -d -o mydata.tgz mydata.tgz.gpg

## 延伸阅读

* http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/gpg-cs.html
