---
layout: page
title: "Theme overview"
permalink: /theme.html
hide: true
---

This page is intended to show most of the elements or techniques used in this blog (HTML, CSS, typography, media, source code, external elements, etc.) to make it easier to work on or to fix them.

## Typography

### Headers

# H1 header

## H2 header

### H3 header

#### H4 header

##### H5 header

###### H6 header

### Body

Example of regular body text. **This part is bold**. _This part is italic._ <s>This part is strikethrough</s>

### Links

<a href="#">Some basic link</a>

or dynamic links to other posts like [Guide to install and configure Debian 12]({{ site.baseurl }}{% link _posts/2025-06-11-complete-guide-to-install-and-configure-debian-12.md %})

### Blockquote

<blockquote>Example of blockquote.</blockquote>

---

## Buttons

<button>Some button</button>

=======

## Alerts

<div class="alert alert-info">Some INFO message</div>
<div class="alert alert-success">Some SUCCESS message</div>
<div class="alert alert-warning">Some WARNING message</div>
<div class="alert alert-danger">Some DANGER message</div>

---

## Inputs

### Default \<input />

`text` type:
<input placeholder="Some placeholder" type="text" />

`number` type:
<input placeholder="Some placeholder" type="number" />

### Input with \<label>

<div>
    <label for="hippo">I am a label for input</label>
    <input name="hippo" placeholder="Some placeholder">
</div>

**Associated label with input** (<a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Element/label">More info</a>)bb

<label for="hippo">I am a label for input
<input name="hippo" placeholder="Some placeholder">
</label>

---

## Tables

| cell 1 | cell 2 | cell 3 |
| ------ | ------ | ------ |
| text 1 | text 2 | text 3 |
| text 4 | text 5 | text 6 |

---

## Lists

### unordered list

<ul>
    <li>one</li>
    <li>two</li>
    <li>
        <ul>
            <li>three</li>
            <li>four</li>
            <li>
                <ul>
                    <li>five</li>
                    <li>six
                        <code> some code block </code>
                    </li>
                </ul>
            </li>
        </ul>
    </li>

</ul>

### ordered list

<ol>
    <li>one</li>
    <li>two</li>
    <li>
        <ul>
            <li>three</li>
            <li>four</li>
        </ul>
    </li>
</ol>

---

## Definitions

<dl>  
  <dt>HTML</dt>  
  <dd>is a markup language</dd>  
  <dt>Go</dt>  
  <dd>is a programming language</dd>  
</dl>

---

## Abbreviations

<p>You can use <abbr>CSS</abbr> (Cascading Style Sheets) to style your <abbr>HTML</abbr> (HyperText Markup Language). Using style sheets, you can keep your <abbr>CSS</abbr> presentation layer and <abbr>HTML</abbr> content layer separate. This is called "separation of concerns."</p>

---

## Images

### Using markdown syntax

![this is fine](/assets/img/template/this-is-fine.jpg)

### Using HTML \<figure> with \<figcaption>

<figure>
    <img src="/assets/img/template/this-is-fine.jpg"
         alt="This is fine">
    <figcaption>Classic meme</figcaption>
</figure>

---

## Video

### Using iframe (youtube)

<iframe width="560" height="315" src="https://www.youtube.com/embed/kQJrgSML5hY?controls=0&amp;showinfo=0&amp;start=10" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

---

## Keyboard

<kbd>cmd</kbd> + <kbd>r</kbd>

## Code

### Inline code with markdown

Normal text and some Markdown syntax for `inline code`

> and also displayed in blockquote `some inline styles`.

### Inline code with \<pre>

<pre>Some code using pre</pre>

### Code block

```ts
// TypeScript
class Giraffe extends Animal {
    constructor(props) {
        super(props);
    }
    ...
}
```

### Code snippets (github)

<script src="https://gist.github.com/mmistakes/77c68fbb07731a456805a7b473f47841.js"></script>
