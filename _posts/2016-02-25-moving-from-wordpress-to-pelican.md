---
layout: post
title: Moving from Wordpress to Pelican
category: Diary
tags: [wordpress, pelican]
summary: I'm talking a bit about "why I migrate my blog from Wordpress to pelican", the static pages web framework.
---

I have to start with words "I used Wordpress for 2 years constantly". During this period of time, several times I had problems with basic stuff like uploading and managing images, insert some code snippets (like simple `<pre>` or `<code>` elements), constantly updating framework core, but is not the point.

## Objective of frameworks

IMHO Wordpress is great for PR guys, not for programmers/hackers. PR guys usually want to quickly upload news with few sample photos, and they use for it some [WYSIWYG][wiki-WYSIWYG] HTML editors like [TinyMCE][tinymce-webpage] or [CKEditor][ckeditor-webpage]. These editors can be really "smart" and do an amazing job - saving text with HTML conventions, but after some time you will realize that this kind of making content may not suites you, your idea of writing, which was in my case.

I hope I would not say lie to you that programmers, web admins or hackers really loved Markdown syntax - I loved it. It has a very clean and simple syntax, which can allow you to focus on making some content and do not concern anything else (your content will always have the same generated HTML code).  Markdown power is especially visible for blogs and basic documentation (like simple README files) where you can mainly focus on content with some basic graphics which illustrate the whole content.

In time I realize that kind of magic what those WYSYWIG live editors are making is not for me, not for my profession - programmer. But here not profession is important, but the care about the code you are writing, and that is why programmers and hackers find in those web pages generators a true ally.

## Finding the single point of truth

After a while, I take a look around the market and instantly remembered that is something like static pages generators. After few minutes, I just surfing among some rankings that gather some basic data about many frameworks like this one <https://www.staticgen.com/>.

There are many of them, and most popular at the moment of choosing one was: Jekyll, Gitbook, Octopress, Hexo or Hugo, then was the Pelican.

Why pelican? You will probably as... Hmmm, the answer is simple, because I really like Python language.

I will not favor any of those frameworks because it's pointless and actually depends on user preferences and language taste, then just start writing in it :)

## Pros and cons of migration

As an advantage of migration to static web pages generators I can point:

- Writing directly through your SSH connection.
- Writing posts extremely fluent in Vim or Emacs - I realize that is not an advantage for all ;)
- Improve performance of displaying your webpage (not a database framework is faster than static web generator)
- Improve content visibility by adding many useful plugins (cloud tags, code syntax highlighting, and many more)
- Host it anywhere
- It likes to be [git][git-webpage]-ed ;)
- Making articles in 3 types of text syntax (`.rst`, `.md` or `.adoc`)
- Articles written in markdown can be easy to migrate almost any type of text processors like LaTeX or Word/Writer.

In the other side, disadvantages can be:

- Face the problem of fast and clean migrating HTML content to reStructuredText, Markdown, or AsciiDoc
- Change your habits of directly web editing content into CMS
- Generate content after changes (there are some easy techniques, which constantly watch the content for any changes)

## It is worth it?
If you want to just write a blog or a blog-like page in easy to write syntax (like Markdown) I definitely say YES, it is worth the time.

But if you expect whole next level of writing articles like you do in CMS, turn around and go back to your stuff, you will waste your time implementing it.

[git-webpage]: https://git-scm.com/
[wiki-WYSIWYG]: https://en.wikipedia.org/wiki/WYSIWYG
[ckeditor-webpage]: http://ckeditor.com/
[tinymce-webpage]: https://www.tinymce.com/
