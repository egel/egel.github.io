---
layout: post
title: Complete guide to install and configure Debian 12
tags: [linux, hardware, security]
# modified: 2025-02-23
---

In some of my previous post I was creating a [Home Kubernetes Cluster][post-home-k8s-cluster]. The experience from this event give me wisdom to try something different then Ubuntu for the server but still simple to operate without much problems.I decided to move to Debian.

In this article I want to cover a full, fresh installation and preparation of Debian PC based on my HP Elitedesk 800 G3. I will use Elitedesk or PC interchangeably. This ground work will give us a foundation for [Home Kubernetes Cluster][post-home-k8s-cluster]

## Prerequisites

Hardware:

-   USB stick with minimum 4GB or more
-   PC (I used one from spec below):
    -   Model: HP Elitedesk 800 G3 DM 35W
    -   CPU: Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz
    -   Mem: 16384 MB
-   Additional screen
-   Additional keyboard

Software:

-   Etcher (to flash)
-   Debian ISO

## Prepare the USB stick

-   download image from [Debian download][weblink-debian-download] page. At the time of writing this article I used `Iso-DVD` of **Debian 12.11.0 Bookworm**.

[Select the mirror](https://www.debian.org/CD/http-ftp/#mirrors) closest to your location and download image.

Since my Elitedesk 800 is has [Intel i5 6500T][weblink-intel-i56500t] chip on board and runs with 64-bit instructions set, therefore I chose image for `amd64` architecture.

Here is sample link for reference: [debian-12.11.0-amd64-DVD-1.iso][weblink-debian-hannover-iso-dvd-debian-12-11-0-amd64]

Using [Etcher][weblink-etcher] install the ISO image on your USB stick. This might take several minutes depend on the quality and speed of your USB stick.

If this is done, your ready for next part.

## Installation

Connect your desired server (in my case it's Elitedesk 800) with power adapter, screen, keyboard and put the stick in the USB. We need to start the PC and enter BIOS to boot from USB stick instead of hard drive.

When system will start booting up start pressing `F10` several times. This will allow to enter BIOS and

We want to enable booting from Stick save and exit

Next, we should Press `F9` to enter quick access boot menu and Select our new stick.

<img src="/assets/posts/complete-guide-to-install-and-configure-debian-12/image.png" alt="" />

I will use default and simple partition configuration to simplify this process.

IMAGES

We are now boot up again and we are ready for configuration.

## Configuration

### Setup IP address

Depend on your resources there are 2 ways we want to setup IP address.

-   Dynamic, via assigning static IP via router DHCP (you may need MAC address of your device)
-   Static, via old school assign static IP address

#### Dynamic via router static IP

Using FritzBox, login to your router admin panel <http://fritz.box/>

At first you might get error with "Your connection is not private". This is expected with local router configuration. Simply accept by click "Advanced", and continue "Proceed to fritz.box (unsafe)".

<img src="/assets/posts/complete-guide-to-install-and-configure-debian-12/image.png" alt="" />

Let's jump to configuration:

-   go to `Home Network`
-   Find and open `cplane1` device
    -   in tab `Network`:
        -   select desired IP, I used `XXX.YYY.ZZZ.200`
        -   enable `Assign permanent IPv4 address`

If you cannot find it as have many devices you can check the MAC address after logging in with command `ip addr` (usually it come after word `ether` in some of networks).

<img src="/assets/posts/complete-guide-to-install-and-configure-debian-12/fritzbox-network-devicelist.png" alt="" />

<img src="/assets/posts/complete-guide-to-install-and-configure-debian-12/fritzbox-device-homenetwork-permament-ipv4.png" alt="" />

<figure>
    <img src="/assets/posts/complete-guide-to-install-and-configure-debian-12/fritzbox-change-until-device-restarts.png"
         alt="This is fine">
    <figcaption>The change will not be active until the device restarts</figcaption>
</figure>

<!--

#### Static IP

If you did not choose dynamic IP via router, you are must setup static IP address directly on the machine.

1. Backup `/etc/network/interfaces` file running `sudo cp /etc/network/interfaces /root/`
1. Edit the `/etc/network/interfaces`
1. Configure static IP address for `enp0s5` Ethernet interface: address `192.168.1.249`
1. Add subnet mask: `netmask 255.255.255.0`
1. Set up default gateway IP: `gateway 192.168.2.254`
1. Finally add DNS resolver IP: `dns-nameservers 192.168.2.254 8.8.8.8 1.1.1.1`

-->

### SSH service

During system installation we select explicitly select an option to install SSH service, so after the installation, the PC should be already reachable via SSH.

Let's test it:

```sh
# from your laptop (or other control PC)
ssh maciej@192.168.178.200
```

If you can each it. This part is done and you can jump to next one.

#### Enable SSH

First thing we want to do, is to enable the remote connection via SSH. We should do it at first as it will allow us to use our laptop's terminal to connect to server, instead using attached peripherals (monitors, keyboard).

At this point our system is quite bare-bone. We probably do not have even have `sudo` program installed. But no worry we will take care of this later. Lets first enable SSH. During installation we explicitly select to instal SSH server, so the service should be working or if we should be able to start it.

```sh
# after login to system, switch user to be root
su -

# check SSH status
systemctl status ssh

# enable SSH service
systemctl start ssh

logout
```

At this point we should be ready to login via SSH from our laptop. The port is so far not changed (port `22`) and we may adapt this later.

```sh
# from your laptop (or other control PC)
ssh maciej@192.168.178.200
```

Success! You can now disconnect the monitor and keyboard, and focus on your laptop.

At this point if you have more servers to configure. You can reproduce same steps at this moment for other machines. So later all together configuration can be perform for all machines at the same time with `ansible`.

### Update broken update

```sh
root@cplane1:~# apt update
Ign:1 cdrom://[Debian GNU/Linux 12.11.0 _Bookworm_ - Official amd64 DVD Binary-1 with firmware 20250517-09:52] bookworm InRelease
Err:2 cdrom://[Debian GNU/Linux 12.11.0 _Bookworm_ - Official amd64 DVD Binary-1 with firmware 20250517-09:52] bookworm Release
  Please use apt-cdrom to make this CD-ROM recognized by APT. apt-get update cannot be used to add new CD-ROMs
Reading package lists... Done
E: The repository 'cdrom://[Debian GNU/Linux 12.11.0 _Bookworm_ - Official amd64 DVD Binary-1 with firmware 20250517-09:52] bookworm Release' does not have a Release file.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
```

If you see this above, most likely you must update you source list from `/etc/apt/source.list`.

```sh
root@cplane1:~# cat /etc/apt/sources.list
deb cdrom:[Debian GNU/Linux 12.11.0 _Bookworm_ - Official amd64 DVD Binary-1 with firmware 20250517-09:52]/ bookworm contrib main non-free-firmware
```

Edit file `vi /etc/apt/sources.list`, remove all, and paste something like this:

```
deb https://ftp.debian.org/debian/ bookworm contrib main non-free non-free-firmware
# deb-src https://ftp.debian.org/debian/ bookworm contrib main non-free non-free-firmware

deb https://ftp.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware
# deb-src https://ftp.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware

deb https://ftp.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware
# deb-src https://ftp.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware

deb https://ftp.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware
# deb-src https://ftp.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware

deb https://security.debian.org/debian-security/ bookworm-security contrib main non-free non-free-firmware
# deb-src https://security.debian.org/debian-security/ bookworm-security contrib main non-free non-free-firmware
```

Now, we can update and ready to install software

```sh
root@cplane1:~# apt update

# upgrade existing packages
root@cplane1:~# apt upgrade -y
```

### Configure sudo and privileges to User

```sh
root@cplane1:~# apt update

# install sudo
root@cplane1:~# apt install sudo -y

# add regular user 'maciej' to sudoers
root@cplane1:~# usermod -aG sudo maciej

root@cplane1:~# exit

maciej@cplane1:~$ logout
```

If you are already logged as regular use (in my case is `maciej`) you have to logout and login again, so user sudoers group is properly picked.

Last thing we may want to do, is to **include log sudo usage**. Open `sudo visudo` and ensure this line is in the file. This will make sure to log all sudo commands to `/var/log/sudo.log` file.

```
Defaults        logfile="/var/log/sudo.log"
```

From now on you can perform all actions, as regular user (`maciej`). When there will be a need to use `root` will show it with prompt `root@cplane1:~#`.

### Configure Hostname and Timezone

In installation we setup this although to make this tutorial complete lets check it

```sh
hostnamectl

timedatectl
```

If you anyway want to change it, you can do it with:

```sh
sudo hostnamectl set-hostname cplane1

sudo timedatectl set-timezone Europe/Berlin
```

### Enable automatic updates

Depend on who is reading and how hardcore security freak is, but we want to our server perform some security patches automatically. In second command below, we will get prompt to enable automatic updates.

```sh
sudo apt install unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

```sh
# copy folder from PC to laptop
scp -r maciej@192.168.178.200:/home/maciej/ckad-training-ground .
```

### Secure root account

Best practice is to disable login as `root` via SSH and prevent from direct login.

```sh
sudo passwd -l root
```

### Update default SSH port

Changing the default port for SSH can reduce risk for automated attacks. To do so, open `vi /etc/ssh/sshd_config` and update port to desired e.g.: `2222`, but use different one if you prefer.

Restart SSH service:

```sh
sudo systemctl restart ssh
```

### Activate SSH log

We usually want to monitor all activity with logging to our server

```sh
# install rsyslog
sudo apt install rsyslog -y

# check if service is running
systemctl status rsyslog

# edit config
sudo vi /etc/rsyslog.conf
```

Make sure section below is uncommented:

```
auth,authpriv.*                 /var/log/auth.log
```

Restart service:

```sh
sudo systemctl restart rsyslog
```

### Setup Firewall

```sh
sudo apt install ufw

# allow SSH connections (if you choose different please use it here)
sudo ufw allow 2222/tcp

# enable firewall
sudo ufw enable

# test status
sudo ufw status
```

#### Configure additional firewall services

```sh
# allow HTTP / HTTPS
sudo ufw allow http
sudo ufw allow https

# deny Telnet
sudo ufw deny 23

# allow Rsyslog
ufw allow 514/tcp
ufw allow 514/udp
```

### IDS - Intrusion detection systems

#### Fail2Ban

Fail2Ban will project you from brute-force attacks by ban IP addresses after specified number of failed attempts.

```sh
# install
sudo apt install fail2ban -y

# copy config as local version
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# edit configuration
sudo vi /etc/fail2ban/jail.local
```

Fragment of `jail.local`

```ini
[sshd]
mode     = normal
port     = ssh
logpath  = %(sshd_log)s
backend  = %(sshd_backend)s
maxretry = 5
```

Restart service

```sh
sudo systemctl restart fail2ban
```

#### AIDE

AIDE stands for _Advanced Intrusion Detection Environment_ and it monitors file system changes.

```sh
# install
sudo apt install aide -y

# initialize
sudo aideinit
```

It also should create a daily cron job to check system. You can examine it at `/etc/cron.daily/aide`.

### Configure AppArmor

AppArmor is a security program that restrict programs capabilities

```sh
# install
sudo apt install apparmor apparmor-profiles apparmor-utils -y

# enable
sudo systemctl enable apparmor
sudo systemctl start apparmor

# test status
sudo apparmor_status
```

### Secure Nginx

```sh
# install
sudo apt install nginx -y
```

Edit `vi /etc/nginx/nginx.conf` and disable showing server name and version

```
server_tokens off;
```

Install Certbot for Let's Encrypt

```sh
# install
sudo apt install certbot python3-certbot-nginx -y

# obtain SSL certificate
sudo certbot --nginx
```

### Monitor logs

We also may want to regularly review logs from suspicious activity. Let's use `logwatch`

```sh
# install
sudo apt install logwatch -y

# edit cron job to mail
sudo vi /etc/cron.daily/00logwatch
```

Sample edited file `/etc/cron.daily/00logwatch`

```sh
#!/bin/bash

#Check if removed-but-not-purged
test -x /usr/share/logwatch/scripts/logwatch.pl || exit 0

#execute
/usr/sbin/logwatch --output mail --mailto john.doe@example.com --detail high
```

### Custom MOTD when login

MOTD stands for "message of the day". When we log to the system, by default Debian will greet us with something like:

```
Linux cplane1 6.1.0-35-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.137-1 (2025-05-07) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Thu Jun 12 16:48:47 2025 from 192.168.178.162
```

We can do a bit better and provide bit more initial information for us especially if we log in after being some time away. Let's use `neofetch` and `inxi` to help us display few things.

```sh
# install
sudo apt install neofetch inxi -y
```

```sh
# list of available files
$ ls -al /etc/update-motd.d/
total 16
drwxr-xr-x  2 root root 4096 Jun 12 17:00 .
drwxr-xr-x 81 root root 4096 Jun 12 19:23 ..
-rwxr-xr-x  1 root root   23 Apr  4  2017 10-uname
-rwxr-xr-x  1 root root  165 Dec 31  2022 92-unattended-upgrades

# file 10-uname is not interesting, so let's remove it and create our file
sudo rm -rf /etc/update-motd.d/10-uname

# create new file 01-custom
sudo tee /etc/update-motd.d/01-custom >/dev/null <<EOF
#!/bin/sh
printf "\n"
/usr/bin/neofetch

inxi -D
printf "\n"
EOF

# apply executing privileges to script
sudo chmod +x /etc/update-motd.d/01-custom
```

With that we finally have nice looking and informative start screen.

<img src="/assets/posts/complete-guide-to-install-and-configure-debian-12/neofetch-inxi-welcome-screen.png" alt="" />

## Finalization

Hope you enjoy the tutorial and leave a comment what you like and what would you improve. Thank you for staying with me and until next time.

## Reference

-   https://sec-tech.org/how-to-harden-a-freshly-installed-debian-server-a-comprehensive-step-by-step-guide/
-   https://thelinuxcode.com/partition-disks-while-installing-debian-12-bookworm/
-   https://medium.com/@zehan9211/how-to-fix-debian-12-bookworm-update-error-395a3d6d4ab7
-   https://linuxways.net/debian/fix-sudo-command-not-found-debian-12/#post-24005-bookmark=id.x2pttty01825
-   https://cloudybarz.com/custom-motd-in-linux-debian/
-   https://www.putorius.net/custom-motd-login-screen-linux.html

[post-home-k8s-cluster]: {{ site.baseurl }}{% link _posts/2024-08-26-home-k8s-cluster.md %}
[weblink-etcher]: https://etcher.balena.io/
[weblink-debian-download]: https://www.debian.org/distrib/
[weblink-intel-i56500t]: https://www.intel.com/content/www/us/en/products/sku/88183/intel-core-i56500t-processor-6m-cache-up-to-3-10-ghz/specifications.html
[weblink-debian-hannover-iso-dvd-debian-12-11-0-amd64]: https://ftp.uni-hannover.de/debian/debian-cd/12.11.0/amd64/iso-dvd/
