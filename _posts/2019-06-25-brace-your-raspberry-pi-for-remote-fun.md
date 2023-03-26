---
layout: post
title: Brace your Raspberry Pi for remote fun
published: true
tags: [raspberry-pi, ssh, wifi]
---

Whenever I have some fun with my Raspberry Pi and try to accomplish something crazy, which in the end lead to destroy the system, I have to reproduce some repeatable steps in order to make my Pi useful again.

Each time my goal is pretty much simple, I would even risk saying minimalistic. The objective is to have as few cables as possible (only power supply) and the most important point to have automatic connection to my local Wi-Fi network, so I can easily SSH to the Pi and start the fun.

Here is my minimal setup using **Raspbian Stretch Lite** as the base image (without GUI interface). You can find it here: <https://www.raspberrypi.org/downloads/raspbian/>

## You must gather your party before venturing forth

Ok, I assume before you roll out with further venturing forth, you must have a running Raspberry Pi (with installed Raspbian Stretch Lite) and a reachable wireless network nearby (must have SSID and password).

## Setup auto WiFi connection

Login to your Pi and of course, change the default password for your `pi` user. Usually, it's:

| user | password  |
| ---- | --------- |
| pi   | raspberry |

> TIP: to change the password for the current logged user just type: `passwd`

### Get wicd-curses

There are many ways to automatically configure a WiFi connection. I will try to KISS (keep it stupid simple) and use `wicd-curses`.

At the moment you don't have any wireless connection in order to download the program which simplifies our further network configuration. So for now, we will use a default raspberry tool to temporarily connect to wifi and download `wicd-curses`. Yes, we make it temporarily because `raspi-config` can't remember the network connections and/or automatically connect to them.

```bash
sudo raspi-config
```

1.  Network Options

    ![raspi-config Network options]\({{ site.baseurl }}/assets/img/raspi-config-network-options.png)

    Then by clicking through further menu options connect to your network.

    -   Wi-fi
    -   SSID - Name of the network
    -   Password

If you finally managed to get to your wifi now it's time to download `wicd-curses`

```bash
sudo apt-get install wicd-curses
```

Since we installed `wicd-curses` and we can disable default raspberry `dhcpcd` service.

```bash
sudo systemctl disable dhcpcd
sudo systemctl stop dhcpcd
```

Let's start setting up our permanent WiFi connection with `wicd-curses`.

```bash
sudo wicd-curses
```

1.  Select your network with UP and DOWN arrow keys.

1.  Press RIGHT arrow key in order to enter configuration for this network.

1.  Put `X` nearby:

    -   `[X] Use DHCP Hostname`
    -   `[X] Automatically connect to this network`
    -   `[X] Use Encryption`
    -   Fill the password
    -   In the end **save** by pressing `Shift`+`S`

1.  Select the network and connect it by pressing enter.

Done. Now if you reboot your Pi it should automatically connect to the network. Moreover, if you travel with your Pi to multiple places it will remember all nearby networks and will also automatically connect to them. Sweet! 🤓

## Enable SSH access

```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

Now you can reboot the device and connect to it via SSH.

> Additionally you can add your public key to `~/.ssh/authorized_keys`, so you can spare next time typing your password.

## Useful packages

Additionally, I usually also install:

```bash
sudo apt-get update
sudo apt-get -y install \
    vim \
    curl \
    wget \
    zip \
    unzip \
    apt-utils \
    usbutils \
    tree \
    zsh

# oh-my-zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

That's it. Now you have a decent, minimalistic configuration to start playing with your Pi completely remote. Ha, you can be even smarter than this and prepare the image of your MicroSD card, so next time you can just flash it and use it immediately by starting the Pi. Awesome!
