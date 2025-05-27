---
layout: post
title: Setup macbook M1 for web developer
tags: [diary, macos, macbook, profession]
feature-img: "assets/img/feature/macbook_pro_m1_2021.jpg"
modified: 2023-10-07
---

Setuping mac is definitely not an every day task. It's usually long process, in order to get an efficient work station. In this article, I want to show you, how I approach to configure M1. I will share the process with the programs and the preferences I use.

<div class="alert alert-info" role="alert">
    <b>Little disclaimer</b>: I am not setting up macs every day, so when you may read this article, some things may outdate. If something will not work, toot me <a href="https://twitter.com/MaciejSypien">tweet me</a> or let me know in the comments, so I could fix it. Thanks! 🤘
</div>

## Prerequisite

-   prepare some time ~1-2h
-   good internet connection (as there will be plenty things to download)
-   something to drink
-   positive mood 😉 - I will try to make it as easy as possible for you

### Browsers

-   [Brave](https://brave.com/) (it's based on chromium)
-   [Firefox](https://www.mozilla.org/en-US/firefox/new/)
-   [Edge](https://www.microsoft.com/en-gb/edge)
-   [Safari](https://www.apple.com/safari/) should be already installed

### Password managers

-   First download your password manager(s)!
-   Optionally: download browsers extensions for easier usage

### Apple Developer Tools

Unfortunately many programs will need Apple developer tools, so we install them as well via terminal command. Pay attention as this step might take a while... (this step took me ~10-15min)

```sh
xcode-select --install
```

<div class="alert alert-info" role="alert">
    In case of problems with installation via terminal, follow <a href="https://stackoverflow.com/a/52522566">this URL</a>.
</div>

### Brew Package Manager

The [brew](https://brew.sh/index_de) is de facto standard macOS Package Manager.

Following <https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f>

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# disable analytics
brew analytics off
```

<div class="alert alert-info" role="alert">
    <p>
        Optionally: I am installing my usual packages from my dotfiles. If you are interested take a look on <a href="https://raw.githubusercontent.com/egel/dotfiles/main/configuration/Brewfile">my Brewfile</a>.
    </p>

<pre>
# to install from Brewfile
curl https://raw.githubusercontent.com/egel/dotfiles/main/configuration/Brewfile -o ~/Brewfile

brew bundle install --file=~/Brewfile
</pre>

<p>
    Later you can save all installed packages with: 
    <pre>brew bundle dump --file=~/.private/Brewfile</pre>
</p>
</div>

### iTerm2

Installed via brew. In case use: `brew install --cask iterm2`

**font, size, window theme**

If you like hack font, do not rush with installing it via: `brew install font-hack`. Instead you may want to have **Hack Font with Powerline symbols** from the NERD Fonts <https://www.nerdfonts.com/font-downloads>. To see a small difference take a look on screenshot below with Neovim.

| [Hack Font (Standard)](https://sourcefoundry.org/hack/) | [Hack Nerd Font](https://www.nerdfonts.com/) (with powerline symbols) |
| ------------------------------------------------------- | --------------------------------------------------------------------- |
| `brew install font-hack`                                | `brew tap homebrew/cask-fonts; brew install font-hack-nerd-font`      |
| ![hack-font][img-item2-with-hack-font-standard]         | ![hack-nerd-font][img-item2-with-hack-nerd-font]                      |

<div class="alert alert-info" role="alert">
    <p>
        In case you have already downloaded dotfiles locally you can copy all fonts into your local user folder. Nerd Fonts are also there 😉.
    </p>

<pre>
cp ~/privatespace/github.com/egel/dotfiles/assets/fonts/* ~/Library/Fonts
</pre>
</div>

Below you will find some screenshots with configuration I usually setup.

![iterm2-font][img-iterm2-font]

![iterm2-window-theme][img-iterm2-window-theme]

![iterm2-general-selection][imgiterm2-general-selection]

**Colorscheme Gruvbox**

```sh
curl https://raw.githubusercontent.com/herrbischoff/iterm2-gruvbox/master/gruvbox.itermcolors -o ~/Downloads/gruvbox.itermcolors
```

Import downloaded gruvbox color preset into iTerm (2), and after importing activate theme (3).

![iterm2-colorscheme][img-iterm2-import-gruvbox]

**Iterate through the arguments of previous commands** - this is awesome feature of ZSH shell, so if you are interested follow my other post how to [loop through previous arguments][post-loop-through-previous-arguments-from-command-line].

Finally you should see something like this:

![iterm2-final-window][img-iterm2-final-window]

### IDEs (VScode, IDEA)

Download the basic editors and IDEs.

-   [Sublime](https://www.sublimetext.com/download_thanks?target=mac) - best for fast small changes
-   [VS Code](https://code.visualstudio.com/docs/?dv=osx) - personal coding IDE
-   [IDEA](https://www.jetbrains.com/idea/download/?fromIDE=#section=mac) - work coding IDE (especially GoLand, DataGrip, WebStorm)

**Mobile App development**:

-   [Android Studio](https://developer.android.com/studio) - if you do some Android
-   [Xcode](https://apps.apple.com/de/app/xcode/id497799835?l=en&mt=12) - if you do some iOS/macOS

### Git

I put this out of dotfiles as git is essential to do any further steps. Later we will update `.gitconfig` to be in synch with our dotfiles repo.

```sh
wget https://raw.githubusercontent.com/egel/dotfiles/main/configuration/.gitconfig -P ~/
wget https://raw.githubusercontent.com/egel/dotfiles/main/configuration/.gitconfig.local -P ~/
wget https://raw.githubusercontent.com/egel/dotfiles/main/configuration/.gitconfig.local -O ~/.gitconfig.local_work
```

Later in GPG section, we will make sure that gpg keys will be properly added to `.local` & `.local_work` files, as they will be needed to sign the commits.

For **linux** & **macOS (Intel)**, at this moment you would need to run this command `git config --global gpg.program $(which gpg)`, so the path to gpg program can be correctly updated in `.gitconfig`.

### SSH

#### Create ssh keys

I love gitlab page for [configuration of SSH keys](https://docs.gitlab.com/ee/user/ssh.html).

```sh
ssh-keygen -t ed25519 -C "johndoe@example.com"
```

<div class="alert alert-info" role="alert">
<p>If you forgot to add passphrase for your key use this command. See more at <a href="https://docs.gitlab.com/ee/user/ssh.html#update-your-ssh-key-passphrase">update your ssh-key passphrase</a>.</p>

<pre>
ssh-keygen -p -f /path/to/ssh_key
</pre>
</div>

#### Configure ssh

```sh
# ~/.ssh/config

# Connect to gitlab.com
Host gitlab.com
HostName gitlab.com
Preferredauthentications publickey
IdentityFile ~/.ssh/id_ed25519
```

<div class="alert alert-info" role="alert">
<p>If you want you can also use <code>ssh-agent</code>, but if you plan to use GPG to sign messages, <code>ssh-agent</code> you can replace with <code>gpg-agent</code>.</p>

<p>More information you can find in here: <a href="https://unix.stackexchange.com/a/250045">gpg-agent instead of ssh-agent</a>.</p>
</div>

### Synchronize your dotfiles

I like to make my files synchronized with my remote repository - this helps me to update main origin when my local changes arise.

```sh
mkdir -p ~/privatespace/github.com/egel
cd ~/privatespace/github.com/egel
git clone git@github.com:egel/dotfiles.git
```

Re-linking the files that was directly downloaded from the repo, in order to get full synchronization with the private dotfiles repository.

```sh
# gitconfig
ln -sf ~/privatespace/github.com/egel/dotfiles/configuration/.gitconfig ~/.gitconfig

# idea (for vim plugin)
ln -sf ~/privatespace/github.com/egel/dotfiles/configuration/.ideavimrc ~/.ideavimrc
```

<div class="alert alert-info">
<p><b>Optional:</b> In my configuration I setup few additional files, that help me manage my dotfiles. Like storing private passwords, having additional private configurations, ect. Those files by the design are meant NOT BE STORED under version control systems.</p>
<p>Also make sure the files have correct permissions, only for you.</p>

<pre>
touch ~/.zshrc.local
chmod 600 ~/.zshrc.local

touch ~/.envpass.private
chmod 600 ~/.envpass.private
</pre>
</div>

#### Verify your connection

At this moment you should check if your connection is established. Running the command the second time should give you message with your git user.

```sh
ssh -T git@gitlab.com

# run it 2nd time, to get user
$ ssh -T git@gitlab.com
Welcome to GitLab, @john.doe!
```

### GPG

<div class="alert alert-warning">
    Before starting this section make sure you know and understand why signing your own commits may be so important for you. I better explain this in my another article: <a href="{{ site.baseurl }}{% link _posts/2019-03-24-the-lesson-of-verifying-git-commits.md %}">The lesson of verifying Git commits</a>.
</div>

Let's start with basics, like linking configuration folder with local directory.

```sh
mkdir -p ~/.gnupg
ln -sf ~/privatespace/github.com/egel/dotfiles/configuration/.gnupg/dirmngr.conf ~/.gnupg/dirmngr.conf
ln -sf ~/privatespace/github.com/egel/dotfiles/configuration/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
ln -sf ~/privatespace/github.com/egel/dotfiles/configuration/.gnupg/gpg.conf ~/.gnupg/gpg.conf
ln -sf ~/privatespace/github.com/egel/dotfiles/configuration/.gnupg/sks-keyservers.netCA.pem ~/.gnupg/sks-keyservers.netCA.pem
```

Now, download your gpg keys (private & public) for all your accounts private (or/and work), as we will add them to gpg configuration in order to sign your things (like commits, private emails).

```sh
gpg --import public_key.asc
gpg --import private_key.asc
```

Get your gpg fingerprint as we will need to use in git. Execute command below and get "signingKey" = last 16 chars of your fingerprint key. (I add arrow, to make it easier for you).

```sh
$ gpg --list-secret-keys --with-fingerprint --keyid-format LONG your@email.com

                     |- this would be your "signingKey" ------- |- or here
                     ▼                                          |
sec   rsa4096/RPGLBRKNFTAZ2S9K 2019-03-17 [SC]                  ▼
      Key fingerprint = VXE7 T2QX FCJZ YQ6L BEGJ  MLMM RPGL BRKN FTAZ 2S9K
uid                 [ unknown] John Doe <johndoe@example.com>
ssb   rsa4096/EBEE77C5734494A6 2019-08-23 [E]
```

Restart `gpg-agent` in order to use latest configuration.

```sh
$ killall gpg-agent
2023-03-27 15:13:12 gpg-agent[2253] SIGTERM received - shutting down ...
2023-03-27 15:13:12 gpg-agent[2253] gpg-agent (GnuPG) 2.4.0 stopped

$ gpg-agent --daemon
2023-03-27 15:14:46 gpg-agent[2253] gpg-agent (GnuPG) 2.4.0 started
```

Fill the key in `~/.gitconfig.local`. So it's look more-less like:

```ini
[user]
    user = "John Doe"
    email = johndoe@example.com
    signingKey = RPGLBRKNFTAZ2S9K

[commit]
    gpgsign = true
```

Test applied config by reloading terminal and commit something, to see if your commits are signed successfully.

```sh
git commit -S "test commit with signing"
```

If everything will went successfully, you should get pinentry window, like the one below:

![GPG pinentry-mac][img-gpg-pinentry-mac]

### Vim & Neovim

Without a doubt vim is the king of simple text editors. Many of you may argue, but I don't want to lead you astray 😆. When I discoverd vim, I was so much confused "why the heck there is so much noise about this thing"! After looong time later, I understood why and I wrote [Is worth to know the Vim Editor and why?][post-is-worth-to-know-the-vim-editor-and-why] and [The Vim's hidden superpowers][post-the-vims-hidden-superpowers].

Let's start as usual with configuring vim and neovim.

```sh
# nvim (my primary editor)
mkdir -p ~/.config
ln -sf ~/privatespace/github.com/egel/dotfiles/configuration/.config/nvim ~/.config/nvim

# vim (after switch to nvim, using this config rarely)
ln -sf ~/privatespace/github.com/egel/dotfiles/configuration/.vimrc ~/.vimrc
ln -sf ~/privatespace/github.com/egel/dotfiles/configuration/.vim/ ~/.vim/

# Open nvim & vim and install plugins via
:PlugInstall
```

![iterm2-nvim][img-iterm2-tmux]

### Tmux

[Tmux](https://github.com/tmux/tmux/wiki) - terminal multiplexer and [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm).

```sh
# link configuration
ln -sf ~/privatespace/github.com/egel/dotfiles/configuration/.tmux.conf ~/.tmux.conf
ln -sf ~/privatespace/github.com/egel/dotfiles/configuration/.tmux-osx.conf ~/.tmux-osx.conf

# install tmux-plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# type this in terminal if tmux is already running
tmux source ~/.tmux.conf
```

Open new session abd type `tmux new -t new`. Next, install plugins from the `.tmux.conf` file via <kbd>prefix</kbd> + <kbd>I</kbd> (pay attention, it's big "i". Prefix = <kbd>ctrl</kbd> + <kbd>b</kbd>).

![iterm2-tmux][img-iterm2-tmux]

#### ZSH + oh-my-zsh

I was positively surprised that by default M1 use zsh shell.

![terminal-default-shell][img-terminal-default-shell]

Install missing oh-my-zsh

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

##### Theme

For years I use [honukai](https://github.com/oskarkrawczyk/honukai-iterm-zsh) theme, as it gives me best orientation in the shell.

```sh
mkdir -p ~/.oh-my-zsh/custom/themes/
curl https://raw.githubusercontent.com/oskarkrawczyk/honukai-iterm/master/honukai.zsh-theme -o ~/.oh-my-zsh/custom/themes/honukai.zsh-theme
```

Reopen terminal to apply changes.

### System Preferences

#### Screenshots

For all types of screen records, I use default mac screenshot tool, with some combinations from Snagit. The combination of both give the fastest experience to finish a screenshot or record a screen for documentation.

I like to have one path for all type of screen records and usually choose something like:

```sh
# Set new default path
defaults write com.apple.screencapture $HOME/Documents/Screenrecords

# kill current UI to apply new write path (no worries, it will not destroy anything)
killall SystemUIServer
```

#### Finder

Setup list view as a default view for all folders.

1. Open hard drive view (usually it's called "Macintosh HD")
1. Press <kbd>⌘</kbd> + <kbd>j</kbd>

![Finder hard drive settings][img-finder-harddrive-settings]

Next after accepting "Use as Defaults", open terminal and remove all `.DS_Store` files from system used by the Finder, in order to remove all overrides (finder save all meta data about folders in .DS_Store).

```sh
sudo find / -name ".DS_Store"  -exec rm {} \;
```

Additionally, I like to **display file extensions** and **sort folder first**, therefore my usually setting for finder window is like following:

1. Open finder
1. Press <kbd>⌘</kbd> + <kbd>,</kbd> to open window "Finder Settings"

![Finder settings][img-finder-settings]

#### Trackpad

For the mac trackpad I like to setup 2 things I am so get used to, that I cannot imagine work without:

**Swiping between screens with 4 fingers**

![Preferences trackpad swipe screens][img-preferences-trackpad-swipe-screens]

**dragging elements with 3 fingers**

![preferences-accessibility-pointer-control][img-preferences-accessibility-pointer-control]

#### Displays

I think this is pretty standard, although having one screen in vertical position is very helpful as this sometimes enable to look on things from different perspective.

![preferences-displays][img-preferences-displays]

#### Desktop & Stage Manager

In new version of macOS Sonoma, they introduce widgets on the desktop. One of the new default
features is when user will click on the background it reveals the desktop.

I prefere to disable this feature and below paste small video-tutorial.

![disable-stage-manage-on-desktop][gif-desktop-and-stage-manager]

#### Disable dictation

![do-you-want-to-enable-dictation][img-do-you-want-to-enable-dictation]

<div class="alert alert-info">
<p><b>Disclaimer:</b> at the moment of writing macOS Sonoma recently removed the option to complately disable this annoying dictation feature on M1 macbooks.</p>
</div>

The least annoying option I found so far, is to change the current key to the custom mapping that is difficult to click. For example <kbd>Ctrl</kbd> + <kbd>Option</kbd> + <kbd>Shift</kbd> + <kbd>⌘</kbd> + <kbd>&#92;</kbd>

This simple soliution is also proposed in [Permanently disable "Enable Dictation" keyboard shortcut in Monterey](https://apple.stackexchange.com/a/445750/236340).

![preferences-keyboard-dictation][img-preferences-keyboard-dictation]

---

## Additional libs and setups

### NVM & yarn

```sh
# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# install specific version of node
nvm install 18
nvm alias default 18

# test
which node
node --version

# apply changes
source ~/.zshrc
```

#### yarn

Yarn is connected to version of node running, so best way to install it is via current used node/npm.

<div class="alert alert-info">
<p><b>Info</b>: If you will use many node versions (via <a href="https://github.com/nvm-sh/nvm" target="_blank">nvm</a>), you also should to install yarn for each node version.</p>
</div>

```sh
# install yarn globaly
npm install -g yarn

# test
yarn -v
```

### Ruby

Follow my other post how to setup ruby on macOS - [If possible do not use the ruby system version on mac osx][post-ruby-system-version-on-mac-osx]

Standard link for configuration file

```sh
# create symlink from dotfiles dotfiles repository
ln -sf ~/privatespace/github.com/egel/dotfiles/configuration/.gemrc ~/.gemrc
```

### Python

Follow my other post how to setup python on macOS - [How to properly set up Python project?][post-how-to-properly-set-up-python-project]

### JAVA

I did not found better way to install Java, like through [SDK-MAN](https://sdkman.io/). I am not much fan of Java but this is really awesome Java Version Manager similar to `rbenv`.

To install it start with:

```sh
# install
curl -s "https://get.sdkman.io" | bash`

# test if succeeded (or reload terminal)
skd version
```

<div class="alert alert-info">
In case you wondering, my configuration for SDK-MAN you can find in my <a href="https://github.com/egel/dotfiles/blob/main/configuration/.zshrc">.zshrc</a>
</div>

### Apple Silicon - Rosetta

Some programs may require installing Apple's rosetta

```sh
softwareupdate --install-rosetta
```

[img-iterm2-font]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/iterm2-font.png
[img-iterm2-window-theme]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/iterm2-theme-minimal.png
[imgiterm2-general-selection]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/iterm2-general-selection.png
[img-iterm2-final-window]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/iterm2-final-window.png
[img-iterm2-import-gruvbox]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/iterm2-import-gruvbox.png
[img-item2-with-hack-nerd-font]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/item2-with-hack-nerd-font.png
[img-item2-with-hack-font-standard]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/item2-with-hack-font-standard.png
[img-preferences-displays]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/preferences-displays.png
[img-preferences-accessibility-pointer-control]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/preferences-accessibility-pointer-control.png
[img-preferences-trackpad-swipe-screens]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/preferences-trackpad-swipe-screens.png
[img-finder-harddrive-settings]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/finder-harddrive-settings.png
[img-finder-settings]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/finder-settings.png
[img-terminal-default-shell]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/terminal-default-shell.png
[img-iterm2-tmux]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/iterm2-tmux.png
[img-iterm2-nvim]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/iterm2-nvim.png
[img-gpg-pinentry-mac]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/gpg-pinentry-mac.png
[gif-desktop-and-stage-manager]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/preferences-desktop-and-stage-manager-disable.png
[img-do-you-want-to-enable-dictation]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/do-you-want-to-enable-dictation.png
[img-preferences-keyboard-dictation]: {{ site.baseurl }}/assets/posts/setup-macbook-m1/preferences-keyboard-dictation.png

[post-how-to-properly-set-up-python-project]: {{ site.baseurl }}{% link _posts/2022-01-30-how-to-properly-set-up-python-project.md %}
[post-ruby-system-version-on-mac-osx]: {{ site.baseurl }}{% link _posts/2018-11-10-if-possible-do-not-use-the-ruby-system-version-on-mac-osx.md %}
[post-is-worth-to-know-the-vim-editor-and-why]: {{ site.baseurl }}{% link _posts/2015-04-06-is-worth-to-know-the-vim-editor-and-why.md %}
[post-the-vims-hidden-superpowers]: {{ site.baseurl }}{% link _posts/2020-11-29-the-vims-hidden-superpowers.md %}
[post-loop-through-previous-arguments-from-command-line]: {{ site.baseurl }}{% link _posts/2022-03-27-loop-through-previous-arguments-from-command-line.md %}

[weblink-nvm]: https://github.com/nvm-sh/nvm
