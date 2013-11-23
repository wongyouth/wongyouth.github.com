---
layout: post
title: "install ruby with readline supported on Mac"
date: 2013-09-26 22:17
comments: true
categories: 
---

Just a memo for installing ruby on Mac OSX with the feature of typing Chinese under ruby console.

    brew install readline ruby-build
    RUBY_CONFIGURE_OPTS=--with-readline-dir=`brew --prefix readline` rbenv install 1.9.3-p286

or to use pure Ruby readline

    group :development do
      gem 'rb_readline'
    end

ref: https://github.com/guard/guard/wiki/Add-Readline-support-to-Ruby-on-Mac-OS-X
