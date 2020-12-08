---
layout: post
title: The Vim's hidden superpowers
modified: 2020-12-04
tags: [text-editor, vim, macOS]
---

Many people ask me why I like Vim so much. Usually, I hear that _"this is an ancient editor and you should use something more modern"_. My answer sounds almost always like: "it depends on what I need".

The fact I love Vim doesn't change another fact, that I use also other text editors or IDEs during work. The reason behind it is because configuring Vim to do some special, sophisticated tasks can be tedious, difficult and a lot time-consuming. 

### Vim vs. IDE

For example, configuring Vim to work as a real IDE is hard and here I mean the configuration, not for a single programming language like - _Vim as Python IDE_. No, this should not be so difficult. I rather think about configuring Vim as IDE for multiple languages - THIS is difficult. 

Using Vim's powers only for 1 language would be just so much waste of the greatness this text editor brings to the table. As a webdeveloper, I use multiple languages (not only a single one), so for me, it's not sufficient to have a Vim config designed to operate only for a single language. I am using daily: Typescript/JavaScript, HTML/CSS, Golang, C#, Python, SQL. So now I need to pick what I want? Or having a config for each language? Crazy!  No!

Therefore I use Vim almost exclusively for efficient document edition or creation but in sense of a single operation which takes a max of a couple of minutes. Vim is extremely efficient for opening and editing even multiple GBs of files. Although, Vim was not designed to work in a single window session for multiple hours (like IDEs doing it) - believe me or not, but I've already tried that multiple times with a different set of configurations and workflows. Of course, if someone is stubborn and wants to do it, will do it, but it does not make much sense for me so far.

At this time on the scene enter IDEs. Editors on steroids, designed for great development experience, and when mastered, they increase developer's productivity far more than just regular text editors. I very much like IDEs, especially when working multiple hours doing standard CRUD operations on files, saving to git, sending to server, comparing between branches - Ay Captin', they are great for this. Period! 🙌

### An example where vim is showing off

However, recently I received a task that was perfect to show off how effective Vim could be and how it can save your time during development!

The task was simple while working in pairs on the issue. I had to implement a tedious creation of a C# dictionary from a list of countries I've received from a client in a CSV file (you can download it below), so my colleague could utilize it in his program.
There were 351 rows with <code>ISO Code</code> and the <code>name</code> of that country in English - quite simple.

[![ISO CODE list]({{ site.baseurl }}/assets/img/isocodelist.png)]({{ site.baseurl }}/assets/img/isocodelist.png)

> [Here is the file]({{ site.baseurl }}/assets/files/countrycode.csv) to download and try it out.

Ok, then "copy & paste" into the Vim and we get something like this:

```
Domain Name,Ref Code,Ref Description
COUNTRYCODE,-,-
COUNTRYCODE,AFGH,Afghanistan
COUNTRYCODE,ALAB,Alabama
COUNTRYCODE,ALAN,Åland Islands
COUNTRYCODE,ALAS,Alaska
...
```

Let's get rid the first line (the one with column names) and `COUNTRYCODE,` by column editing.

<img alt="Removing COUTNRYCODE up to coma" src="{{ site.baseurl }}/assets/videos/vim-1.gif" width="100%" height="auto" />

We have a nicely prepared file. Now we should focus on the next part - building our macro where the whole magic will happen.

But before jumping into writing, let's think for a second - _how we can construct this macro?_ 🧐 - because the whole trick lies in it.

The plan is to record a "smart" macro for a single line and later repeat it for all other lines. But again - _how to build this "smart" macro?_ - To do this we have to think about what kind of pattern we could notice by looking at our cleaned file? Let's look at a fragment of this file:

```
...
ARKA,Arkansas
ARME,Armenia (Republic)
ARMES,Armenian S.S.R.
AUS,Australia
...
```

We have:

1.  a single word (code of country) `ARME`. Irregular length of characters. Sometimes 3, other time 5.
2.  then comes a coma (`,`) character
3.  and at the end the full name. It may be long and contains multiple spaces or even other characters.

Well, the simplest way I could think of, would be something like `I{"<ESC>ea"<ESC>wi"<ESC>A"},`, and the version with a full macro to `q` register could look like this:

```
qq<ESC>I{"<ESC>ea"<ESC>wi"<ESC>A"},<ESC>q
```

> FYI: `<ESC>` = represents a single key on the keyboard (escape)

<img alt="Recording macro" src="{{ site.baseurl }}/assets/videos/vim-2.gif" width="100%" height="auto" />

The last step would be to repeat this macro to all other lines (the first line is already done).

```
VG::normal @q
```
<img alt="Executing macro over the lines" src="{{ site.baseurl }}/assets/videos/vim-3.gif" width="100%" height="auto" />

Yes, the core of our class is almost done. The last part would be to wrap it in a class and our work is done! Wow! Honestly, even when I know about Vim macros, this still impresses me. 

> Disclaimer: This task could also be accomplished with any editor which supports a multi-cursor feature (like in SublimeText or IntelliJ). But if this task would be a bit more complex (let's say, we would have additional 3rd and 4th columns) AFAIK only Vim would be able to do it with its "motion operators" (another superpower of Vim).     

So, the final result should be like this:

```csharp
namespace MYPROGRAM.API.Features.FeatureA {
    public static class CountryCodes {
        public static Dictionary<string, string> Countries = new Dictionary<string, string> {
            {"AFGH","Afghanistan"},
            {"ALAB","Alabama"},
            {"ALAN","Åland Islands"},
            {"ALAS","Alaska"},
            {"ALBA","Albania"},
            {"ALBE","Alberta"},
            {"ALGE","Algeria"},
            ...
            {"YUKO","Yukon Territory"},
            {"ZAMB","Zambia"},
            {"ZIMB","Zimbabwe"},
            {"ZZZZ","Non taxable countries"},
        };
    }
}
```

### Finishing notes

And here we are, at the end of this trivial presentation "what Vim could do for you". 

In last finishing lines I would say that as a programmer while doing some task I am usually time-constrained (previously estimated) to prepare a feature. Therefore, I don't have luxury to spend all of it on searching new tools, which could help me accomplish repetitive tasks. The decision is most of the time simple: searching a solution for a few minutes and if I can't find something that solves my problem quicker then I do it with existing knowledge/tools. Sometimes, it require writing using some CLI program, sometimes a small script, and literally if noting else can help, I must apply changes manually. With Vim manual changes are really rare. Honestly, I don't know any other tool which so easily and simple help me with accomplishing the result I need.

The true advantages of Vim don't show up because editor is developing more then 30 years and it came along with "multi-line" cursor. Today we have 2020 and any more advanced editor have multi-cursor. Its true power is hidden in **motion operators** (w, e, b, etc.), explicit diverge for typing **modes** (insert, visual, block, etc.) and **macros**. IMHO, those 3 makes from Vim an ancient artifact with superpowers. Once mastered, the man can make things the others can only dream about 😉.

Thank you for your precious time and reading this article.

