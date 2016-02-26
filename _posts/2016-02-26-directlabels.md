---
layout: post
title: Direct Labels in R
tags: R
---

[*directlabels* package](http://directlabels.r-forge.r-project.org/) was developed by Toby and others and tries better place the labels in several types of graphs.

## Installation

~~~r
install.packages("directlabels", repo="http://r-forge.r-project.org")
~~~

## Simple usage

~~~r
library(directlabels)
p = ggplot(...
direct.label(p)
~~~

