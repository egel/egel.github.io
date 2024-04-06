---
layout: post
title: Use shell only for small to medium size programs
tags: [shell, bash, sh, zsh]
---

I have seen, written, and edited in may carrier many small, medium, and large-size shell programs, both in pure `sh` and `bash`. The major thing I have learned over this period of time with shell-scripting are the following patterns:

-   use shell to write only small scripts
-   use shell to write small-to-medium size scripts ONLY when used by a singular operating system, or when frequently executed in pipeline
-   if your shell program becomes larger and more complex consider using some more verbose language with good testing capabilities
-   if you are writing scripts that MUST BE cross-compatible to different systems, consider using compiled languages that can produce you easy-to-download binaries for your users

## Reasoning

In following sections I will try to summarize for you my thoughts in which situations shell-scripting is usefull, and when it could be worth consider replacing it different solution.

Although I have to honestly say, there is no right or wrong solution. This case is no different, and every situation could have own advantages and disadvantages. Therefore there are some cases where let's say, building a lagre shell script was a better solution then the following other altervative way.

If you ask any resonable IT person, will tell you "it depends" as the ultimate answer to almost any IT questions. And in most cases they will be right. Weird! ...but true.

### Small size

Writing shell small and impactful scripts is awesome experiance. With just a few lines of code that work out of the box on almost any Linux or macOS systems, is very easy and get the job done fast. You basically perfectly covering the famous 80/20 rule.

In this moment you have all the benefits of automatizing your idea in almost the blink of an eye, and same time be able to execute it with almost no dependencies. Sometimes you must download a few additional programs to make it work, but this is a relatively very small cost to the effort you put in. Additionally, there is an enormous amount of great CLI tools that can be easily downloaded and used.

### Medium

Over time your script gets bigger and grows to MEDIUM size. In this moment you discover for example that:

-   I need to add a few flags to enhance program capabilities
-   or I will need my script to be used by users on different Operating Systems
-   or my script is already quite big (~500 lines of code), and there are no tests, so further expansion will no longer quickly guarantee that any modifications will be without errors.

When this is happening, you should consider revisiting "time & efforts" to the "cost & future expanding".
This is totally valid to ask yourself "What I am aiming for with this script". If you see the end of the expansion, and there will be no need for further modification, finish it and be done with it.

However, if you know that this is just the next chapter, and your script will naturally grow performing more and more tasks. Then this case I most often consider as the last time to provide mandatory test coverage, in order to protect all critical functionality of your solution[^1]. Without this, modifying the script may provide to someone sleepless nights due to amount of errors each modification can produce.

[^1]: Little disclaimer here. I am not saying that when your script is small should not have tests. All your code should have good test coverage, and I am also fan for providing test for the code I ship. Although, in my carrier I saw many small, medium, and large shell scripts without any tests. And when I asked "why there are no tests", there was always some "good" excuse: no time, need to focus on next feature, ect, but I do not agree with it. Without any tests you can't prove anyone that the code you wrote is worth something.

Of course, if you are a skilled person and "you know what you do" (or you do it as non-business critical case) - sure, go on, continue whatever you like to do.

On the other hand, if you need to grow, and this solution simply MUST work, do yourself a favor and focus on providing stability to your code by good test coverage, or finding more suitable alternative. Good candidate it to use othere language with which you can more easily provide a reliable growth of your program with also relatively minimal efforts.

### Large

Ooooh man. You are about to realize that your script is expanding to the size of a small book, or/and you feel already losing control over it. You supporting so many edge cases, or/and injecting more and more complex to understand syntax. It involves into many mysterious code hacks that look like abominated devil incantations straight from the medieval age sorcery book.

If this is true for you this is time to go serious with considering to switch. In these cases some compiled languages are the best option. Mainly to give you, and your developers a better chance to understand successfully contribute in updating, or expanding further your project.

I can't tell you what is best for you, as I mentioned before "it depends" and each case may be different. Although my golden rule that applies the 80/20 rule of all my recent scenarios, is to use Golang with some [cobra][weblinki-github-spf13-cobra] library, or if speed is critical use Zig/Rust. Nevertheless, at this level, any choice will be valid option if comes with good testing tools. Having control over the program and guaranteeing its behavior by good coverage, will bing to you a calm mind and provide reliability to your business.

The other factors that could make sense in choosing some other alternative options then shell scripts are:

-   the easy of use and understanding
-   maintenance over longer period of time
-   how often the solution/language force you apply the changes
-   final program size
-   compilation speed
-   existing knowledge
-   personal/developer preferences

## Conclusion

I believe that shell-scripting is one of the most satisfying things that each software engineer does, despite of the level of expertise.
However, remember to not lock yourself from often reflecting that each case or change in code may be worth considering following a different path than the current one.

[weblink-github-spf13-cobra]: https://github.com/spf13/cobra
