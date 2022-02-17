---
layout: post
title: How to properly set up Python project?
tags: [python, macos, pyenv, nutshell]
---

When you want to use Python or have an existing project written in it, you will inevitably stand before a question about which Python version you should use?

But you would question yourself, "why this might be a problem"? The core of the story begins with fact that all operating systems usualy having own versions of python installed and supported/maintained by default by the authors of Operating Systems. They use those specific versions to fulfill their needs in systems. Then you, developer, when you wanted to start a new project you may be tempted to use a version of Python installed in your system. It will work normally, as usual, and you will not notice any problems possibly until the next upgrade, when your OS may upgrade the system version of your Python and puff... something in your project stopped working due to some changes in the version of Python (which may be difficult to find/diagnose). A good rule to remember is: **using the system version of Python (or any other language) is usually perceived as bad practice**, so please don't do use any system default version for development purposes.

Over the years, the Python community developed a better and more secure way to handle this fragile problem - it's called a _Virtual environment_. You can think about it as an encapsulated environment, where you can use any version of python you wish, which is additionally saved to the other elements of your system.

At the time of writing this article, there are at least a couple of ways to set up a virtual environment, although I find the `pyenv` and `virtualenv` as the most suitable/versatile tools for this role.

## How to set up a virtual environment?

I will be basing my example on the macOS system, but I believe it can be also translated almost 1:1 to other operating systems by utilizing its own package managers.

### Installing pyenv

Install `pyenv` in your system. It will install a program that will be managing your python versions. I.e.: it's something similar like `nvm` for NodeJS or `rbenv` for Ruby.

```bash
brew instal pyenv
```

> If you using ZSH you may need to add to your `.zshrc` & `.zprofile`.
>
> ``` bash
> echo 'eval "$(pyenv init --path)"' >> ~/.zprofile
> echo 'eval "$(pyenv init -)"' >> ~/.zshrc
> ```
>
> You may need to reload the terminal, so the changes could be applied.

In case of further readings, follow installation instructions in the official documentation <https://github.com/pyenv/pyenv#how-it-works>.

### Install python via pyenv
Now, we want to install a version of python, which we will be using for our application or also for other applications (it is like reusable python executives which can be shared).

I will pick the latest version just for demo purposes `3.9.7`.

```bash
# pyenv install --list`   # list all available python versions to install
pyenv install 3.9.7
```

I also like to change my default/system Python version and use the one from `pyenv`, therefore in pyenv I set up a global system version and thanks extending `.zshrc` and `.zprofile`, each time I will open a new terminal I will be using the version of python I set as global system version in `pyenv`. Awesome!

```bash
pyenv global 3.9.7
```

Reload a terminal again, and try out if everything has been set correctly. You should get something like this.

```bash
$ pyenv global
3.9.7

$ which python
/Users/myuser/.pyenv/shims/python
```

### Installing Python's virtualenv

We finally using a version of python, which is not a system default version and we have the full access/freedom to install/modify anything, by not using `sudo`! Let's install `virtualenv`

```bash
pip install virtualenv   # FYI: under the hood, it's should use pip3 
```

> If you need to use `sudo` to install some packages, you are possibly doing something wrong. I.e. you as "the user" is not owning "the python", which later may cause some troubles while the development process.

### Initialize new virtal environemnt

Now, when we set up everything, we are ready to massively produce new projects in python.

```bash
cd /to/your/desired/location
virtualenv venv   # will create new venv directory in your location.
```

new directory `venv` is a directory (you can change the name to anything else, although I usually use always `venv`), which should be kept out of the repository. In venv directory, there is all information on how to set up a virtual environment for your executable python version. you don't need to modify it, it's only just FYI. 

At the moment, everything is ready to activate the virtual environment and start the fun!

```bash
$ source venv/bin/activate 

(venv) 
$ 
```

After activating, your prompt will change, and at the top, you will get printed the virtual environment name you are using. It's expected and it will remind you that you are still it.

If you want to quit this virtual environment and do something else, you can quit by typing (see below), and your prompt will quit the venv.

```bash
(venv)
$ deactivate

$ 
```

## Conclusion

That's all. As in all programming languages, there are always some nuances that are good to know before start working - as in general, they may save some time/frustration/problems and help you focus on developing things instead of fighting with them. 

Thanks for reading, hope you enjoy it. Wish you happy coding sessions and with that knowledge create something great!
