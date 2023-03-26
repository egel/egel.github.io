---
layout: post
title: Setup LAMP server with sample domain
modified: 2015-06-27
category: Development
tags: [apache, mysql, php, domains]
---

Every young IT person will at last faced with the challenge of creating his own website. It could be a simple static site, managed by some static site generator (like [Jekkly](http://jekyllrb.com/), [Octopress](http://octopress.org/), [Pelican](http://docs.getpelican.com) or [some others examples](https://www.staticgen.com/)). But few proud, claim that it's to easy and they would like to try something more complex like basic PHP CMS similar to [Joomla](https://www.joomla.com/), [Wordpress](https://wordpress.org) or even use a professional, enterprise-class frameworks like Laravel, Symfony or Zend.

Whatever they choose, they will need some tools to deal with showing to the whole world their new website project.

In this simple article, I'll show you how to build your own simple (and standard in these days) server configuration based on a LAMP, but those tools can be easily replaced with others technologies. For example, if you're interested in Django you could replace PHP language with more mature Python (of course some setting will vary a bit from content presented in this article, but in the end, setup will be made).

I think this is good, start example to play with :) Enjoy.

> The examples refer to Ubuntu 14.04, but it should also work for other Debian based distros.

### Table of content

-   [Apache 2](#apache)
    -   [Add user to www-data group](#add-user-to-www-data-group)
-   [MySQL](#mysql)
-   [PHP](#php)
-   [PHPMyAdmin](#phpmyadmin)
-   [Common problems](#common-problems)
    -   [Add VirtualHost](#add-virtualhost)
    -   [Creating public_html directory for the user](#creating-public_html-directory-for-the-user)

Good [Polish article](http://www.ubuntu-pomoc.org/instalacja-apache-php5-mysql/) and [English article][article_about_apache2_url].

Let's begin from updating our Debian based system (Ubuntu):

```shell
sudo apt-get update
```

### Apache

Installation Apache 2.4 with its useful dependencies:

```shell
sudo apt-get install apache2 apache2-doc apache2-utils apache2-mpm-worker
```

Then restart the service with:

```shell
sudo service apache2 restart
```

Or also you can use good, old school [daemon][wikipedia-daemon] `sudo /etc/init.d/apache2 restart`.

Now we take a peek at our server's version by writing `apache2 -v` in your console.

Now, if all went well, you could start your web browser with `http://localhost/` to check if "It works!" appears to you :)

> "It works!" page is actually simple `index.html` file stored in `/var/www/html/` directory, but details comes later :)

#### Add user to www-data group

Now we'd like to add your current user (`$USER`) to `www-data` group used by apache server. We will do this to prevent you from some error-access failures like user owner.

To check if your current user belongs to `www-data` group simply do:

```shell
groups $USER
```

Now add existing user to `www-data` group.

```shell
sudo usermod -a -G $USER www-data
```

> **Hint**: Somtimes it is a good practice to check `SERVER_CONFIG_FILE`.
>
>     :::bash
>     $ /usr/sbin/apache2 -V
>     [Tue Nov 08 21:38:06.633874 2016] [core:warn] [pid 8973] AH00111: Config variable ${APACHE_LOCK_DIR} is not defined
>     [Tue Nov 08 21:38:06.633903 2016] [core:warn] [pid 8973] AH00111: Config variable ${APACHE_PID_FILE} is not defined
>     [Tue Nov 08 21:38:06.633910 2016] [core:warn] [pid 8973] AH00111: Config variable ${APACHE_RUN_USER} is not defined
>     [Tue Nov 08 21:38:06.633913 2016] [core:warn] [pid 8973] AH00111: Config variable ${APACHE_RUN_GROUP} is not defined
>     [Tue Nov 08 21:38:06.633920 2016] [core:warn] [pid 8973] AH00111: Config variable ${APACHE_LOG_DIR} is not defined
>     [Tue Nov 08 21:38:06.636829 2016] [core:warn] [pid 8973] AH00111: Config variable ${APACHE_LOG_DIR} is not defined
>     [Tue Nov 08 21:38:06.636921 2016] [core:warn] [pid 8973] AH00111: Config variable ${APACHE_LOG_DIR} is not defined
>     [Tue Nov 08 21:38:06.636927 2016] [core:warn] [pid 8973] AH00111: Config variable ${APACHE_LOG_DIR} is not defined
>     AH00526: Syntax error on line 74 of /etc/apache2/apache2.conf:
>     Invalid Mutex directory in argument file:${APACHE_LOCK_DIR}
>
> To fix that you need to:
>
>     :::bash
>     $ source /etc/apache2/envvars
>     $ /usr/sbin/apache2 -V
>
>     Server version: Apache/2.4.7 (Ubuntu)
>     Server built:   Jul 15 2016 15:34:04
>     Server's Module Magic Number: 20120211:27
>     Server loaded:  APR 1.5.1-dev, APR-UTIL 1.5.3
>     Compiled using: APR 1.5.1-dev, APR-UTIL 1.5.3
>     Architecture:   64-bit
>     Server MPM:     prefork
>       threaded:     no
>         forked:     yes (variable process count)
>     Server compiled with....
>      -D APR_HAS_SENDFILE
>      -D APR_HAS_MMAP
>      -D APR_HAVE_IPV6 (IPv4-mapped addresses enabled)
>      -D APR_USE_SYSVSEM_SERIALIZE
>      -D APR_USE_PTHREAD_SERIALIZE
>      -D SINGLE_LISTEN_UNSERIALIZED_ACCEPT
>      -D APR_HAS_OTHER_CHILD
>      -D AP_HAVE_RELIABLE_PIPED_LOGS
>      -D DYNAMIC_MODULE_LIMIT=256
>      -D HTTPD_ROOT="/etc/apache2"
>      -D SUEXEC_BIN="/usr/lib/apache2/suexec"
>      -D DEFAULT_PIDLOG="/var/run/apache2.pid"
>      -D DEFAULT_SCOREBOARD="logs/apache_runtime_status"
>      -D DEFAULT_ERRORLOG="logs/error_log"
>      -D AP_TYPES_CONFIG_FILE="mime.types"
>      -D SERVER_CONFIG_FILE="apache2.conf"
>
> Should be something like `-D SERVER_CONFIG_FILE="apache2.conf"`

#### Add a name to the server

Basic Apache configuration does not impose add the server name, but I really don't like to see some text like this below, when I reloading the server.

```shell
 * Restarting web server apache2
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
 ...done.
```

That's why we will name it :)

```shell
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/servername.conf
```

Then we enable its name in for apache config by

```shell
sudo a2enconf servername
```

Just restart the server to make sure that all is done correctly.

```shell
sudo service apache2 restart
 * Restarting web server apache2
  ...done.
```

...and now full smile should appear on your face :)

### MySQL

MySQL is one of the most popular databases on the website market. So we will install it along.

During the installation process program ask you for the root password, so we write it and **remember it** for later use.

```shell
sudo apt-get install mysql-server
```

Check the installed version

```bash
mysql -V
```

That's it for the database server :)

### PHP

Installation of the PHP interpreter isn't hard. One important thing is to install all modules related to our new setup, enable it, and configure to suit your needs. I'll show you most commonly used setup to save your precious time searching it through Internet.

#### Installation of PHP interpreter

Below we will install all useful modules, and enable them Apache server and PHP.

```shell
sudo apt-get install php5 php5-cli php5-common php5-gd libapache2-mod-php5 php5-mysql libapache2-mod-auth-mysql apache2-mpm-prefork libapache2-mod-php5 php5-mcrypt
sudo a2enmod php5
sudo a2enmod rewrite
sudo php5enmod mcrypt   # required by phpMyAdmin
```

#### Configuration files

Into below Apache's PHP configuration file stored at `/etc/php5/apache2/php.ini`, it is worth to change the default parameters according to those presented below. There are most commonly changed variables for PHP for development purposes.

```ini
upload_max_filesize = 50M
post_max_size = 50M
display_errors = On
display_startup_errors = On
track_errors = On
```

#### Other useful configuration files

-   `/etc/apache2/sites-available/default`
<!--- `/home/$USER/apache/conf/httpd.conf`-->

### PHPMyAdmin

Installation of PHPMyAdmin is trivial.

```shell
sudo apt-get install phpmyadmin
```

During the installation, the wizard will ask you for:

1.  Which WWW Server would you like to choose? We'll mark (with space key) `apache2`.
2.  Next window is the configuration of phpMyAdmin package and integration with the current database. We mark `Yes`.

> Sometimes we made mistake during this installation process, so the command to reopen this configuration wizard is `sudo dpkg-reconfigure phpmyadmin`.

### Add VirtualHost

> **Good practice:** If you want to create site ex: `egel.pl`, write config file like this `egel.pl.conf`

```shell
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/blog.loc.conf
```

And create something like this

> I like to use `.loc` for my local domains. I do not use `.dev` anymore due to now, it is a real, official domain extension.

```apache
<VirtualHost *:80>
    ServerAdmin admin@example.com
    ServerName blog.loc
    DocumentRoot /var/www/blog.loc/public_html/
    <Directory /var/www/blog.loc/public_html/>
        AllowOverride All
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Save it.

```shell
sudo ln -s $HOME/workspace/blog/output/ /var/www/blog.loc/public_html
sudo a2ensite blog.loc.conf
```

Next, we need to tell the server to use our new ServerName.

The best solution I know for development purposes involving `dnsmasq`, which I definitely recommend - you can find how to do it into article [How to install dnsmasq]({filename}install_dnsmask_linux.md) or just add the name of the server to the `/etc/hosts`:

```bash
echo "127.0.0.1 blog.loc" | sudo tee /etc/hosts
```

Then `sudo service apache2 reload` and open

### Creating public_html directory for the user

Some people do not agree with it (mainly by security issues it can cause) but apache also support the old user catalog usually stored at `~/public_html`, and it can be working like `/var/www/html`.

There are 2 different approaches to creating this directory.

1.  First one assumes that User's catalog (~/public_html) should be owned by [hir][wikipedia-hir] and hir alone, also with files permissions.
2.  The second one presupposes that all files should be owned by `www-data` user. This solution is a bit better because other files migration not causes the access collisions.

> Personally, I prefer the second approach.

To enable this magical directory we need to edit `/etc/apache2/mods-enabled/php5.conf` (it may require `sudo` privileges to save it).

Into this file, we need to comment some lines (`##`) like in below snippet.

```apache
<FilesMatch ".+\.ph(p[345]?|t|tml)$">
    SetHandler application/x-httpd-php
</FilesMatch>
<FilesMatch ".+\.phps$">
    SetHandler application/x-httpd-php-source
    # Deny access to raw php sources by default
    # To re-enable it's recommended to enable access to the files
    # only in specific virtual host or directory
    Order Deny,Allow
    Deny from all
</FilesMatch>
# Deny access to files without filename (e.g. '.php')
<FilesMatch "^\.ph(p[345]?|t|tml|ps)$">
    Order Deny,Allow
    Deny from all
</FilesMatch>

# Running PHP scripts in user directories is disabled by default
#
# To re-enable PHP in user directories comment the following lines
# (from <IfModule ...> to </IfModule>.) Do NOT set it to On as it
# prevents .htaccess files from disabling it.
##<IfModule mod_userdir.c>
##    <Directory /home/*/public_html>
##        php_admin_flag engine Off
##    </Directory>
##</IfModule>
```

Now we set server so that we can throw files into the `~/public_html` directory. It may be necessary to give the appropriate rights for the directory, so we need to take this into consideration as well.

```shell
mkdir ~/public_html
chmod 775 ~/public_html
sudo a2enmod userdir
```

Now restart the Apache and since this moment we can easily use `~/public_html` in all user's catalogs like the server's one.

```shell
sudo /etc/init.d/apache2 restart
```

##### Setup the httpd.conf

We locate our `httpd.conf` file.

> ** For the different systems vary called **, for example, for Ubuntu 14.04 64-bit is a `apache2.conf`

We remember the path for running apache2

```shell
$ ps -ef | grep apache
apache   12846 14590  0 Oct20 ?        00:00:00 /usr/sbin/apache2
```

Now we add `-V` flag

```shell
$ /usr/sbin/apache2 -V | grep SERVER_CONFIG_FILE -D SERVER_CONFIG_FILE="/etc/apache2/apache2.conf"
```

Next we are open the file and we can add our path to `public_html` inside:

```apache
<Directory /home/maciej/public_html/>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
```

Restart and we are home.

##### May occur the problem like "index.php not found"

```
Not Found

The requested URL /index.php was not found on this server.
```

Probably the cause of that is rewriting the URL into for example:

-   Joomla: `Global config` > `Adjust rewriting URLs` and set for **OFF**

### Problem #1

Once you install the module, the module will be available in the `/etc/apache2/mods-available` directory. You can use the `a2enmod` command to enable a module. You can use the `a2dismod` command to disable a module. Once you enable the module, the module will be available in the `/etc/apache2/mods-enabled` directory.

Example: `sudo a2enmod rewrite`

### Problem #2

[Apache2 on ubuntu - PHP downloading files insteed of run](http://stackoverflow.com/questions/6245895/apache2-on-ubuntu-php-files-downloading)

### Problem #3

**Files** should have permissions rights **664**, while **directories 755**.

> The exceptions are, of course, executable files.

Example of changes for both types, files, and directories (recursively)

```shell
find ~/public_html -type d -exec chmod 755 {} \;
find ~/public_html -type f -exec chmod 644 {} \;
```

### Problem #4

Updating all folders and files for `www-data` user into the `public_html` directory.

```bash
#!/bin/bash
sudo adduser $USER www-data
sudo chown -R www-data:www-data /home/$USER/public_html
sudo chmod -R 775 /home/$USER/public_html
```

Save it inside `/home/$USER/bin` and make it executable using:

```shell
sudo chmod +x /home/$USER/bin/public_html_fix.sh
```

[jdownloader_shell_installer]: http://installer.jdownloader.org/jd_unix_0_9.sh
[xmind_homepage]: http://www.xmind.net/
[poedit_download_page]: https://launchpad.net/~schaumkeks/+archive/ppa/+sourcepub/2991913/+listing-archive-extra
[sublime_home_page]: http://www.sublimetext.com/
[sublime_blog_page_url]: http://dbader.org/blog/setting-up-sublime-text-for-python-development
[sublime_package_control_installation_page]: https://sublime.wbond.net/installation
[sublime_github_livereload_page]: https://github.com/dz0ny/LiveReload-sublimetext2
[sublime_soda_theme_page]: http://buymeasoda.github.io/soda-theme/
[sublime_tomorrow_theme]: https://github.com/theymaybecoders/sublime-tomorrow-theme
[article_about_apache2_url]: https://library.linode.com/web-servers/apache/installation/ubuntu-12.04-precise-pangolin
[textmaker_download_page_url]: http://www.xm1math.net/texmaker/download.html#linux
[google_chrome_download_page_url]: http://www.google.pl/intl/pl/chrome/
[dashboard_icon_link]: http://askubuntu.com/questions/68612/how-to-change-the-dash-icon-in-the-unity-launcher
[wikipedia-daemon]: https://en.wikipedia.org/wiki/Daemon_%28computing%29
[wikipedia-hir]: https://en.wikipedia.org/wiki/Hir_%28disambiguation%29
