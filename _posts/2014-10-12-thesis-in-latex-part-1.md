---
layout: post
title: Thesis in LaTeX - part 1
tags: [latex, university, ms-word, libreoffice, vim, sublime-text, atom-editor]
---

In one simple sentence, LaTeX it's an extension of TeX language, although TeX in real life is a collation of macros. This isn't an official definition, rather some sort of visualization - but until a solid definition "what it's actually", we will get soon.

I've formulated the beginning phrase like this, because I'm planning to make a small series of articles when I'll try describe "How to create a professional thesis" and during this process to not catch breathless or get bald ;)

This first part is basically an introduction to text processing. I'll compare commonly known Word/Writer text preprocessors with LaTeX. Furthermore, I'll say something, why LaTeX is actually better option for this kind of documents (documents longer than 10-15 pages, like semester assignments, long scripts, and thesis of course).

You won't find this kind of knowledge so easy (at least I couldn't). If you're interested so far, then let's go! :)

### Listen and learn from mistakes of others

I can honestly say that my first chapter of Bachelor's dissertation went very smooth and petty quick while writing all in MS Word. Yes, I was surprised that in few days I have 20+ pages. Then I sent my work to my supervisor to make some corrections and point weak spots in my 1st chapter, meanwhile, I wrote a few pages more of chapter two and correct many sentences from the first one (but I already sent 1st version of 1st chapter to my supervisor). Then a few days later I get my corrections for first version of 1st chapter. Now begins interesting part, I start wondering:

> How can I merge supervisor's version with my current updates that I did meantime and not spend couple of hours on it?

If you - just like me before - start wondering about this, you've probably noticed that this can become a huge problem, if you don't want to spend few more hours to track every change from your supervisor's corrected version.

While trying to solving this problem using MS Word I felt dizzy and sick. Believe me or not, but these kinds of problems if you use MS Word or LibreOffice Writer, can be just a tip of an iceberg!

Either way, no worry so much :) These points are just warning tips for you and that's why I decided to start this series of articles.

### WYSIWYG or WYSIWYM

It can't be so obvious to all, but MS Word or LibreOffice Writer are programs of WYSIWYG type (What You See Is What You Get). That means, every change in a document, will make an effect on the document you will get back (that what you'll see on the screen). For example, if you type a sentence and in some part of this sentence you'll put 7 spaces, then the final document will contain those 7 spaces - obvious, isn't it? This is an expected behavior for WYSIWYG editors.

But you can easily answer:

> Pfff, I can write as many pages as I want in Word/Writer and it's trivially easy!

The answer is "yes" and "no". It's very easy to write texts in Word/Writer, but only for a short distance. You can also write as many pages as you want, if you don't care about migrating or potentially losing this data in future. Word's documents like `.docx` aren't a plain text, they're actually an archive of multiple sub-objects. If you don't believe me, open any `.docx` file in any archive program to be sure.

Also as I mention in the heading, LaTeX is an extended version of TeX, but TeX is not actually a programming language, though a set of macros that helps you type better. LaTeX in opposite to Word is a WYSIWYM (What You See Is What You Mean) type of editor. In other words, the writer can concentrate on content that he's writing, rather than playing with changing a type of font, size, color or other stuff useless at the moment of writing. That's a true advantage of many, which LaTeX has, but usually not seen nor appreciated by people. Mainly because when you plan to start writing a long document, you should write, not concentrate on the size of the font for chapter or section. You just need to know if this will be a chapter, section, subsection, etc. Everything else should come later.

### My mistakes during the first approach

After writing my BA thesis in MS Word (yes, shame on me!) I can honestly point a few problems that I've met while writing and are worth enough to mention here:

-   During writing, I constantly and accidentally changing or removing a style, probably by some default shortcut. (Usually, the whole document has changed and I didn't notice it in a reasonable time!)
-   Using and defining tons of styles for a document (for a font of subscript, heading 1,2,3..., quoted text, the chapter without numbering... - it's a horror!!! Even for those who constantly writing in Word, but what about if you want to make a break for 2 weeks. You'll probably forget what styles do have and what are their names)
-   Triggering some unidentified keybindings (you're not aware that they exist) can call some default exotic Word's shortcut command and if you didn't notice it on time, then it can make you to check whole document if nothing has changed. (You've got any info log what might have changed)
-   Sometimes I've noticed that some objects just disappear from the screen or has been modified without my conscious action on it (It might be a bug in software).
-   Making a copy of current work. I've saved my work in endless list of names like: `name` + (`version` or `date`) + `.docx`. Then my folder with thesis files contain almost 100 different files and next one was always bigger than previous one. At the end, the first document had 0.3KB and the last one 2.8MB. (That is waste of disc space, moreover, you've no idea which documents among all backup copies you have, has desired part of thesis, because any part of your document can constantly evolve during time)
-   Managing bibliography in Word is literally a horror! Even with additional bibliography managers (What?!? Additional managers for private software? That is wrong or Word wasn't meant to be a tool for writing long documents with multiple bibliography sources!).
    By the way, if you can accomplished all of it using just Word, then learning "how to do with LaTeX" will be far more faster, simpler and much efficient in the final result (I haven't met sharing bibliography between documents in Word/Writer editors)
-   If someone will edit your `.docx` file and won't follow same style for sure will brake identical style certain element in thesis.

Those were a few irritating things I've came across while writing in any kind of WYSIWYG editor a document that is longer than 10-15 pages (2-4 are easy, 5-9 are medium, but 9-15 are hard to maintain. 15 pages are the absolute maximum to balance a length of the document and smoothness writing).

I thought a lot, why this kind of mistake happened to me. Firstly, I wonder, these problems happen to me because I'm a perfectionist - everything should (not must) be in order. But in time I've realized that it wasn't me - I was perfectly fine and still, I am - I just choose wrong tool for this job. **Moral: the tools you'll use matters!**

### If tools matters, so which should I use?

This is also not an easy question because it depends on which kind of typing style you like the most. I've met so many types of people on my way, but in general I can determinate 2 kinds of person when they're facing LaTeX fo the first time.

1.  **"Sure, I'll try"** - this types of people are usually open to new things, even if this new stuff can be a pain for first days/weeks of work with it.
1.  **"I won't do it"** - this types of people are true conservationists. They usually "know what they know" and they don't want to change this state, but want to accomplish the goal - thesis.

This is just results of my observation when I showed the sample texts written in LaTeX to them. If you're in the first group, that is good, but if you assign yourself to the second group, you'll probably suffer a lot during writing completely new things with LaTeX. There's a huge probability that LaTeX won't suit you.

I also must say that writing in LaTeX is that kind of writing which might looks like "programming" (in large part of opinions). Most of the time you'll spend time on using simple text editor, but to be more precise by saing "simple text editor", I mean [SDI, not MDI][weblink-notepad-vs-word]. This is very important basic knowledge. Well, if you don't know what's the difference, take your time, read this article and find it out. I'll wait for you here :)

Ok, Finished? Wonderful! So, to start writing in LaTeX you'll need a **TeX library** (TeXlive, MikTeX or MacTeX) and simple text editor. TeX libs are standard libraries. You'll install them based on which operating system you have (Linux, Windows or OSX), but what is for what, I'll tell you later (it's not important at the moment).

### Text editors

By writing this heading I feel like I've just put a stick in an anthill. _Why?_ This topic is so enormously huge, that I'm afraid, even a few big books couldn't completely fulfill all aspects about text editors.

Although, I can get you a fair start. I'll point you 2 best articles about comparison of multiple text editors (includes some IDEs) and also say which editors I like the most until this moment and why I like them. I think is the fare start :)

Take a peak on below websites:

-   <http://tex.stackexchange.com/q/339/48903> - This's the richest source of knowledge I've came across until now. You'll find there REALLY smart comparison for almost any popular editor you can choose from.
-   <https://en.wikipedia.org/wiki/Comparison_of_TeX_editors> - yes, I know it's a Wikipedia page (not reliable source of truth), but this article has outstanding comparison table. It's also worth to compare which editor suites you the most.

I like two editors the most. Among LUI type, I definitely prefer [Vim][vim-webpage] with [latex-suite][latex-suite-website] plugin. If you want to start with Vim, I can recommend you my [dotfiles][egel-dotfiles], but not as a ready-made solution, rather as a handy help to begin your journey with Vim and its configuration. If you're wondering or hesitating right now (and like I was before) if it's really worth to begin the long learning journey with Vim, I highly suggest you to read my another article called [Is worth to know the Vim editor an why?][post-is-worth-to-know-the-vim-editor-and-why].

From the GUI type, my favorite one is [TeXstudio][texstudio-webpage] and here I wrote another article ~~[How to configure TeXstudio]({filename}configure_texstudio.md)~~ where I describing how to smoothly start with this program and why to use it for writing LaTeX. I also very like [Sublime Text 3][sublime3-webpage], although it has more common with usual text editor, rather with LaTeX IDE (here I've wrote my thoughts about [Discover the Sublime Text 3][post-2014-08-16-discover-the-sublime-text-3]).

I won't try to convince you which one is better because it basically doesn't matter. You can follow my footsteps and try one of those, which I mentioned above. Nevertheless, decision which one to start with, I'm laying on your hands.

I hope you won't be disappointed because as a programmer I have my "writing standards", important features to me while typing. Those editors have gorgeous features (especially Vim!) that's why I use them, even after work to my personal purposes. But unfortunately, they haven't candy-like appearance if you demand this from a modern text editors (I'm looking on you Atom, Sublime or IntelliJ).

### Online alternatives vs local TeX library

Nowadays, we're not obligated to use only locally installed programs. There are few online tools, which can replace editor and TeX compiler only by entering a website. One is Overleaf and another is Sharelatex (In few years they want make a fusion). So there are similar alternatives that might suit you, but most interesting features like git integration, will demands from you an extra charge (or buying the subscription).

We can achieve this all with even much more high-security level without paying a single penny (only for amortization of your computer and electricity). Here you have:

**Why is better to have it locally, than in one of those services?**

-   Working offline
-   Much faster compilation on local machine
-   Your data is on your hard drive (some services have regulations that if it's free account, your work can be treated as the property of them, so they can use it for own purposes)
-   If you want you can secure yourself form a data-loss with version control systems like exsample [Git][git-website]
-   Free, unlimited collation using version control systems
-   If afraid that your computer can break down during work (i.e: hard disc failure), you can secure data with any instant cloud store synchronization (dropbox or mega). TeX files are just text files, so they are small and light, ideal to be quickly synchronized.

### Installing standard TeX library

This part should be piece of cake to you, if you get so far here. Well DONE! (I know that it could have been difficult because many things have been said, those positive and also negative and you can fell confused).

There are 3 most popular standard TeX libraries (for Linux, Mac OSX and Windows):

-   [Texlive][texlive-webpage] - available on Linux
-   [MacTeX][mactex-webpage] - for Mac OSX
-   [MikTeX][miktex-webpage] - for Windows

For Windows and Mac OSX installation is trivial. You're downloading an installer, follow the wizard and that's all.

> In this moment I highly recommend installing a full library. We're living in times that 1-2GB of data are no longer a problem and full installation can prevent LaTeX beginners from errors like "no installed package" (some packages are differently named, a name of package and name of a used library sometimes can be difficult to find or debug).

For Linux users full installation looks even simpler:

```sh
# Debian based systems
sudo apt-get install texlive-full biber
```

And that is all for this part. IMHO those are the best information how to quickly start with LaTeX. Also, obtain answers to those questions that are not easy to get.

### Next part

But "how to start building a LaTeX thesis", I'll discuss on next article [Thesis in LaTeX - part 2][post-thesis-part-2]. I'll base my implementation on [uekthesis][uekthesis-repo] class, which I've created for my university: Cracow University of Economics, but it can be modified and adjusted for any other University requirements in a fly (we'll also do it).

[post-thesis-part-2]: {{ site.baseurl }}{% link _posts/2014-10-19-thesis-in-latex-part-2.md %}
[post-is-worth-to-know-the-vim-editor-and-why]: {{ site.baseurl }}{% link _posts/2015-04-06-is-worth-to-know-the-vim-editor-and-why.md %}
[post-2014-08-16-discover-the-sublime-text-3]: {{ site.baseurl }}{% link _posts/2014-08-16-discover-the-sublime-text-3.md %}
[weblink-notepad-vs-word]: http://technology.blurtit.com/114838/what-is-a-basic-difference-between-a-notepad-and-microsoft-word
[git-website]: https://git-scm.com/
[egel-dotfiles]: http://github.com/egel/dotfiles
[uekthesis-repo]: https://github.com/egel/uek-latex-thesis-class
[vim-webpage]: http://www.vim.org/
[latex-suite-website]: http://vim-latex.sourceforge.net/
[texstudio-webpage]: http://www.texstudio.org/
[sublime3-webpage]: https://www.sublimetext.com/3
[texlive-webpage]: https://www.tug.org/texlive/
[miktex-webpage]: http://miktex.org/
[mactex-webpage]: https://tug.org/mactex/
