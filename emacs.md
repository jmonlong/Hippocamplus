---
layout: pagetoc
title: Emacs
---

I use Emacs for almost everything: **coding, writing, taking notes, preparing presentations**. I'm using it right now ! Well I mean, at the time I'm writing this. There is still a good chance I'm using it now *now*.

## Basic configuration

I use [Solarized](http://ethanschoonover.com/solarized) theme palette. I installed the *color-theme-sanityinc-solarized* pacakge directly from [MELPA](#melpa-package-repository). I added the dark version as default with `(load-theme 'sanityinc-solarized-dark t)`. To change it interactively I run `M-x load-theme` and then for example `sanityinc-solarized-light`.

+ Apparently `(setq comint-scroll-to-bottom-on-output t)` will force the convenient scroll-down when a line/region is send to a console buffer (e.g. R, Shell).


## General commands

+ Select a region and press `M-=` to count words. There are other ways for LaTeX.
+ In a console (R, Shell), previous/next line in the history is accessed by `M-p`/`M-n`. (Useful when ssh-tunneling with broken key-bindings).

## MELPA package repository

Usually packages are just `.el` files to download and add in the folder defined in `.emacs` (e.g. `(add-to-list 'load-path "~/.emacs.d/lisp/")`). However, there is easier way: [MELPA](http://www.emacswiki.org/emacs/MELPA) package manager !

To install it, add to `.emacs`:

```lisp
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
```

Then to find and install a new package, use `M-x list-packages`, find the package in the list and click on *Install*.

## For R

### Poly-mode for R + Markdown

With polymode, the mode depends on the position of the cursor in the document. For R + Markdown it means that we can edit the Markdown part in the markdown-mode and run the R code as if in a R script.

I added this to my `.emacs`:

```lisp
(require 'poly-R)
(require 'poly-markdown)
(add-to-list 'auto-mode-alist '("\\.Rmd\\'" . poly-markdown+r-mode))
```

## For LaTeX

I put some Emacs tricks (e.g. for table manipulation) on the [LaTeX page](latex.md).

### Word count

I found a wrapper around `texcount` that count the number of words in a document. It can be called with `M-x latex` after adding this to your `.emacs` configuration:

```lisp
(defun latex-word-count ()
 (interactive)
  (let* ((this-file (buffer-file-name))
     (word-count
      (with-output-to-string
        (with-current-buffer standard-output
          (call-process "texcount" nil t nil "-inc" "-brief" this-file)))))
(string-match "\n$" word-count)
(message (replace-match "" nil nil word-count))))
```

I would like to add a feature to this: counting selected text.

## For Markdown

## For Python

## For Shell

To open a *shell* buffer, type `M-x shell`.

Then I use the [*Emacs Speaks SHELL*](http://www.emacswiki.org/emacs/essh) package, that adds all the nice commands to send lines/regions from a script to a Shell buffer. In my `.emacs` I added:

```lisp
(require 'essh)
(defun essh-sh-hook ()
  (define-key sh-mode-map "\C-c\C-r" 'pipe-region-to-shell)
  (define-key sh-mode-map "\C-c\C-b" 'pipe-buffer-to-shell)
  (define-key sh-mode-map "\C-c\C-j" 'pipe-line-to-shell)
  (define-key sh-mode-map "\C-c\C-n" 'pipe-line-to-shell-and-step)
  (define-key sh-mode-map "\C-c\C-f" 'pipe-function-to-shell)
  (define-key sh-mode-map "\C-c\C-d" 'shell-cd-current-directory))
(add-hook 'sh-mode-hook 'essh-sh-hook)
```

The shortcuts are self-explanatory.
