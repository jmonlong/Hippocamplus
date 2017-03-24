---
layout: page
title: R
---

{% include toc.html %}

## Details to remember

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

## ggplot2

### Tricks

+ To plot a density distribution without the x-axis line, use `stat_density(geom="line")` (and eventually `position="dodge"` if plotting several groups).

### Align/stack two ggplots

One easy way is to use the `tracks` function in the [ggbio](https://bioconductor.org/packages/release/bioc/html/ggbio.html) package. However I don't really like this package because it sometimes conflicts with ggplot2 (boo!) and you end up having to specify `ggplot2::` to the functions to avoid obscure errors.

I found [another way on the internet](http://www.exegetic.biz/blog/2015/05/r-recipe-aligning-axes-in-ggplot2/):

~~~r
library(ggplot2)
library(gridExtra)
p1 <- ggplot(...
p2 <- ggplot(...
p1 <- ggplot_gtable(ggplot_build(p1))
p2 <- ggplot_gtable(ggplot_build(p2))
maxWidth = unit.pmax(p1$widths[2:3], p2$widths[2:3])
p1$widths[2:3] <- maxWidth
p2$widths[2:3] <- maxWidth
grid.arrange(p1, p2, heights = c(3, 2))
~~~

### Waffle graphs

`waffle` package provides a `waffle` and `iron` function. For example:

~~~r
iron(
  waffle(c(thing1=0, thing2=100), rows=5, keep=FALSE, size=0.5, colors=c("#af9139", "#544616")),
  waffle(c(thing1=25, thing2=75), rows=5, keep=FALSE, size=0.5, colors=c("#af9139", "#544616"))
)
~~~

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
title: The Title
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
