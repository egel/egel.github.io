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

### Blockquote

<blockquote>Example of blockquote.</blockquote>

> Anther example of blockquote using markdown.

***

## Buttons

<button>Some button</button>

***

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

***

## Tables

| cell 1 | cell 2 | cell 3 | 
|--------|--------|--------|
| text 1 | text 2 | text 3 |
| text 4 | text 5 | text 6 |

***

## Lists
### unordered list
<ul>
    <li>one</li>
    <li>two</li>
    <ul>
        <li>three</li>
        <li>four</li>
    </ul>
</ul>

### ordered list

<ol>
    <li>one</li>
    <li>two</li>
    <ul>
        <li>three</li>
        <li>Dolor magna qui consequat et aliquip aute proident ipsum. Magna id ex labore velit in ad ullamco. Officia ut cillum id aute aliqua ipsum ex qui labore deserunt.</li>
        <ul>
            <li>four</li>
            <li>Occaecat officia eiusmod adipisicing eu anim sit ut proident nulla. Reprehenderit ipsum dolore in irure do voluptate proident. Adipisicing consequat culpa consectetur est cillum velit enim. Voluptate nulla dolore sint nulla dolor aliqua amet. Minim incididunt magna laborum exercitation amet culpa et pariatur fugiat aute enim pariatur. Aliqua cupidatat amet adipisicing est aliquip Lorem exercitation occaecat minim. Voluptate elit dolore adipisicing ex veniam occaecat laboris incididunt.</li>
        </ul>
    </ul>
</ol>

***

## Definitions

<dl>  
  <dt>HTML</dt>  
  <dd>is a markup language</dd>  
  <dt>Go</dt>  
  <dd>is a programming language</dd>  
</dl>

*** 

## Abbreviations

<p>You can use <abbr>CSS</abbr> (Cascading Style Sheets) to style your <abbr>HTML</abbr> (HyperText Markup Language). Using style sheets, you can keep your <abbr>CSS</abbr> presentation layer and <abbr>HTML</abbr> content layer separate. This is called "separation of concerns."</p>

*** 

## Images

### Using markdown syntax

![this is fine](/assets/img/template/this-is-fine.jpg)

### Using HTML \<figure> with \<figcaption>
<figure>
    <img src="/assets/img/template/this-is-fine.jpg"
         alt="This is fine">
    <figcaption>Classic meme</figcaption>
</figure>

***

## Video


### Using iframe (youtube)
<iframe width="560" height="315" src="https://www.youtube.com/embed/kQJrgSML5hY?controls=0&amp;showinfo=0&amp;start=10" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

***

## Code

### Inline code with markdown

Normal text and some Markdown syntax for `inline code`

### Inline code with \<pre>

<pre>Some code using pre</pre>

### Code block

```ts
// TypeScritp
class Giraffe extends Animal {
    constructor(props) {
        super(props);
    }
    ...
}
```

### Code snippets (github)

<script src="https://gist.github.com/mmistakes/77c68fbb07731a456805a7b473f47841.js"></script>


