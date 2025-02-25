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
  jquerify
  page.execute_script %Q{
    jQuery('iframe').attr('name', '#{name}');
  }
end

def jquerify
  page.execute_script %Q{
    var jq = document.createElement('script');
    jq.src = "http://code.jquery.com/jquery-latest.min.js";
    document.getElementsByTagName('head')[0].appendChild(jq);
  }
  # wait to load jquery
  sleep 2
end

def brick
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
brick
