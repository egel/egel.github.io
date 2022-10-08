---
layout: post
title: Hop through previous arguments of your past commands
tags: [macos, linux, terminal, iterm]
---


Something around 2018, I discovered a small productivity feature, which leverages my command-line experience to the next level of speed. Now, I want you to know about this awesome trick as well. Let's go!

It was not so obvious to me at the beginning what I am dealing with when I discovered this feature. I read some articles on the web where after pressing `Alt` + `.` in the terminal, you could start iterating through previous arguments of your past shell commands...on the fly, instantly! At this moment I thought, "ehhh... yet another boring, not worth my time thing". Although I will give it a try, I was amazed at how useful it is.

It may sound silly, but it's well-visible when you try it on your own. Just imagine when you had to type a long and complex path in some of your previous commands, and after a few others, now you write the next command, which you could reuse "this long path" you used before. *What do you do then?* 
Are you going back, copying it, and pasting it common again?
or, are you trying to remember and retype it?
Some people are strivng to be lazier (efficient), and they use some system clipboard managers and get back by 2-3 clicks. Although, imagine you can reuse them with just 1 click away. Guess what..., after pressing `Alt`+`.` you could resurrect those long and complex past parameters you previously typed in the terminal exactly now while writing your current command and continue rocking on further. This is so a stupidly brilliant and extremely effective trick.

<!-- Add gif with live example -->

But it would be too perfect to be true, if this great feature would be available for everyone - unfortunately, at the moment, this neat feature is only available in the ZSH shell.

## How to configure it?


### iTerm
In your ~/.zshrc paste the following code below. This will adjust your configuration to have correct
key binding in your terminal.

```shell
# ZSH key-bindings
# specyfic for OS
case $(uname -s) in
  Darwin)
    bindkey '^[.' insert-last-word # insert last word (Alt+.)
    ;;
  Linux)
    bindkey '\e.' insert-last-word # insert last word (Alt+.)
    ;;
esac
```

In the last part, we need to correct the behavior of the `Alt` key in the terminal so it starts behaving as expected.

[![iTerm Enable Alt as Esc+]({{ site.baseurl }}/assets/img/terminal_enable_alt_in_iterm.png)]({{ site.baseurl }}/assets/img/terminal_enable_alt_in_iterm.png)

As you already possibly noticed I changed the key to only one Alt key (left). The reason did it, is to preserve
a default writing compatibility while using special characters in languages other than English. For instance, in the Polish language, 
`Alt` + `<letter>` produce special characters, like `Alt` + `l` = `ł`.


### IntelliJ terminal

If you want a similar case to have in IntelliJ, just update in Settings and search for the "Terminal" section
and enable "Use Option as Meta key". 

[![IntelliJ enable Alt as Meta]({{ site.baseurl }}/assets/img/terminal_enable_alt_in_intellij.png)]({{ site.baseurl }}/assets/img/terminal_enable_alt_in_intellij.png)

Puff! Done. I hope you will enjoy this small tiny and incredibly powerful feature, as I do. Now go,
and do your magic 😉.

Thanks for reading and until next time. 
