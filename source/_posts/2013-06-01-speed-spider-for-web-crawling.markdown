---
layout: post
title: "speed spider for web crawling"
date: 2013-06-01 22:30
comments: true
categories: [ruby, rails]
---

## background

Some days ago I wanted to learn some css stuff from a site, I changed some css style to see what it turns to.
After 10 minutes after I got tired when I have to change the source again and again in the browser.
So I googled to find what kind of tools can be used to download files from a site, but I can't find anything satisfied.
So after searched github I found I can do it myself with little work.

Here comes the [SpeedSpider][1], it's A simple and speedy web spider for site pages downloading.

UPDATE:

It turns out `wget` can do all the jobs I wanted except it doest not use threads. So wget way may be slower than SpeedSpider.
You can download bootstrap page with code below.

    wget -m -p -E -k -np http://twitter.github.io/bootstrap

<!--more-->

SpeedSpider was made with below in mind

* download files from a site with a start url
* option for downloading part site obeying a base url, any page not starts with `base_url` will not be downloaded
* assets files like css, js, image and font should be downloaded besides html files, and not obey `base_url` rule
* image file include in css file should be download
* url from site other than the start url should not be downloaded
* download files should be save with the same structure with the origin site

## Installation

install it with rubygem:

    gem install 'speed_spider'

### Usage

    Usage: spider [options] start_url

    options:
        -S, --slient                     slient output
        -D, --dir String                 directory for download files to save to. "download" by default
        -b, --base_url String            any url not starts with base_url will not be saved
        -t, --threads Integer            threads to run for fetching pages, 4 by default
        -u, --user_agent String          words for request header USER_AGENT
        -d, --delay Integer              delay between requests
        -o, --obey_robots_text           obey robots exclustion protocol
        -l, --depth_limit                limit the depth of the crawl
        -r, --redirect_limit Integer     number of times HTTP redirects will be followed
        -a, --accept_cookies             accept cookies from the server and send them back?
        -s, --skip_query_strings         skip any link with a query string? e.g. http://foo.com/?u=user
        -H, --proxy_host String          proxy server hostname
        -P, --proxy_port Integer         proxy server port number
        -T, --read_timeout Integer       HTTP read timeout in seconds
        -V, --version                    Show version

## Examples

    spider http://twitter.github.io/bootstrap/

It will download all files within the same domain as twitter.github.io, and save to download/twitter.github.io/.

    spider -b http://ruby-doc.org/core-2.0/ http://ruby-doc.org/core-2.0/

It will only download urls start with http://ruby-doc.org/core-2.0/, notice assets files like image, css, js, font will not obey base_url rule.

[1]:https://github.com/wongyouth/speed_spider
