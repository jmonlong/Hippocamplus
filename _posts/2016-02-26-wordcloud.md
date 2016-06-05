---
layout: post
title: Word Cloud in R
tags: R
---

I use the `wordcloud` package.


{% highlight r %}
library(wordcloud)
{% endhighlight %}



{% highlight text %}
Loading required package: methods
{% endhighlight %}



{% highlight text %}
Loading required package: RColorBrewer
{% endhighlight %}

For example with fake words the command would look like that.


{% highlight r %}
createWords <- function(w.l=3) paste(sample(letters,w.l,TRUE),collapse="")
words = sapply(1:200,function(e)createWords())
freq = c(sample(1:50,190,T),sample(100:150,10,T))
freq = freq / sum(freq)
wordcloud(words,freq)
{% endhighlight %}

![plot of chunk unnamed-chunk-2]({{ site.baseurl }}images/figure/source/2016-02-26-wordcloud/unnamed-chunk-2-1.png)

{% highlight r %}
wordcloud(words[1:10], freq,colors=rep(c("red","blue"),5), ordered.colors = TRUE)
{% endhighlight %}

![plot of chunk unnamed-chunk-2]({{ site.baseurl }}images/figure/source/2016-02-26-wordcloud/unnamed-chunk-2-2.png)
