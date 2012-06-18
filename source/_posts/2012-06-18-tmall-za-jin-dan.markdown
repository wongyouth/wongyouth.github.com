---
layout: post
title: "tmall砸金蛋活动脚本"
date: 2012-06-18 19:32
comments: true
categories: 
---

今天淘宝在砸猫猫，砸金蛋对抗京东店庆日。砸金蛋让人砸到手酸啊。
于是就写个脚本砸，虽然机会太微妙，不过看着自动砸挺开心哈。

运行环境 ruby

    gem install capybara # install capybara
    ruby zha.rb # zha.rb在下方 

```ruby
# encoding: utf-8
#
# 淘宝砸金蛋脚本
# 当前目录建立 tmall 文件放入帐号:密码，分号隔开
#
# email to wongyouth@gmail.com
# github blog http://wongyouth.github.com

require 'rubygems'
require 'capybara'
require 'capybara/dsl'
include Capybara::DSL

Capybara.default_driver = :selenium
Capybara.app_host = 'http://www.tmall.com'

def login
  username, password = get_userinfo

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

def get_userinfo
  info = File.open(File.expand_path('../tmall', __FILE__), 'r') {|f| f.read }
  info.split(':')
end

def setup_frame(name)
  setup_jquery
  page.execute_script %Q{
    jQuery('iframe').attr('name', '#{name}');
    jQuery('iframe').attr('id', '#{name}');
  }
end

def setup_jquery
  page.execute_script %Q{
    var jq = document.createElement('script');
    jq.src = "http://code.jquery.com/jquery-latest.min.js";
    document.getElementsByTagName('head')[0].appendChild(jq);
  }
  sleep 3
  page.execute_script %Q{
    jQuery.noConflict();
  }

end

def zha
  visit('/')
  10000.downto(1).each do
    btn = find('#J_Vol_Brick_Btn')
    btn.click
    sleep 0.5
  end
rescue => e
  puts e
  retry
end

login
zha
```

