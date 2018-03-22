---
layout: post
title: Thesis in LaTeX - part 2
tags: [latex, university]
---

I assume, that at the moment of reading this second part of writing the thesis in LaTeX, you have already read the previous [part 1][thesis-part-1] and install the required software. If you do then perfect, carry on, but if not you should catch up.

In this part, I'll try to do some very basic introduction **How to use LaTeX in practice**. Although it won't be so easy - not by writing, because paper can take everything - the real thing hides into a simple question, which will begin the next section.

## The goal

The question is:

> How condense a huge amount of knowledge in acceptable short time for an average person?

You can't read this article (the whole series) for more than 5 days in a row, that's obvious. In this time, you could read few good books which are far more detailed about the LaTeX then my humble article.

But this series of articles have some advantage over other publications I've met while I was writing this post. Books are a long and solid portion of knowledge - articles, by its definition, should be a short and affordable piece of information that last 10-15 minutes.

My main goal for this series is to provide those small affordable portions, moreover assure and show you, that creating thesis in LaTeX is **the best you can get in a reasonable period of time** (despite the fact that you need to learn LaTeX).

By the way, if you are interested to work as scientists or any technical person, this quote below might be inspiring for you to make a good decision and invest some of your time to learn it;)

> "LaTeX is the de facto standard for the communication and publication of scientific documents." - Get from official LaTeX webpage <https://www.latex-project.org/>

## Awareness of possible complexity

LaTeX can be scary, I agree, with its complex examples and "programming" syntax for some of you definitely. Nevertheless, those examples are very rare for an average document. In this part, I'll only guide you through the basics of LaTeX and point the best practices which I discovered during few years of writing - It'll be a very good starting point for you.

## Creating a basic document

TeX is a compiling type of text processor. In plain words that means it
generates from source files the final product (whatever file it would be `*.dvi`, `*.pdf` or whatever it might be) and during this process, it creates some helping metafiles to achieve this final result. So please, don't panic if, among your source files, some another will arise - that's a norm for LaTeX.

I recommend starting by creating a new folder with some obvious name for you (and you, after a while). I would suggest using `yourFirstName_yourLastName_thesis` and the folder should lay in a location easy get - because you'll use it regularly. As a programmer, I often use `~/workspace` as a container of my projects (mostly git project), but any other reasonable location is also fine, for example: `~/Desktop`. It should be easily accessible for you.

Well, we've got a folder location for your thesis. This is important because LaTeX generates many meta files while preparing final result - in our way it'll be a PDF file. The structure of files is essential for managing your project in future.

The most commonly used files that we'll create and maintain during the writing will be: `.tex` and `.bib`.  

The `.tex` is actually a plain text file with TeX macros inside.

The `.bib` files are related with bibliography and store all positions which can be used (or not) in our thesis. The `bib` files can be understood as our bibliography management file (or many files, because you can use multiple of them in one LaTeX document) and they can be used in many other documents (i.e: you can share the file with your friend, colleague, supervisor).

We create 4 simple text files:

*   `main.tex`
*   `chap_one.tex`
*   `chap_two.tex`
*   and `chap_three.tex`

The first one (`main.tex`) will store the whole configuration for our document.

> It is good practice to separate chapters to different files, mainly for a further quick feature of enabling or disabling it.  Because of it, later in time, you can change the order of chapters in a fly. Moreover, you can collaborate on a document with other people and they can focus only on their's part without having so many conflicts into the document (yes, Git I'm talking to you). 

Probably, as you already noticed, the names of files which represents chapters begin with `chap`. It's not required to work (because you can define any name for your files), but this convention is also known as namespace or pointers and it's commonly used in LaTeX documents - more on [LaTeX labels and cross referencing][wiki-latex-labels-and-cross-ref].

The namespace **chap** stands for a word "chapter" and it's a great help when you need to work with multiple elements, but more details about this we'll cover later.

### Preamble and the actual document

Any new document, whether it's an `article`, `report`, or perhaps a `book`
(There is a number of different ready-made patterns) consists normally of
so-called **preamble** and the **document**.

> This name `document` can be a tricky word for the first time. Because in lazy thinking "document" is a physical document that you can hold. But in the meaning of LaTeX syntax, "document" refers to the content of a document written by the author.

Preamble
:   This is a collation of rules which program must know before it generates
final document.

Document
:   This is a place where author writing a text of the document and using proper commands for formatting text.

The standard and also the simplest preamble (not quite for thesis) looks similar to this below:

```latex
\documentclass[12pt, oneside, a4paper]{report}
\usepackage[OT4, plmath]{polski}  % definition of using platex
\usepackage[utf8]{inputenc}            % UTF-8 for multiple languages
\usepackage[OT4]{fontenc}
\usepackage{url}
\title{Project and implementation of content management system}
\author{Maciej Sypień}
\date{\today}
```

Commonly, the preamble is being inserted into the main file of our work, the `main.tex` file (as I told you, the name can different, as you like, but conventionally it's the name of the main file). 

Chapters will contain only the content of the document (without preamble) because they will be directly included in the main document - it helps a lot in further maintenance.

It is worth mentioning something about classes. The class generally is in short a set of rules that define how the document will look like. LaTeX already contains predefined classes, for example, a few of them are mentioned earlier:

*   book
*   report
*   article
*   letter

Fairly well illustrated, this a line
`\documentclass[12pt, oneside, a4paper]{report}`, which is clearly written a definition of  class `report` and its optional arguments as **font size**, **type of printing** and **the document size** of the resulting paper.

This is only a small part of the wide range of available options, because each of these classes (book, report, etc.) may contain the same optional arguments, but also other not defined in any of the core classes.

These words aren't in order to frighten you, rather advise that it sometimes you should refer to the documentation of the used class, but paradosically the newly created classes often tend to be very poorly documented - usually due to lack of time to maintain it properly.

The second part of the content of the document. From the writer point of view, this is most important. The "document" contains content which appears later in the output file. Look for the like the example below:

```latex
\begin{document}
\maketitle

\begin{abstract}
This document presents few rules of how things goes into \LaTeX.
\end{abstract}

\chapter{Our first chapter}
% 1st section
\section{Text}\label{sec:tekst}
\LaTeX\ allows to the author to manage numbering of section, lists, refering for tables, pictures and other elements. I~easy way we can refer to the formula  \ref{eqn:wzor1}.

% 2nd section
\section{Math}\label{sec:math}
Below formula presents the possibilities of \LaTeX\ with writing math. The equations are automatically numbering, just like other elements, which were mention into section~\ref{sec:tekst}.

\begin{equation}
  E = mc^2,
  \label{eqn:wzor1}
\end{equation}

where

\begin{equation}
  m = \frac{m_0}{\sqrt{1-\frac{v^2}{c^2}}}.
\end{equation}

% ---------------------------------------------------------
\chapter{Our second chapter}
This is a very long content of the second chapter.

\section{Section of second chapter}
\label{sec:sec_of_2nd_chap}
This is very long content of second section of second chapter.

\subsection{This is a subsection of the second chapter}
\label{subsec:podsekcjaRozdzialuDrugiego}
This is a very long content of subsection of the second chapter.

% ---------------------------------------------------------
\chapter{Our third chapter}
This is a very long content of the third chapter.

\section{Section of third chapter}
\label{sec:sec_of_3rd_chap}
This is very long content of first section of third chapter.

\subsection{Subsection of first section of third chapter}
\label{subsec:sub_sec_of_3rd_chap}
Very long content of subsection of the third chapter.

\end{document}
```

Above snippet contains the actual content of the document and you have probably noticed that the actual content begin phrase `\begin{document}` and end `\end{document}`. However, one big file can be difficult to edit and navigate, especially when it contains more than 1000 lines.

So I have to talk something about: How to split the whole document into smaller pieces and also why it so important?

### Splitting document into smaller pieces

As I mentioned before, we'll divide our document into smaller parts, that every single chapter will land into a separate file.

The file `main.txt` should look like this:

```latex
\documentclass[12pt, oneside, a4paper]{report}
\usepackage[OT4, plmath]{polski}   % definition of platex
\usepackage[utf8]{inputenc}             % UTF-8 encoding
\usepackage[OT4]{fontenc}
\usepackage{url}
\title{Project and impementation of the copyright content management system}
\author{Maciej Sypień}
\date{\today}

\begin{document}
\maketitle

\begin{abstract}
This document presents few rules of how things goes into \LaTeX.
\end{abstract}

\tableofcontents
\clearpage

\include{chap_intro}
\include{chap_1}
\include{chap_2}
\include{chap_3}

\end{document}
```

As you see, the main file of our document is simple, clean and well readable. Every chapter is attached by `\include{}` command - and yes it can be written also without additional `.tex` extension ;) It's very comfortable because the writer can clearly read the file name and don't be bothered himself by its extension.

But back to our chapters. Each of them begins usually. You just write what you need, to fill the content. For better visualization of this situation, I'll
paste some snippets.

Prologue, **chap_intro.tex**:

```latex
\chapter{Wstęp}
Here will be the place of the prologue for our extensive thesis :)
```

First file, **chap_1.tex**:

```latex
% 1st section
\section{Text}\label{sec:text}
\LaTeX\ allows to the author to manage numbering of section, lists, refering for tables, pictures and other elements. I~easy way we can refer to the formula \ref{eqn:equation1}.

% 2nd section
\section{Math}\label{sec:matematyka}
Below formula presents the possibilities of \LaTeX\ with writing math. The equations are automatically numbering, just like other elements, which were mention into section~\ref{sec:text}.

\begin{equation}
  E = mc^2,
  \label{eqn:equation1}
\end{equation}

where

\begin{equation}
  m = \frac{m_0}{\sqrt{1-\frac{v^2}{c^2}}}.
\end{equation}
```

Second file, **chap_2.tex**

```latex
\chapter{Our second chapter}
This is a very long content of the second chapter.

\section{Sekcja rozdziału drugiego}
\label{sec:sec_of_2nd_chap}
This is very long content of second section of second chapter.

\subsection{This is a subsection of the second chapter}
\label{subsec:podsekcjaRozdzialuDrugiego}
This is a very long content of subsection of the second chapter.
```

Third file, **chap_3.tex**

```latex
\chapter{Our third chapter}
This is a very long content of the third chapter.

\section{Section of third chapter}
\label{sec:sec_of_3rd_chap}
This is very long content of first section of third chapter.

\subsection{Subsection of first section of third chapter}
\label{subsec:sub_sec_of_3rd_chap}
Very long content of subsection of the third chapter.
```

Dividing of our whole document into separate fragments didn't bring us some astonishing results (just for now), you'll appreciate these changes when these files (chapters) grow up to hundreds of lines. Then this organization will allow you to much more efficient work while writing (i.e.: when you want to omit some chapters, you just comment `\include{}` command with `%` sign, then recompile the document and you're done.

<a href="https://www.sharelatex.com/project/543aad2f69870b1d3e39c26b" title="Full online example" class="btn btn-primary">Full online example</a>

I think that pretty much it for this part. Thank you for your attention and leave a comment if you like it.

* * *

But if you didn't hate LaTeX yet, and you still want to get know it better, I'll be pleased to invite to next, a third part which will contain:

*   we will discuss LaTeX's elements (environments)
*   how to add and use new packages?
*   essential **good practices** during writing in LaTeX
*   and we will produce a title page for our thesis

...well, fun will be guaranteed ;)

[thesis-part-1]: {{ site.baseurl }}{% link _posts/2014-10-12-thesis-in-latex-part-1.md %}
[wiki-latex-labels-and-cross-ref]: https://en.wikibooks.org/wiki/LaTeX/Labels_and_Cross-referencing
