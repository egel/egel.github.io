---
layout: post
title: Install the latest nVidia drivers for Linux
tags: [linux, terminal]
---

From time to time Linux users, especially developers, when they set up their workstations and might need to go through a process of installing drivers for their new hardware - and "oh no, it's NVIDIA's drivers...".

> **Please remember, backup always go first!**
>
> Anything you do with Linux, especially when you don't know what you're doing, create a backup copy.

### Small admonishment story

The time has come also for me. While playing with a graphical settings on my old laptop with Linux Mint 17, I've changed too many files (as usual when learning), so I've crashed my PC. In consequence I had to face with re-installation of the NVIDIA drivers on my Mint 17 distribution and if possible to avoid the re-installation of the whole system.

While using the distro GUI, there appeared a couple of problems with "NVIDIA proprietary drivers". So I've pressed <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>F1</kbd>, and got a black screen with flashing cursor. "YES!" - I shouted immediately - "the console isn't broken for good" - I sad to myself in mind.

Next, I've read somewhere on the Web on my mobile phone, that the problem could be connected with the framebuffer. So that I've made few modifications to `/etc/default/grub` to reduce the resolution of default screen

> TIP: for 4k monitors it's a good practice to change grub screen size, because the text on the screen is much bigger and far better visible.

```sh
sudo cp /etc/default/grub /etc/default/grub.bak
```

Now edit the grub file by entering

```sh
sudo vim /etc/default/grub
```

While editing in your favorite editor (I'm using `vim`), uncomment the lines, simply by removing the `#` in front of those lines.

> If your monitor support better resolutions you can change `GRUB_GFXMODE` for another value, my highest was `1024x768`.

```
GRUB_TERMINAL=console
GRUB_GFXMODE=640x480
```

Save the file and run `update-grub` to apply changes

```sh
sudo update-grub
```

Now, I had to resolve which display manager do I have on my Mint?

```sh
cat /etc/X11/default-display-manager
```

In my case, it was `mdm`, so then I've uninstalled all available NVIDIA drivers, stopped my display manager, installed new drivers and enabled the display manager again.

> Important part of installation NVIDIA drivers is (at least for all my cases) to be logged in as `root` user, not using `sudo`, but literally perform all commands of installation as root.

```sh
sudo apt-get purge nvidia-*
sudo su
service mdm stop
chmod +x /path/to/downloaded/driver/NVIDIA-Linux-x86_64-*.run
/path/to/downloaded/driver/NVIDIA-Linux-x86_64-*.run
service mdm start
exit # logout from root user
```

That's it. After pressing <kbd>Alt</kbd> + <kbd>Ctrl</kbd> + <kbd>F8</kbd> the GUI showed up as well as a smile on my face :)
