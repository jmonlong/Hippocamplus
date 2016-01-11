---
layout: page
title: Shell
---

## Converting PDF into EPS

I ended up using Inkscape in command-line mode. The result is not so bad (better than the `pdf2eps` etc).

```sh
inkscape document.pdf --export-eps=document.eps
```

[Apparently](http://blm.io/blog/convert-pdf-eps-osx/), `pdftops` is even better. 

```sh
pdftops -eps document.pdf
```

