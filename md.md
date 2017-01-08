---
layout: page
title: Markdown
---

{% include toc.html %}

## Tips

+ `/` to add some vertical space/break.

## Converting Markdown into nice HTML pages

I use [markdown-styles](https://github.com/mixu/markdown-styles) tool. I installed it through `sudo npm install -g markdown-styles`.

To convert a Markdown document:

~~~sh
generate-md --layout witex --input example.md --output output-example
~~~

The themes I like:

+ `witex` looks like LaTeX, i.e. old-school scientific.
+ `jasonm23-markdown` looks more modern and web/blog like.
+ `thomasf-solarizedcssdark` is a simple solarized theme.

This is fine for simple text documents, but seems to require more efforts to include images and multiple pages. I'm using it to convert single documents, mostly notes.

It would be cool if everything (css, js, even images) was included with the text in one single HTML document. It would allow easy sharing of notes with others online, or host them quickly somewhere. Maybe it's possible, I should investigate. Eventually could I implement it ?

## Converting Markdown into slides

I use [MarkdownSlides](https://github.com/asanzdiego/markdownslides).

## Jekyll websites

[Jekyll](http://jekyllrb.com/) websites are simple Markdown documents that can be converted into a website. [GitHub](https://pages.github.com/) uses it to provide a website for a repo.

### Themes

There are several themes [available](http://jekyllthemes.org/). My favorite are the two [Poole](http://getpoole.com/) themes, Hyde and Lanyon.

### Table of Contents 

`kramdown` automatically creates TOC if it sees : 

~~~markdown
* Is replaced by the TOC
{toc}
~~~

To make it a bit nicer I created a `toc.html` file in the `_include` folder with:

~~~html
<nav>
  <h4>Table of Contents</h4>
  * TOC
  {:toc}
</nav>
~~~

Then I call the TOC in each markdown document using (without the `\`):

~~~markdown
\{\% include toc.html \%\}
~~~


### Math formulas

I use [MathJax](http://docs.mathjax.org/en/latest/mathjax.html) JavaScript display engine. I added to the *head* of the pages:

~~~html
<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" ></script>
~~~

Then inline formulas are defined by `\\(...\\)` (for equations, use `\\[...\\]`), and they follow [LaTeX syntax](https://en.wikibooks.org/wiki/LaTeX/Mathematics).

For example, `\\(\int_{-\infty}^\infty e^{-x^2}\mathrm{d}x = \sqrt{\pi}\\)` produces \\(\int_{-\infty}^\infty e^{-x^2}\mathrm{d}x = \sqrt{\pi}\\).
