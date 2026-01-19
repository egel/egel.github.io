---
layout: post
title: Installing the Latest Neovim on Debian 12
tags: [linux, debian, nvim]
---

Sometime ago, I was installing new servers with Debian and encountered a well-known dilemma for Debian users: having older versions of some programs in the standard repository. This isn't necessarily a bad thing. It's a characteristic of Debian's commitment to stability over having the absolute latest package versions. However, in this case, I wanted a more up-to-date version of Neovim for development, local debugging, and efficient administration.

This post will guide you through installing the latest version of Neovim on Debian 12 for the `amd64` architecture using the `apt` package manager.

At the time of writing, the version of Neovim in Debian 12 is `v0.7.2-7`, which is significantly behind the latest stable version, `v0.11.5`. By the time you read this, it might be even newer.

The installation process is straightforward but requires installing additional software to compile Neovim from source. Don't panic! Compiling from source isn't rocket science, and I'll guide you through each step. Plus, you'll learn how to update your Neovim version quickly, allowing you to keep your system up-to-date.

## Before You Start

Before we begin, remove any existing Neovim installation from your system. This is essential because attempting to install from source with Neovim already installed can result in errors like "nvim is already installed." This typically happens when Neovim was previously installed using `apt`, `apt-get`, or another package manager. If so, you _must_ uninstall it before compiling from source.

```sh
# Check if you have Neovim already installed
which nvim

# Uninstall the current Neovim
sudo apt remove neovim
sudo apt autoremove && sudo apt clean
```

## Installation from Source

Installing from source is relatively simple. We need the source files and additional packages required for compilation.

```sh
# Install required packages
sudo apt install ninja-build gettext cmake curl build-essential git

# Optional:  Useful for copying text to the system clipboard
sudo apt install xclip
```

Next, clone the source files into a local directory. I prefer cloning for better repository management, but you can also download the zip file and unpack it in a directory (e.g., ~/Downloads/neovim).

```sh
# Clone the source files
cd ~/Downloads
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
```

Now for the core part. We'll prepare the repository for building and create a Debian package directly from the source files. This will create a final package ready for installation.

```sh
make CMAKE_BUILD_TYPE=Release
cd build && cpack -G DEB
sudo dpkg -i nvim-linux-x86_64.deb
```

That's it! You can now enjoy your newly installed Neovim editor.

## Appendix: Additional Languages and Packages

When working with Vim or Neovim, I find certain packages exceptionally useful. Here are some categories and programs I frequently use with my Neovim configuration (https://github.com/egel/dotfiles/tree/main/configuration/.config/nvim).

### Fuzzing

```sh
sudo apt install fzf
sudo apt install ripgrep # for search with fzf
```

### Lua

```sh
sudo apt install lua5.4
sudo apt install luarocks
```

### Golang

The easiest way to install the latest version of Golang is to use the precompiled binary. I'm using version v1.25.1, although this might be outdated when you read this. Check https://go.dev/dl/ for the latest version.

```sh
# Update system packages
sudo apt update && sudo apt upgrade

# Download and unpack the binary
cd ~/Downloads
wget https://golang.org/dl/go1.25.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.25.1.linux-amd64.tar.gz

# Add to .profile or .zshrc
echo "export PATH=/usr/local/go/bin:${PATH}" | sudo tee -a $HOME/.profile

# Reload profile to activate the changes
source $HOME/.profile
```

### Install Rust and Cargo (with tree-sitter)

```sh
curl https://sh.rustup.rs -sSf | sh

# Install tree-sitter
cargo install tree-sitter-cli
```

### Node + Typescript

Typescript is used by tree-sitter for installing additional syntax highlighting. To install Typescript, we need Node. I use nvm to manage Node versions. Version 22 is the LTS version at the time of writing.

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
nvm install 22
nvm alias default 22

# Update npm to the latest version
npm install -g npm@latest

# Install Typescript
npm install -g typescript
```

The full configuration for `nvm` variables resides in my `.zshrc` file.

```
# Test in nvim
:echo exepath("node")
:echo exepath("npm")
```

### Python

Install a global version at the system level.

```sh
sudo apt install python3 pipx
```

I also install `pyenv` for better Python version management.

```sh
curl -fsSL https://pyenv.run | bash

# Required when later compiling Python versions from source
sudo apt-get install libbz2-dev liblzma-dev

# Update pyenv
pyenv update

# List all available Python versions to install
pyenv install --list

# Install a Python binary
pyenv install 3.12.11

# Set the global version
pyenv global 3.12.11

# Verify the global version is set correctly
$ pyenv global
3.12.11

# Verify the Python version in use
$ which python
/Users/johndoe/.pyenv/shims/python

$ python --version
Python 3.12.11
```

And that's the end of the article. I hope you enjoyed it! If you have any questions or comments, feel free to leave them down below.
