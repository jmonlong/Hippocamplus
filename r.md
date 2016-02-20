---
layout: page
title: R
---

## Details to remember

#### Order in condition assessment

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
