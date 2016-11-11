---
layout: page
title: R
---

## Details to remember

### ggplot2

+ To plot a density distribution without the x-axis line, use `stat_density(geom="line")` (and eventually `position="dodge"` if plotting several groups).

### Run a OS command

Use `system2` instead of `system`. It's more portable apparently.

### Order in condition assessment

Using `&` and `|` operators, *R* tries all the conditions and then performs the operations. However sometimes in sequential assessment is preferable. Especially with `&`. For example, we get an error if we run:

~~~r
x = NULL
if(!is.null(x) & x>10) message("so big !")
~~~

Because it tries to do `x>10` when *x* is *NULL*. What we want is `&&`:

~~~r
x = NULL
if(!is.null(x) && x>10) message("so big !")
x = 17
if(!is.null(x) && x>10) message("so big !")
~~~

Now it won't try to do `x<10` if `!is.null(x)` is not true (because what's the point, anything "*False AND ...*" is for sure *False*).

### Get RPubs working

`options(rpubs.upload.method = "internal")`

## Rmarkdown

### Jekyll website

The `Rmd` files located in the `_source` folder get automatically compiled by `servr` package using this command:

~~~sh
Rscript -e "servr::jekyll(script='build.R', serve=FALSE)"
~~~

To define *knitr* parameters, I add a chunk at the beginning of the Rmarkdown document:

~~~md
```{r include=FALSE}
knitr::opts_chunk$set(fig.width=10)
```
~~~

### Beamer presentation

Some useful options to put in the YAML header:

~~~yaml
title: The TiTle
subtitle: The Subtitle
author: Jean Monlong
date: 11 Oct. 2016
output:
  beamer_presentation:
    slide_level: 2
    fig_width: 7
    includes:
      in_header: header.tex
    toc: true
    keep_tex: true
~~~

+ `slide_level` defines the header level to be considered as a new slide.

To add slide count I put this on the `header.tex`:

~~~tex
\setbeamertemplate{navigation symbols}{}
\setbeamertemplate{footline}[page number]
~~~
