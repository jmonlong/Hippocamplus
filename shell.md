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

## Docker cheatsheet

I'm still learning Docker but here are commands/parameters that seem relevant for me:

### Build a docker instance

[Write a Dockerfile](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/) :

+ `WORKDIR /root` sets the working directory.
+ `COPY PopSV_1.0.tar.gz ./` copies a file in the instance. The `/` is important !
+ There is a cache management system so it's important to keep related commands in the same `RUN`.

To run in the folder with the `Dockerfile`.

```sh
docker build -t jmonlong/popsv-docker .
```

### Launch a docker instance

To launch an interactive instance with a shared folder:

```sh
docker run -t -i -v /home/ubuntu/analysis1:/root/analysis1 jmonlong/popsv-docker bash
```


