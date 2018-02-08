---
layout: post
title: Install archived app into Linux
feature-img: "assets/img/pexels/code-and-glass.jpg"
tags: [linux, install]
---

Installation of new software it's essential task for average Linux user (especially Arch or Gentoo) and furthermore, there are hundreds or thousands of methods "how to install" the program. Although but how to do it from archived files like `.tar`, `.tar.gz`, `.zip` or any other might be not so obvious.
When I used Debian based Linux distributions, mostly I've installed external software in `/opt` directory and there are few reasons to do it here:
- `/opt` stands for "optional add-on software packages", so basically anything that is not part of system
-  the most evident location for multi-users programs

### Example scenario
As an example app, I'll install simple **SQLiteStudio** to edit SQLite database files.

To do so:

*   Extract archive `/opt` directory where are usually stored external apps.
*   Download the icon program (format `png` or `xpa`) and save in `/usr/share/pixmaps/` directory to with `chmod 644`.
*   Create new file for ex: `sqlitestudio.desktop` into `/usr/share/application` and paste below entry:

    ```bash
    [Desktop Entry]
    Name=SqliteStudio
    Comment=SQLite editor
    Exec=/opt/SQLiteStudio/sqlitestudio
    Icon=/usr/share/pixmaps/sqlite.png
    Terminal=false
    Type=Application
    Encoding=UTF-8
    Categories=Network;Application;
    Path=
    ```

That's pretty much it. Good job! You've correctly installed your external program for multi-users architecture and probably any graphical interface (Gnome, Unity, XFCE) should read it properly.

