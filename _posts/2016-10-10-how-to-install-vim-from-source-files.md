---
layout: post
title: How to install Vim from the source files
modified: 2017-05-03
tags: [text-editor, vim, linux, source-files, ubuntu]
---

If you reading this article you're probably a Vim user or somebody who has lost. If you're a Vim lady or guy, that's great because I'll say something how to compile your brand new Vim instance, directly from the source files.

Meantime you may wonder:

> "Why to install Vim from source files if there are precompiled, ready to install packages available in almost any package manager"

Yeah, that is a really good question! However, there are also a lot of other phrases and opinions which might in a different level of details describe the advantages and disadvantages of both approaches.

Although, straight to the point. If you compile and install from the source, the program is the best possible suited to your system's software but especially for the hardware. Moreover, you can use the latest versions, especially those not available in the package managers (edge versions).

There are also some light and dark sides of doing it from the source, but IMHO for Vim, this is the best possible way to have a blazing fast text editor.

### One click installer

For Linux distributions with `apt-get` package manager (basically all based on Debian, but other should also work) I've provided a simple one-click installer.

<script src="https://gist.github.com/egel/74ecc84c8d6ccaf697f63e7202585ab1.js"></script>

### Before you start

We need to check some related libraries and languages which Vim or Vim's plug-ins may require in order to work properly. Now we'll check only the most popular:

-   Lua + LuaJIT
-   Ruby
-   Perl
-   Python v2 & v3

> Scripts that should work for Ubuntu 16.04 look like this:
>
> ```sh
> sudo apt-get update -y
> sudo apt-get remove -y --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common
> sudo apt-get install -y liblua5.1-dev luajit libluajit-5.1
> sudo apt-get install -y python-dev python3-dev ruby-dev libperl-dev mercurial libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev
> ```

The results of checking I've presented below, because I think that it might be helpful for many beginners as I was once ;)

```sh
$ lua -v
Lua 5.1.3  Copyright (C) 1994-2013 Lua.org, PUC-Rio
```

```sh
$ luajit -v
LuaJIT 2.0.2 -- Copyright (C) 2005-2013 Mike Pall. http://luajit.org/
```

```sh
$ ruby -v
ruby 2.2.1p85 (2015-02-26 revision 49769) [x86_64-linux]
```

```sh
$ perl -v

This is perl 5, version 18, subversion 2 (v5.18.2) built for x86_64-linux-gnu-thread-multi
(with 44 registered patches, see perl -V for more detail)

Copyright 1987-2013, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

```sh
$ which python
/usr/bin/python
```

```sh
$ which python3
/usr/bin/python3
```

### Installation for Linux

The installation is relatively simple. Probably the scariest thing while installation of Vim is the configuration of flags, but I'll try to cover this topic to be more obvious.

The flags are simple, but the hardest one might be `--with-python-config-dir` because the config directory can different depends on the system (different versions of Linux may have different locations for Python).

To check it, run:

```sh
$ python-config --configdir
```

```sh
$ python3-config --configdir
```

I my case they ware like those presented below:

-   for python 2: `/usr/lib/python2.7/config-x86_64-linux-gnu`
-   for python 3: `/usr/lib/python3.4/config-3.4m-x86_64-linux-gnu`

The downloaded version of Vim also matters. If a downloaded version of Vim is v7.4 you should write `vim74` or if the version is `v8.0` then you should write `vim80`. You're obligated to correct those paths with relevant `VIMRUNTIMEDIR` configuration variable. In the script below it's already set to `vim80`.

> If you don't know which is the latest version (tag) from Vim's repository on GitHub and you downloaded repo via `git clone`, then run this command `$ git describe --abbrev=0 --tags` in order to check the latest tag.

```sh
mkdir -p /tmp/vim
git clone https://github.com/vim/vim /tmp/vim
cd /tmp/vim
./configure --with-features=huge \
            --enable-multibyte \
            --enable-gui=auto \
            --enable-gtk2-check \
            --enable-gtk3-check \
            --enable-gnome-check \
            --enable-cscope \
            --enable-largefile \
            --enable-pythoninterp=dynamic --with-python-config-dir=$(python-config --configdir) \
            --enable-python3interp=dynamic --with-python3-config-dir=$(python3-config --configdir) \
            --enable-perlinterp \
            --enable-rubyinterp=dynamic \
            --enable-luainterp=dynamic \
            --with-luajit \
            --with-x \
            --prefix=/usr \
            --with-compiledby="Maciej Sypień <maciejsypien@gmail.com>" \
            --enable-fail-if-missing
make VIMRUNTIMEDIR=/usr/share/vim/vim80
sudo make install
```

If all goes well, now you can check if Vim is available for you via the console. You will also see that the `+` is near all relates libraries or languages.

```
$ vim --version
VIM - Vi IMproved 8.0 (2016 Sep 12, compiled Sep 17 2016 19:09:12)
Included patches: 1-5
Compiled by root@forge
Huge version with GTK2 GUI.  Features included (+) or not (-):
+acl             +file_in_path    +mouse_sgr       +tag_old_static
+arabic          +find_in_path    -mouse_sysmouse  -tag_any_white
+autocmd         +float           +mouse_urxvt     -tcl
+balloon_eval    +folding         +mouse_xterm     +termguicolors
+browse          -footer          +multi_byte      +terminfo
++builtin_terms  +fork()          +multi_lang      +termresponse
+byte_offset     +gettext         -mzscheme        +textobjects
+channel         -hangul_input    +netbeans_intg   +timers
+cindent         +iconv           +num64           +title
+clientserver    +insert_expand   +packages        +toolbar
+clipboard       +job             +path_extra      +user_commands
+cmdline_compl   +jumplist        +perl            +vertsplit
+cmdline_hist    +keymap          +persistent_undo +virtualedit
+cmdline_info    +lambda          +postscript      +visual
+comments        +langmap         +printer         +visualextra
+conceal         +libcall         +profile         +viminfo
+cryptv          +linebreak       +python/dyn      +vreplace
+cscope          +lispindent      +python3/dyn     +wildignore
+cursorbind      +listcmds        +quickfix        +wildmenu
+cursorshape     +localmap        +reltime         +windows
+dialog_con_gui  +lua             +rightleft       +writebackup
+diff            +menu            +ruby            +X11
+digraphs        +mksession       +scrollbind      -xfontset
+dnd             +modify_fname    +signs           +xim
-ebcdic          +mouse           +smartindent     +xpm
+emacs_tags      +mouseshape      +startuptime     +xsmp_interact
+eval            +mouse_dec       +statusline      +xterm_clipboard
+ex_extra        -mouse_gpm       -sun_workshop    -xterm_save
+extra_search    -mouse_jsbterm   +syntax
+farsi           +mouse_netterm   +tag_binary
   system vimrc file: "$VIM/vimrc"
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
      user exrc file: "$HOME/.exrc"
  system gvimrc file: "$VIM/gvimrc"
    user gvimrc file: "$HOME/.gvimrc"
2nd user gvimrc file: "~/.vim/gvimrc"
       defaults file: "$VIMRUNTIME/defaults.vim"
    system menu file: "$VIMRUNTIME/menu.vim"
  fall-back for $VIM: "/usr/share/vim"
Compilation: gcc -c -I. -Iproto -DHAVE_CONFIG_H -DFEAT_GUI_GTK  -pthread -I/usr/include/gtk-2.0 -I/usr/lib/x86_64-linux-gnu/gtk-2.0/include -I/usr/include/atk-1.0 -I/usr/include/cairo -I/usr/include/gdk-pixbuf-2.0 -I/usr/include/pango-1.0 -I/usr/include/gio-unix-2.0/ -I/usr/include/freetype2 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -I/usr/include/pixman-1 -I/usr/include/libpng12 -I/usr/include/harfbuzz     -g -O2 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1
Linking: gcc   -L. -fstack-protector -rdynamic -Wl,-export-dynamic -Wl,-E   -L/usr/local/lib -Wl,--as-needed -o vim   -lgtk-x11-2.0 -lgdk-x11-2.0 -latk-1.0 -lgio-2.0 -lpangoft2-1.0 -lpangocairo-1.0 -lgdk_pixbuf-2.0 -lcairo -lpango-1.0 -lfontconfig -lgobject-2.0 -lglib-2.0 -lfreetype   -lSM -lICE -lXpm -lXt -lX11 -lXdmcp -lSM -lICE  -lm -ltinfo -lnsl  -lselinux   -ldl  -L/usr/lib/x86_64-linux-gnu -lluajit-5.1 -Wl,-E  -fstack-protector -L/usr/local/lib  -L/usr/lib/perl/5.18/CORE -lperl -ldl -lm -lpthread -lcrypt    -Wl,-R/home/maciej/.rvm/rubies/ruby-2.2.1/lib -L/home/maciej/.rvm/rubies/ruby-2.2.1/lib -lruby -lpthread -ldl -lcrypt -lm  -L/home/maciej/.rvm/rubies/ruby-2.2.1/lib
```

Awesome! Now you are ready to discover the Vim! Good luck hacker! See you on the grid ;)
