---
title: 'Dokku - Your privatr PAAS platform'
date: 2020-08-21 15:38:55
tags: ['Docker', 'Heroku', 'PAAS', 'Deployment']
---


# Dokku

Your private PaaS platform

https://github.com/dokku/dokku
http://dokku.viewdocs.io/dokku/

---

## Highlights

- Heroku like
- Push to deployment
- Zero downtime deployment
- Ecosystem including plugins
- Github starts ~20k

---

<!-- more -->

## Installation

    # for debian systems, installs Dokku via apt-get
    wget https://raw.githubusercontent.com/dokku/dokku/v0.21.4/bootstrap.sh;
    sudo DOKKU_TAG=v0.21.4 bash bootstrap.sh

    # or installed by Docker
    docker run \
    --env DOKKU_HOSTNAME=dokku.me \
    --name dokku \
    --publish 3022:22 \
    --publish 8080:80 \
    --publish 8443:443 \
    --volume ~/dokku:/mnt/dokku \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    dokku/dokku:0.21.4


<!-- ---

## setup ssh config

Add ssh config for dokku.em to your ~/.ssh/config

    Host dokku.me
      Hostname 127.0.0.1
      User root
      Port 3022

-->

---

## Setup your app

    # on the Dokku host
    # create an app
    dokku apps:create ruby-getting-started

    # install the postgres plugin
    # plugin installation requires root, hence the user change
    dokku plugin:install https://github.com/dokku/dokku-postgres.git

    # create a postgres service with the name railsdatabase
    dokku postgres:create railsdatabase

    # each official datastore offers a `link` method to link a service to any application
    dokku postgres:link railsdatabase ruby-getting-started


---


## Deployment

    # from your local machine
    # SSH access to github must be enabled on this host
    git clone https://github.com/heroku/ruby-getting-started

    cd ruby-getting-started
    git remote add dokku dokku@dokku.me:ruby-getting-started
    git push dokku master



----

## Add user keys

fatal: 'ruby-getting-started' does not appear to be a git repository
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.


    cat ~/.ssh/id_rsa.pub | docker exec -i dokku dokku ssh-keys:add ryan


---

## SSL - Let's Encrypt

    dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

    dokku config:set --no-restart myapp DOKKU_LETSENCRYPT_EMAIL=your@email.tld

    dokku letsencrypt myapp
    dokku letsencrypt:auto-renew myapp

https://github.com/dokku/dokku-letsencrypt

---

## Verification

<image src='/images/blog/dokku.png'>

---


## References

http://dokku.viewdocs.io/dokku/deployment/application-deployment/

http://dokku.viewdocs.io/dokku/getting-started/install/docker/

http://dokku.viewdocs.io/dokku/deployment/user-management/


---

## The end

Thanks for your listening!
