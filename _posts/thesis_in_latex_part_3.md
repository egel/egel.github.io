Title:      Thesis in LaTeX - part 3
Slug:       thesis-in-latex-part-3
Date:       2015-04-06
Status:     published
Category:   Self improvement
Tags:       latex, university

<!--
<div class="intro-article-image-md" markdown="1">
  ![LaTeX logo]({filename}/images/LaTeX_logo.png)
</div>
-->

In this article I will try to explain how to prepare front page for our thesis in LaTeX. I&nbsp;will also say something about good practices in writing and how to proper format the content into LaTeX files using the built-in commands. Furthermore I will show you how to use other commands provided by additional packages for LaTeX.

I assume, that for this moment, you have read previous both articles [part 1][1], [part 2][2] and also you have prepared your computer's work space.

Dear Reader, you have come one of the hardest paths, which was mandatory to begin becoming **LaTeX Ninja**. You have interested and spent your time to understand LaTeX better and by this fact LaTeX will repay you with (related with time you have spent) fabulously enjoyable writing even the biggest and the most complicated documents. Believe me or not but, that is big, even if you not realize it yet.

Getting back to our main goal of the article. We will make front page of our thesis. This might be tricky in some aspects, especially if we will make this from the ground. Although after read and understand this article you should be able to make your own templates or adjust the existing themes to your needs.

## Making of the thesis front page
To make the front page of our thesis, we will begin from defining own class of the document.

> But why you want to define our own class and just not make a simple file with the content?

Of course, this front page can be put in separate file. I insert it into a class, mainly because this content (front page) is totally repeatable. Almost every thesis from the same university and department probably will have identical copies (beside few variables like: topic, supervisor, author name, index number, ect.). Every other aspect like formatting of content could be identical. That is the main reason why I put it into a class, that in further you can fork and adjust for your needs for specific situations.

In below example, I named my class `uekthesis`, because of the fact, that I used to go to the University of Economics in Cracow (UEK), hence the decision to implement this name was obvious ;)

> It is true that the class we will create together is by default prepared for a model for graduate work at the University of Economics in Cracow (in full compliance with theses requirements), but everything prepared cleverly into the class change the default content for the template will be extremely easy and simple.

So lets begin with crating out new file `uekthesis.cls` which will be a heart of out document.

This document which I have created is extensive, so putting its whole fragments into this article is useless (but I am not hiding that I would like to discuss every more important part of it). Although I have built `uekthesis.cls` in such a way, that reading and understanding of it by other users could be as simple as possible. Additionally almost every fragment of the code is commented, so there is little chance that you will lost into it :)

Now if I describe the basics, we can get into more important fragments of `uekthesis.cls` and strangely enough I will not say about the code of the class (I will not offend you and your intelligence - the basic analyze and how things works you can make on your own), but I will say something about the configuration, because I my opinion is enough to easy and enjoyable usage or even adjusting to the requirement from your university (department).

The most important knowledge about `uekthesis.cls` are the global variables that I used to in the document and special class options.

> Yes, I know, I know ...global variables is generally in the modern programming that is the pure evil. But LaTeX is not the language typically object-oriented (of course there are: classes, functions, variables, but the philosophy of their programming is completely different from OOP), so I simplified the discussion about the class as much as possible, to not spend too much time on constructing the class file, but to focus on maximum readability for the users. So I encourage you strongly to get involved and cooperate with the created class [uekthesis][3] or read up a complete example of the finished document in my repository on Github [latex-thesis-example][4] or if you prefer I have a [live online example][sharelatex-uekthesis].

### The uekthesis class
The class contains a set of few configurable options allows to adjust individual parts of the document for get the desired results.

Option should be entered in the main file for our document. In our case, the file is `main.tex`, while the line configuration is, of course:

```latex
\documentclass[nazwy_opcji_odzielone_przecinkami]{uekthesis}
```

So in the example we will have:

```latex
\documentclass[male, authorStatement, indexNumber, fileVersion, ]{uekthesis}
```

#### The uekthesis configuration options

*   `male` or `female` - this option sets the configuration of the sexes for the author of the document and is used in other options if there is a need to personalize their gender (ex.: `authorStatement`). If none of the options is not specified, the default is set: `male`.

*   `twoside` - this option sets the configuration of the work on the two-sided. *It is not the least of two-sided printing*, since the print job, and the system are two completely separate things. If no option is specified, the defaults: `oneside`.

*   `indexNumber` - this option sets the index number of the student. It display on 1 page (front page) to inform the audience about the author's index number. If the option is not set, the default is disabled (Off).

*   `fileVersion` - this option sets the version number of the document. Is displayed on 1 page (title page) in order to inform the users which version of the document is currently dealing with (particularly helpful for the writer or promoter). **For the final version of the work, this option should be disabled**. If the option is not set, the default is disabled (Off).

*   `authorStatement` - this option sets the standard statement of the author of an independent execution of work (often, this option is required by the universities directly in the document work).
     If the option is not set, the default is disabled (Off).

That would be enough of configuration options the appearance and behavior of the class. Now we come to the previously mentioned global variables performing the function of direct personalization of classes for our document.

#### Global variables of uekthesis
We already know that global variables available in the class of `uekthesis` that is the form of personalization our document class. Thanks to this variables we can define the basic information ie.: name of the author, university faculty, the name of the promoter, the index number of the student, and many, many other data.

So let's start from the complete code in our `main.tex` file. We will move from the general aspects to the particular examples. Same variables were quite intuitively named, so I should not be much of a problem with deciphering what they are, but if that was not enough, each line is marked with informative comment. Major portions will be discuss a bit lower.

```latex
\globalFullAuthor{Maciej Sypień}    % Pełna nazwa autora pracy
\globalShortAuthor{M. Sypień}       % Autor - zwięzła forma wydruku
\globalFullTitle{Projekt i implementacja autorskiego systemu zarządzania treścią}  % Pełny tytuł pracy
\globalShortTitle{Projekt i implementacja autorskiego CMS}  % Krótki, zwięzły tytuł pracy
\globalFullUniversity{Uniwersytet Ekonomiczny w Krakowie} % Pełna nazwa uniwersytetu
\globalShortUniversity{UEK}                           % Skrócona nazwa uniwersytetu
\globalDepartment{Wydział Zarządzania}                % Wydział
\globalDegreeprogramme{Informatyka Stosowana}         % Kierunek studiów
\globalThesisType{Praca dyplomowa}                    % Typ pracy dyplomowej
\globalSupervisor{prof. n. dr hab. Jana Iksińskiego}  % Promotor
\globalAcknowledgements{Dla moich rodziców oraz najbliższych przyjaciół za niezłomną wiarę w~moje zwycięstwo.}   % Podziękowania
\globalFileVersion{0.1.0}   % wersja pliku (przy włączonej opcji "fileVersion")
\globalIndexNumber{123456}  % numer indeksu (przy włączonej opcji "indexNumber")
\globalCity{Kraków}         % miasto
\globalYear{2014}           % rok powstania pracy
```

Lets begin with, that we define here all the variables, even those which do not call in the options class. This practice is required by LaTeX notation. However, despite that define them all, it does not mean that we will use all of them (I assumed that not everyone will want to use the example: `fileVersion`). From what we show or hide into the thesis we use [uekthesis configuration options][6] :)

All variables were use the notation `lowerCamelCase` and have enriched my prefix "global", which reminds of its range in relation to the whole document. The prefix is my solution to unify the notation of variables and by no means is the default notation LaTeX.

Most of the variables also includes their abbreviated counterparts. These acronyms are used in places where you can not use the full name (mainly for typographical reasons), so also be sure to you have turn it on.

That would be enough with uekthesis class configuration. It was not so hard, was it? So many options is enough to fully personalize the class, without unnecessary nesting in the structure of the code.

Those who willing to improve project quality, I encourage you strongly to fork and share my [example of uekthesis class][4] on Github :)

## Work with external packages

LaTeX has wide rage of options to configure for creating documents. From small letters, through short works, to end up with huge, complex with hundred of pages documents or book.

In this section I will show you how to external packages with `graphicx` package, but it also will apply to any other package.

To use any package you have to you have to declare its usage into [preambule of the document](). Then we are going to our `main.tex` and we declare its usage with `usepackage{}` command. For better understand this illustrate below snippet.

```latex
\documentclass[male, indexNumber, fileVersion, twoside, ]{uekthesis}
\usepackage[utf8]{inputenc}
...
\usepackage{graphicx}
...
\begin{document}
```

Since this moment, we can use all commands from `graphicx` package into our document. As you can see, the idea is so simple :)

> Please note that, in order to add new packages directly in the `.tex`, they must be installed (of course once). Windows has a package manager called *MiKTeX*, which in the current version automatically draws the needed packages when compiling the file. On Linux, you can install all the packages into one convenient command: `apt-get install texlive-full`. I mentioned this in the [first part][1] article.

### graphicx

This package is created to easily manipulate images in TeX files. It has simple construction and it should not be intellectual challenge while using commands from its interface.

#### Example 1.1

```latex
\includegraphics[scale=0.5]{images/lion_1.jpg}
```
This short line attach image into the document and scales it to 50% of its default size. The source of the image takes the path: `images/lion_1.jpg`.


#### Example 1.2

```latex
\includegraphics[width=12cm]{images/lion_2.jpg}
```

This short line attached to the document image with the desired width, in this case 12cm. It is a very useful option especially when we want to get always the same picture size regardless of the size of the input image.

> Of course, the bigger the picture, the better final quality (because image has a certain size), but increasing the quality will be paid for with an increase in the weight of the resulting file work.

It is also possible there are other very useful options instead of sample "12cm" put the width of the command:

```latex
\includegraphics[width=\textwidth]{images/lion_2.jpg}
```

This makes the width of the photo will always be equal to 100% of the width of the page. Here you also need to be careful, because if the image is not properly trimmed can cover the entire page and push the text to sidelines of the document.

#### More examples
To find more examples I will refer you to nice article about [how to attach graphix to the LaTeX document][7]. Despite of the fact that wiki is not reliable and always up to date source of information, but in this case the article is quite fine and clear.


## Good practices
This chapter is in fact a very large topic, which can not be closed in a few narrow tips (maybe someday expand it enough, to make it a separate, full-fledged article).

Here are some best practices, which I read or develop myself through time. This advises are especially for creating large documents such as thesis.

#### Divide the chapters into files
Each chapter should have its own separate file. So you can easily manipulate their order with the main file (in our case it was a `main.tex`), as well as shorten the compilation, if a finished chapter contains extensive logic (ex.: dynamic creation of graphical models for chemical compounds).

#### Creating paragraphs
Creating a new paragraph always start with a new line. To continue the idea of the previous paragraph also use the command `\noindent`, it deletes (created by default) indentation in the text (it is responsible for the `indentfirst` package). Such practices will ensure better alignment and adaptation of content to the entire contents of the documents (including tables, pictures, mathematical formulas, ect.)

Example below:

```latex
Here is a very long paragraph shorting one specific idea of the author \dots

And for another, the insanely long paragraph containing another author's another thought.

\noindent On the other hand it is also the next paragraph, however, that by using the command \texttt{\noindent} does not contain a default created indentation. It symbolizes the continuation of the thoughts of the previous paragraph.
```

#### Use indentation to better illustrate the content
A principle which applies more to programming, rater the ordinary writing. But LaTeX is not a *normal* system of writing, so the rules should be taken from both worlds.

Indentation may help you to orientate in your document. LaTeX uses a lot of special characters in its notation and among other things they are characters `{}` or `[]`. These signs are grouped the content and some of their combinations should be separated to each other, while others can be written one after another.

Example for a better picture of the situation:

```latex
This is plain text that contains \textbf{bold font}, but also the written
\textit{italic}. In contrast, this text will be {\large adequately larger}
and the {\small reduced accordingly}.

Below appears a tiny table:

\begin{table}[t]
  \begin{tabular}{l|c}
    Name    & Surename          \\ \hline \hline
    Stefan  & Batory            \\ \hline
    Juliusz & Słowacki          \\ \hline
    Maria   & Skłodowska-Curie  \\ \hline
  \end{tabular}
\caption{Caption for my simple table.}
\label{my-simple-table}
\end{table}
```

#### Convert tabs to spaces

This practice allows convenient editing of the text, both in the text editor of your choice (God forbid, I'm not talking about the Microsoft Word!) and other text editors. Each editor has a different interpretation of the default sizes tabs to spaces - for some it is 2, 4 or even 8 spaces. Hence, the text could looking really nice in your editor, but if someone else open it (for example your supervisor) it could look like "Nightmare on Elm Street".


* * *

I think that as a beginner level of difficulty for the article, so should be enough. I would like to thank you for your attention and will remain with me until last phrases.

Full example for this article you will find into link below. It includes a complete, working code.

<a href="https://www.sharelatex.com/project/543abd9e69870b1d3e39c3f8" title="Full online example" class="btn btn-primary">Full online example</a>

* * *

At this point, I invite you to the next and probably the final 4th part of creating a thesis:

*   overview of existing bibliographic applied (for all but especially for Polish);
*   we will implement the full bibliographic system with `biblatex` + ` biber` for our document;
*   and will join at the end of the document lists of: bibliography, figures and tables.

This will be one of the most interesting articles in a series, as it works with ready examples of implementation of the `biblatex` and `biber` is RARE (in particular Polish LaTeX community). At the date of publication of this article, the above combination seems to be the most effective solution for storing and formatting bibliographies. At this moment I would love to, to invite you for next article from this series :)

[1]: http://egel.pl/thesis-in-latex-part-1.html
[2]: http://egel.pl/thesis-in-latex-part-2.html
[3]: https://github.com/egel/uek-latex-thesis-class
[4]: https://github.com/egel/latex-thesis-example
[5]: http://git-scm.com/
[6]: #the-uekthesis-configuration-options
[7]: http://en.wikibooks.org/wiki/LaTeX/Importing_Graphics
[sharelatex-uekthesis]: https://www.sharelatex.com/project/5713903dee119a314abcad5d
