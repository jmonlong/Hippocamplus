---
layout: pagetoc
title: Markdown
---

## Converting Markdown into nice HTML pages

I use [markdown-styles](https://github.com/mixu/markdown-styles) tool. I installed it through `sudo npm install -g markdown-styles`.

To convert a Markdown document:

```sh
generate-md --layout witex --input example.md --output output-example
```

The themes I like:

+ `witex` looks like LaTeX, i.e. old-school scientific.
+ `jasonm23-markdown` looks more modern and web/blog like.
+ `thomasf-solarizedcssdark` is a simple solarized theme.

It can convert linked multiple pages and some themes have a sidebar. For now I use it for single document conversion.


## Jekyll websites

[Jekyll](http://jekyllrb.com/) websites are simple Markdown documents that can be converted into a website. [GitHub](https://pages.github.com/) uses it to provide a website for a repo. 

### Themes

There are several themes [available](http://jekyllthemes.org/). My favorite are the two [Poole](http://getpoole.com/) themes, Hyde and Lanyon.

### Table of Contents in Javascript

I use [this Javascript plugin](https://github.com/ghiculescu/jekyll-table-of-contents) to generate the table of contents of the pages.
