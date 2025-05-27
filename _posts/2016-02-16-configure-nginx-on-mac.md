---
layout: post
title: Improving Nginx's configuration for Mac OSX
feature-img: "assets/img/pexels/code-and-glass.jpg"
tags: [osx, nginx]
---

If you're storing all your configurations for Nginx servers on your Mac into single file, then probably you can do it far better and efficient then before.

Take a look on this small article how to improve your server configurations by separating them in directories called `sites-enables` and `sites-available`. If you're familiar with Apache server, those hanges will be done in exactly the same manner.

### Create desired directories

We'll start from creating desired directories where we'll store our configs.

> Default Nginx installation did not provide those directories, but in few quick steps we'll achieve this, that you can benefit from instantly. (Some example code snippet comes from [this gist][1]).

```sh
mkdir -p /usr/local/etc/nginx/sites-{enabled,available}
cd /usr/local/etc/nginx/sites-enabled
ln -s ../sites-available/default.conf
ln -s ../sites-available/default-ssl.conf
```

But now, you require information about important files and locations:

-   _nginx.conf_ to `/usr/local/etc/nginx/`
-   _default.conf_ and _default-ssl.conf_ to `/usr/local/etc/nginx/sites-available`
-   homebrew.mxcl.nginx.plist to `/Library/LaunchDaemons/`

> For log files you can use `/usr/local/var/log/nginx` directory.

For example, if you have frontend configuration for your static blog, name it like `blog.loc.conf`.

### Improve nginx configuration file

If you used Linux before, then you might feel more comfortable and familiar with below configuration (it tries to be very same as Linux's version of Nginx), but till day of writing this article the default installation process for macs (via `brew`) not creating `sites-available` nor `sites-enabled` directories.

The most important part of the snippet below are last two `include` methods. Those lines enabling `sites-enabled` directory to observe every single file into it. So now, you can just create symlink from `sites-available` in `sites-enabled`, then do quick reset of your Nginx server and job done.

Same pattern works also when you need to disable configuration or switch it with different one (i.e: for maintenance mode).

For first one you just need to remove symlink from `sites-enabled` and reload Nginx. But the most important part you're not loosing real file with configuration, so that you can reuse it later.

The second situation with switching configurations is only about create symlinks and override current one.

> Note: If you copy whole configuration below, you have to create log directory, if it doesn't exist yet. To do so, execute this: `sudo mkdir -p /Library/Logs/nginx`

```nginx
# Configuration for nginx.conf

user www-data staff;
worker_processes 1;

error_log /Library/Logs/nginx/error.log;

events {
  worker_connections  1024;
}

http {
  include mime.types;
  default_type application/octet-stream;
  log_format main   '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log /Library/Logs/nginx/access.log  main;
  sendfile on;
  keepalive_timeout 65;
  index index.html index.php;

  upstream www-upstream-pool{
      server unix:/tmp/php-fpm.sock;
  }

  include /etc/nginx/conf.d/*.conf;
  include /usr/local/etc/nginx/sites-enabled/*.conf;
}
```

### Good practices

-   When creating a symlink for Nginx use absolute paths instead of relative ones
-   Develop your own naming schema for configuration files and stick to it. This is important, if you need to serve multiple configurations (i.e: domain called `cluster.example.com` could be named `cluster.example.com.conf`)

[1]: https://gist.github.com/jimothyGator/5436538
