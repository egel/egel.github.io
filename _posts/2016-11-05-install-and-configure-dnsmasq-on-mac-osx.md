---
layout: post
title: Install and configure dnsmasq on Mac OSX
tags: [osx, dnsmasq, terminal]
summary: In few small steps I will try to show you how to setup your own instance of dnsmasq.
---

If you previously using `/etc/hosts` to manage your local domains and not heard about a more effective way of managing local domains, you should try the old and good `dnsmasq` program to improve your development workflow.


### Installation of program

Using the `apt-get` manager we will install core program.

```bash
brew install dnsmasq
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
```

### Adding resolver to loc domain

Nowadays, there are so many new domains like `dev`, `build`, `system`, `shop`, etc., so that why I prefer using domain `loc` (which stands for `local` or `localhost`) and it's not in domain's extensions.

```bash
[ -d /etc/resolver ] || sudo mkdir -v /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/loc'
```

### Add service to start with system

```bash
sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
```

### Configuring dnsmasq as DNS server
Then when we have a program installed, now we can get strict to the configuration. But before further actions, we will create a backup file.

```bash
sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.backup
```

In the example we want to use `loc` domain as our local domain (I do not use `.dev` anymore due to now it is into standard global domains) and into `/etc/dnsmasq.conf` the file we add:

```conf
listen-address=127.0.0.1
address=/loc/127.0.0.1
```

That is pretty much it. Next restart the service by:

```bash
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
```

The last thing we probably have to do is a reset of  `mDNSResponser` service.

```shell
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
```

Finally check if everything went ok and you are good to go.
```
ping example.loc
PING example.loc (127.0.0.1) 56(84) bytes of data.
64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.010 ms
64 bytes from localhost (127.0.0.1): icmp_seq=2 ttl=64 time=0.016 ms
64 bytes from localhost (127.0.0.1): icmp_seq=3 ttl=64 time=0.036 ms
64 bytes from localhost (127.0.0.1): icmp_seq=4 ttl=64 time=0.038 ms
```
