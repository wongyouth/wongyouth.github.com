---
layout: post
title: "use chef for automating infrastructure setup"
date: 2013-11-22 23:55
comments: true
categories: ruby
---

Blow is the memo to automate infrastructure setup for rails environment.

# prepare vagrant

Vagrant can be used to test script since we need a clean system to test our script.

install VirtualBox
install Vagrant

## Vargrant file

{% include_code Vagrantfile lang:ruby %}

## common command

    # setup 
    vagrant up
    vagrant destroy

    vagrant suspend
    vagrant resume

    # setup hostname
    vagrant ssh-config --host chef_rails >> ~/.ssh/config

# Use Chef

    # install tools
    gem install berkshelf knife-solo

    # create a new chef kithen
    knife solo init chef-rails
    cd chef-rails

    # install chef on target server
    knife solo bootstrap vagrant@chef_rails

## Edit nodes/chef_rails.json to change the behavior of chef

{% include_code chef_rails.json %}

In this example above, we install `build-essential`, `git`, `rbenv`, and setup ruby 2.0.0-p353 as the default ruby version.
