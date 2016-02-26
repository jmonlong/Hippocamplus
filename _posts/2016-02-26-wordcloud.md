---
layout: post
title: Word Cloud in R
tags: R
---

I use the `wordcloud` package.

~~~r
library(wordcloud)
~~~

For example with fake words the command would look like that.

~~~r
createWords <- function(w.l=3) paste(sample(letters,w.l,TRUE),collapse="")
words = sapply(1:200,function(e)createWords())
freq = c(sample(1:50,190,T),sample(100:150,10,T))
freq = freq / sum(freq)
wordcloud(words,freq)
wordcloud(words[1:10], freq,colors=rep(c("red","blue"),5), ordered.colors = TRUE)
~~~
