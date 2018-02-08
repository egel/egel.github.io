---
layout: post
title: Is worth to know the Vim Editor and why?
feature-img: 
tags: [vim, text-editor]
summary: I'll try to gather all my current experience about writing the code, also writing in many text editors and finally express my opinion that is that worth to learn Vi/Vim.
---

This topic has been long on my mind, but in the end, I want to share with you with my reflections on one of the earliest text editors. Yes, I am talking about Vi/Vim.

I will also try to answer a few essential questions for those who would like to give it try, like:

- Is it worth it to know the Vim editor and why?
- The knowledge about Vim can be useful for me in real life, and if so, where?
- Where should I start to quickly become a master ninja of Vim and how long it takes?


### Quick review about Vim

If we take some information from popular Wikipedia, we can find out, that Vim is with us since 1991r. Furthermore, Vi (the elder brother of Vim) gets the year of 1976. Yeah, it is a lot of time, especially in IT industry!

Now, the world takes a lot of changes every day. Connecting to the Internet network, imprinted a giant leap on the software industry, including the software of text editors. There are constantly growing newer and newer text editors projects like:

*   [Sublime][3],
*   [Notepad++][2],
*   or [Atom][4].

But, here I won't talk about huge IDEs, like [Eclipse](), [NetBeans](), [VisualStudio](), or [JetBrains editors family](). These aren't just common text editors, rather a big **I**ntegrated **D**evelopment **E**nvironments.

Now is the time, to ask a question, which found the clear and objective answer can be a difficult task.


### Is it worth it to know the Vim editor and why?

There is a very good question titled [Is learning VIM worth the effort?][5], that I found on StackOverflow portal. It has a lot of fantastic insights and answers about Vim, which I mostly agree. Some opinions may reveal the Vi/Vim religion, which I do not support. Although I like it very much, I think that fining the reasonable level of application usage is the key.

Besides the mention of famous StackOverflow article about Vim and its cleaver answers, you may not find a clear answer about: "Is this knowledge will give me something in real life". Then probably, you would like to know my personal opinion about Vim. So, **I think it is really worth to know Vim** and I did not say that because some otherwise men say it so. Learning Vim and get to know how it works, allowed me to better understand some basic aspects how the software works a few decades ago (and still do nowadays) when there was no GUI interface or mouse/touchpad, just only console and keyboard to operate.

I've also try many text editors before like for example: Emacs, Ed (it's tough!), Mate, Genny, Notepad++, Sublime, Atom and this list is much longer than that, but installation and full configuration of Vim takes me 3 min (downloading my dotfiles and run install - I say about it a bit later).

Don't get me wrong, I didn't say that I'm a fanatic of Vim. I very like the Idea it represents and the knowledge about Vim, teach me how to master my IT skills like for example better servers handling, building better and more sophisticated programs, just simply by understanding how to use it (Vim).

Vim also gives an ability for a very fluent writing and text editing like any other text editor before for almost any kind of text file I've met. Whether I wrote a program, edit file with the unknown extension, configuring some services on remote servers, take notes in markdown or composing my thesis, just anything - Vim will help me to accomplish this tasks perfectly. However, this state of joy while writing appeared to me after some time. You must be aware of it, that if you want to feel a real hacking fun of using Vim, you have sacrifice some time to use it.

### The pros and cons of Vim

The most popular advantages that stay behind Vim are:

-   vim is totally free and always will;
-   supports almost any kind of OS you will use;
-   the most configurable editor of all I've met
    -   themes;
    -   syntax highlighting;
    -   completion;
    -   spell checking;
    -   regular expressions;
    -   sessions (ex: saving the state of current tabs);
    -   macros;
    -   has tons of tested plug-ins for any type action you will do;
    -   and many, many more! see [vimawesome.com][vimawesome-webpage]
-   you can use it in LUI and GUI version;
-   you can write with it in almost any writing style you like;
-   run with minimal memory usage;
-   can be easily run with multiple instances;
-   optimized to open very, very, very huge files;
-   works perfectly on slower machines;
-   works well remotely (i.e. via SSH)

Disadvantages:

-   it can be hard to use as IDE;
-   the learning curve is difficult for newbies;
-   mastering takes time;
-   find a perfect configuration, which suits your needs, may also take time;


### The knowledge about Vim can be useful for me in real life, and if so, where?

Vim (Vi) is probably the most common text editor spread around the world (It is pre-installed by default in almost any kind of machine). This single phrase could be crucial to give it try. But referring to the question, the knowledge about Vim will be useful for you in real life? My answer is **definitely yes**, in fact, that you will bind your life with some kind of IT or educational sector. In other way, this knowledge is worth a lot (because not everyone knows Vim!), but probably it won't be appreciated by the environment co-workers or your boss. Shame!

**Why is that?** In my opinion, if you are really interested in network administration, programming or other related fields with IT sector, you probably will have to deal with some kind of servers. Usually, this kind of staff is stored far away from you (or locked) and can be managed only remotely for ex.: SSH. In this moment any kind of pleasant GUI disappear and you stay alone with blinking console of a terminal. For newbies, the difficulties begin with some magic that is hidden in the terminal console, which in time is forged to daily basis.

When you will work with servers, in most cases you will have an opportunity to open only Vim, because for example a "funny" admin forecast only this way input (that is actually a real situation from my IT career). For the lazies, sometimes you can meet trivial [Nano][6], but it is best only for simple editing. This kind of real-life situation should not rise heart attack when you know the basics of Vi/Vim. In time, by the practice of using Vim, you will understand and start to enjoy working with it - just as I did, and many before me. If you do not believe me, google it ;)

I realize that may sound a bit childish, but this childishness disappears from the face of people that watching you when you suddenly switching between a dozen of terminal windows (ex.: tmux/vim). In this moment they might begin to believe and you can hear something like: "Ok, you have got some skills" ;)

<iframe width="560" height="315" src="https://www.youtube.com/embed/kQJrgSML5hY?controls=0&amp;showinfo=0&amp;start=10" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### Where I should start to quickly become a master ninja of Vim and how long it takes?

Practice, this is where you should start. And yes, there is no other quick way I know, if you want to get used to the hero of this article.

At the beginning, there are always some basic questions, ie.: *how to install Vim?*. A bit later, after the first run, you will notice that the look of Vim does not knock on knees, and even then you find that: "After all, there is nothing at all! Why everyone says, that Vim it is the best. No, hell no!!!".

If at this point your patience is not completely exhausted, the next step is keyboard controls and customize them to suit your needs (as you progress through learning).

The last of the steps, which substantially simultaneously intertwined with learning keyboard controls and general customization, that great power of this editor lay in its configuration (the `~/.vimrc` file). You will discover over time a lot of interesting things about Vim (modes, buffers, plugins), as well as the possibility of efficient typing on a keyboard since the default layout of Vim keyboard controls is not shaped by accident ;)

In fact, this is the end. The only thing you need to do is to try to use Vim as far as possible, and as often as you can. In a relatively short period of time (it took me about a week to get used to it and two months to become addicted to it) you can master it in sufficient detail to enable rapid and smooth operations.

The following slight digression comparing **effort** (Y-axis) and **time** (X-axis) that must be put into a selective group of text editors. As you can see the most interesting curves of all are presented by curves of Emacs and Vim.

![Learning curve of some text editors]({{ site.baseurl }}/assets/img/text_editors.jpg)

However, I cannot leave you without any kind of further hint or help. So for the beginners, (and also advanced hackers), I can recommend you my [`dotfiles`][8] Github repository, which I've made a while ago also for this kind of situations. Among other stuff, it stores my Vim configuration, so it is a good start to gets your own nice configuration.

This repository I've made especially for my Linux OS Ubuntu (but all other based on Debian, like Xubuntu, Mint should also works fine), it also can be used for any other system, but have to be installed manually. In near future, It will also support OSX and Arch Linux distribution! ;)

This repository also contains my keyboard shortcuts in beautiful PDF to download, print or modify by your self in your own fork. Yeah!

Thank you for staying with me to the end. Now, give Vim a try, leave a comment and stay fresh!


 [1]: http://www.microsoft.com/microsoft-hololens/en-us
 [2]: http://notepad-plus-plus.org/
 [3]: http://www.sublimetext.com/
 [4]: https://atom.io/
 [5]: http://stackoverflow.com/questions/597077/is-learning-vim-worth-the-effort
 [6]: http://www.nano-editor.org/
 [7]: https://github.com/egel/code-wiki/blob/master/programs/vim/vim.md
 [8]: https://github.com/egel/dot-files
 [vimawesome-webpage]: http://vimawesome.com/
