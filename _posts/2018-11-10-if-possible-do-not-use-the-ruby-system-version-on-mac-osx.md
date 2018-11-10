---
layout: post
title: If possible, do not use the ruby system version on Mac OSX
published: true
tags: [ruby, zsh, osx]
---

Recently I have to come through the problem with the installation of a ruby gem on my MacOSX. Usually I would never think that this might be "a problem", but in the ruby system version on mac, yes indeed.

To be honsest with You, I was never a ruby guy, so I always approach the minimalistic setup. Which basically meant, if there is ruby and I can install the software that I need, I'm ok with that setup.

Recently the ruby system version (<code>ruby 2.3.7p456 (2018-03-28 revision 63024) [universal.x86_64-darwin18]</code>) showed me the error like this:

```bash
ERROR:  While executing gem ... (Gem::FilePermissionError)
You don't have write permissions for the /Library/Ruby/Gems/2.3.0 directory.
```

First look in the web what's the best recommendations to solve it and generally the peopele say that the "local ruby managers" should came to rescue and finally resolve the problem. Later, I found 2 the most popular ruby managers which were: `RVM` and `rbenv`. I decided to try with the second one, mainly due to its general simplicity.

Apart of the problem with ruby, I mainly work with JavaScript, so `nvm` (Node Version Manager) is my best friend while working with frontend projects. When I have to deal with different versions of NodeJS and jump between them quickly, the `rbenv` same like `nvm`, solves the problem with simple client interface and more importantly "it just works".

Following [the official tutorial to integrate the `rbenv` with my shell](](https://github.com/rbenv/rbenv#installation)) (ZSH), I did:

```bash
brew install rbenv
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
```

Then restart of my terminal and `rbenv` is there. Lovely!

```bash
$ rbenv --version
rbenv 1.1.1

# checks if the installation has been done successfully
$ curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
Checking for `rbenv' in PATH: /usr/local/bin/rbenv
Checking for rbenv shims in PATH: OK
Checking `rbenv install' support: /usr/local/bin/rbenv-install (ruby-build 20181019)
Counting installed Ruby versions: 1 versions
Checking RubyGems settings: OK
Auditing installed plugins: OK

$ rbenv global 2.5.3
$ gem update --system
$ gem install jekyll bundler
```

Although, that wasn't the end of my problems with ruby.

```bash
bundle install
Traceback (most recent call last):
    1: from /usr/local/bin/bundle:23:in `<main>'
/usr/local/bin/bundle:23:in `load': cannot load such file -- /usr/local/lib/ruby/gems/2.5.0/gems/bundler-1.16.1/exe/bundle (LoadError)
```

What could go wrong? Now when I try to install gems for the projects, the <code>bundler</code> seems not being installed. How? I already installed the bundler and checks if the installation was successful.

The solution to this was to reopen terminal one more time 😅, so all the paths could be added into the <code>PATH</code>. Awesome, now installation of new ruby version and gems (even globally in the system) is a piece of cake!

