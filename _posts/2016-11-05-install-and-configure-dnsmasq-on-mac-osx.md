---
layout: post
title: Install and configure dnsmasq on Mac OSX
tags: [osx, dnsmasq, terminal]
summary: In few small steps I will try to show you how to setup your own instance of dnsmasq.
---

If you previously used `/etc/hosts` to manage your local domains and didn't yet hear about more effective way of managing local domains, you should definitely try the old and good `dnsmasq` program to improve your development workflow.

### Installation of program

Using the `apt-get` manager we will install core program.

```sh
brew install dnsmasq
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
```

### Adding resolver to domain

Nowadays, there are so many new global domains like `.dev`, `.build`, `.systems`, `.shop`, etc., thereat I started using shortcut `.loc` for a domain name I'm using on my localhost (which stands for `local` or `localhost`). Moreover the domain `.loc` is also not in the list of extensions for global domains.

Let's add now a resolver for our dnsmasq:

```sh
[ -d /etc/resolver ] || sudo mkdir -v /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/loc'
```

### Add service to start with system

```sh
sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
```

### Configuring dnsmasq as DNS server

Afterwards, when we have the program installed, we can go directly to its configuration. But before further actions, we'll create a backup file.

```sh
sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.backup
```

In the example we want to use domain `.loc`, so we add lines below to `/etc/dnsmasq.conf`:

```conf
listen-address=127.0.0.1
address=/loc/127.0.0.1
```

Next, restart the service:

```sh
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
```

The last thing we have to do, is to reset `mDNSResponser` service.

```sh
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
```

Finally check if everything went OK and you are good to go.

```sh
ping example.loc
PING example.loc (127.0.0.1) 56(84) bytes of data.
64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.010 ms
64 bytes from localhost (127.0.0.1): icmp_seq=2 ttl=64 time=0.016 ms
64 bytes from localhost (127.0.0.1): icmp_seq=3 ttl=64 time=0.036 ms
64 bytes from localhost (127.0.0.1): icmp_seq=4 ttl=64 time=0.038 ms
```
