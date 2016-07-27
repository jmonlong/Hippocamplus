---
layout: pagetoc
title: Shell
---

## Tricks

### Add headers with cat

`cat file.txt | cat headers.txt -` concatenated end of the pipe after `headers.txt`.

### Avoid killing ssh jobs

`nohup` function.


## Shell scripting

Start a script with one of the [shebang](https://en.wikipedia.org/wiki/Shebang_%28Unix%29)

~~~sh
#!/bin/sh
~~~

### If Then Else

A simple example:

~~~sh
if [ $VAL == "YEP" ]; then
	echo "It's a yes!"
else
	echo "No no no :("
fi
~~~

Or with multiple conditions:

~~~sh
if [ $VAL == "YEP" ] && [ COND ]; then
	echo "It's a yes!"
else
	echo "No no no :("
fi
~~~

The spacing is quite important, and the conditions can be built with:

+ `-eq` equal to.
+ `-ne` not equal to.
+ `-lt` less than.
+ `-le` less or equal than.
+ `-gt` great than.
+ `-ge` great or equal than.
+ `-s` file exists and not empty.
+ `-f` file exists and not directory.
+ `-d` directory exists.
+ `-x` file executable.
+ `-w` file writable.
+ `-r` file readable.


## Converting PDF into EPS

I ended up using Inkscape in command-line mode. The result is not so bad (better than the `pdf2eps` etc).

~~~sh
inkscape document.pdf --export-eps=document.eps
~~~

[Apparently](http://blm.io/blog/convert-pdf-eps-osx/), `pdftops` is even better. 

~~~sh
pdftops -eps document.pdf
~~~

## Git

### Aliases

~~~sh
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.br branch
~~~

+ Commit all modification and added files: `git commit -am "informative message"`

### Branches

+ List branches: `git branch`
+ List all branches: `git branch -a`
+ Update remote branch list: `git remote prune origin`
+ Create branch: `git checkout -b hotfix`
+ Link it to a remote branch: `git branch -u origin/hotflix`
+ Creat a new local branch from remote: `git co -t origin/hotfix`
+ Merge the current branch with another branch: `git merge hotfix`
+ Delete a branch: `git branch -d hotfix`
+ Delete remote branch: `git push origin :hotfix`


## Docker cheatsheet

I'm still learning Docker but here are commands/parameters that seem relevant for me:

### Build a docker instance

[Write a Dockerfile](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/) :

+ `WORKDIR /root` sets the working directory.
+ `COPY PopSV_1.0.tar.gz ./` copies a file in the instance. The `/` is important !
+ There is a cache management system so it's important to keep related commands in the same `RUN`.

To run in the folder with the `Dockerfile`.

~~~sh
docker build -t jmonlong/popsv-docker .
~~~

### Launch a docker instance

To launch an interactive instance with a shared folder:

~~~sh
docker run -t -i -v /home/ubuntu/analysis1:/root/analysis1 jmonlong/popsv-docker
~~~

+ `-t` and `-i` are used for interactive run.
+ `-v` links folder in the host with folder in the image. It must be **absolute paths*.

