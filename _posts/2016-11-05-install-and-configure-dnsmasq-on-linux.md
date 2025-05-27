---
layout: post
title: Install and configure dnsmasq on Linux
tags: [linux, frontend]
summary: In few small steps I will try to show you how to setup your own instance of dnsmasq.
---

If you previously used `/etc/hosts` to manage your local domains and didn't yet hear about more effective way of managing local domains, you should definitely try the old and good `dnsmasq` program to improve your development workflow.

### Installation process

Using the `apt-get` manager we will install core program.

```sh
sudo apt-get install dnsmasq
```

### Configuring dnsmasq as DNS server

Then when we have the program installed, now we can get directly to the configuration. But before, we'll create a backup file.

```sh
sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.backup
```

In the example we want to use `loc` domain as our local domain (I don't use `.dev` anymore, due to now it's into standard global domains) and then in `/etc/dnsmasq.conf` we add:

```conf
listen-address=127.0.0.1
address=/loc/127.0.0.1
```

That is pretty much it. Next, restart the service by:

```sh
sudo service dnsmasq restart
```

Finally, check if everything went OK and you are good to go.

```sh
ping example.loc
PING example.loc (127.0.0.1) 56(84) bytes of data.
64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.010 ms
64 bytes from localhost (127.0.0.1): icmp_seq=2 ttl=64 time=0.016 ms
64 bytes from localhost (127.0.0.1): icmp_seq=3 ttl=64 time=0.036 ms
64 bytes from localhost (127.0.0.1): icmp_seq=4 ttl=64 time=0.038 ms
```
