---
title: 使用Telnet发送邮件
date: 2017-12-14 13:40:58
tags: 技术
---

最近在写一个发邮件的小程序，经常会碰到邮箱系统报错，但是看了日志也没看出的头绪来。
因为出错信息不详细，或者是信息与真正的错误没啥关联，会被带到沟里去。

其实用 SMTP 服务器的话，都是用 smtp 协议来发邮件，都是文本形式的协议，协议其实挺简单的。

总的来说3个大步骤

1. 建立连接
2. 验证
3. 上传邮件内容

详细来说一下这个过程:

1. HELO <domain> , qq邮箱域名是必须的。

        helo qq.com
        250 smtp.qq.com

2. AUTH  base64编码的用户名，密码，每个单独一行

        auth login

        334 VXNlcm5hbWU6
        aW5mb0BqaWFveHVlYmFuZy5jb20=

        334 UGFzc3dvcmQ6
        xxxxxxxxxxxxxxxxxxxxxxxxxxx

        235 Authentication successful

3. MAIL FROM: <email> 发件人邮箱

        mail from: info@jiaoxuebang.com
        250 Ok

4. RCPT TO: <email> 收件人邮箱

        rcpt to: ryan@jiaoxuebang.com
        250 Ok

5. DATA 邮件数据，包括邮件头部，正文， 以 换行`.`换行 结束

        data
        354 End data with <CR><LF>.<CR><LF>
        subject: test

        test

        .

        250 Ok: queued as

250 显示已经进入队列等待发送了。
