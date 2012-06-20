---
layout: post
title: "tmall砸金蛋活动脚本"
date: 2012-06-18 19:32
comments: true
categories: ruby
---

今天淘宝在砸猫猫，砸金蛋对抗京东店庆日。砸金蛋让人砸到手酸啊。
于是乎写个脚本砸...

<!-- more -->

今天淘宝在砸猫猫，砸金蛋对抗京东店庆日。砸金蛋让人砸到手酸啊。
于是就写个脚本砸，虽然机会太微妙，不过看着自动砸挺开心哈。
现在活动都过去了，放出来应该不会危害什么了吧。

运行环境 ruby

    gem install capybara # install capybara
    ruby zha.rb # zha.rb脚本

``` ruby zha.rb
# encoding: utf-8
#
# 淘宝砸金蛋脚本
# 当前目录建立 tmall 文件放入帐号:密码，分号隔开
#
# mailto wongyouth@gmail.com
# blog http://wongyouth.github.com

require 'rubygems'
require 'capybara'
require 'capybara/dsl'
include Capybara::DSL

Capybara.default_driver = :selenium
Capybara.app_host = 'http://www.tmall.com'

def login
  username, password = IO.read('tmall').split(':')

  visit('http://login.tmall.com')

  setup_frame('loginframe')
  within_frame('loginframe') do
    fill_in 'TPL_username', :with => username
    fill_in 'TPL_password', :with => password
    click_button '登录'
  end
rescue => e
  puts e
end

def setup_frame(name)
  setup_jquery
  page.execute_script %Q{
    jQuery('iframe').attr('name', '#{name}');
  }
end

def setup_jquery
  page.execute_script %Q{
    var jq = document.createElement('script');
    jq.src = "http://code.jquery.com/jquery-latest.min.js";
    document.getElementsByTagName('head')[0].appendChild(jq);
  }
  # wait to load jquery
  sleep 2
end

def zha
  visit('/')
  10000.downto(1).each do
    find('#J_Vol_Brick_Btn').click
    sleep 1
  end
rescue
  sleep 5
  retry
end

login
zha
```

