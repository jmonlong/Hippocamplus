---
layout: pagetoc
title: Emacs
---

I use Emacs for almost everything: **coding, writing, taking notes, preparing presentations**. I'm using it right now ! Well I mean, at the time I'm writing this. There is still a good chance I'm using it now *now*.

## Basic configuration
Some of the basic tweaks on my `.emacs` file:

+ Disable startup screen with `(setq inhibit-splash-screen t)`.
+ Turn the blinking off with `(blink-cursor-mode 0)`.
+ Turn off the tool bar with `(tool-bar-mode 0)`.
+ Change the font with `(set-default-font "DejaVu Sans Mono 12")`.

## General commands

+ Select a region and press `M-=` to count words. There are other ways for LaTeX.
+ In a console (R, Shell), previous/next line in the history is accessed by `M-p`/`M-n`. (Useful when ssh-tunneling with broken key-bindings).

## MELPA package repository

Usually packages are just `.el` files to download and add in the folder defined in `.emacs` (e.g. `(add-to-list 'load-path "~/.emacs.d/lisp/")`). However, there is easier way: [MELPA](http://www.emacswiki.org/emacs/MELPA) package manager !

To install it, add to `.emacs`:

~~~lisp
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
~~~

Then to find and install a new package, use `M-x list-packages`, find the package in the list and click on *Install*.

## Solarized theme

I use [Solarized](http://ethanschoonover.com/solarized) theme palette. I installed the *color-theme-sanityinc-solarized* pacakge directly from [MELPA](#melpa-package-repository). I added the dark version as default with `(load-theme 'sanityinc-solarized-dark t)`. To change it interactively I run `M-x load-theme` and then for example `sanityinc-solarized-light`.


## For R

### Emacs Speaks Statistics
To install ESS, without needing the admin rights, the easiest way is to download and compile it in a dedicated folder (e.g. `.emacs.d/lisp/ess`):

~~~sh
git clone https://github.com/emacs-ess/ESS.git .emacs.d/lisp/ess
cd .emacs.d/lisp/ess
make
~~~

Then add these lines to `~/.emacs`:

~~~lisp
(add-to-list 'load-path "~/.emacs.d/lisp/ess/lisp/")
(load "ess-site")
~~~

### Smart underscores
By default, pressing underscore will insert a ` <- ` instead of a `_`. This was supposed to ease the pain of writing assignments with the arrow. However now we want a `_` most of the time (e.g. for *ggplot2* functions). Using smart underscore, ` <- ` will be inserted only when following a space.

Simply put [this *.el* file](http://www.emacswiki.org/emacs/download/ess-smart-underscore.el) in the load path and add these lines to `~/.emacs`:

~~~lisp
(require 'ess-smart-underscore)
(setq ess-S-underscore-when-last-character-is-a-space t)
~~~

### Poly-mode for R + Markdown

With polymode, the mode depends on the position of the cursor in the document. For R + Markdown it means that we can edit the Markdown part in the markdown-mode and run the R code as if in a R script.

I added this to my `.emacs`:

~~~lisp
(require 'poly-R)
(require 'poly-markdown)
(add-to-list 'auto-mode-alist '("\\.Rmd\\'" . poly-markdown+r-mode))
~~~

## For LaTeX

I put some Emacs tricks (e.g. for table manipulation) on the [LaTeX page](latex.md).

### Word count

I found a wrapper around `texcount` that count the number of words in a document. It can be called with `M-x latex` after adding this to your `.emacs` configuration:

~~~lisp
(defun latex-word-count ()
 (interactive)
  (let* ((this-file (buffer-file-name))
     (word-count
      (with-output-to-string
        (with-current-buffer standard-output
          (call-process "texcount" nil t nil "-inc" "-brief" this-file)))))
(string-match "\n$" word-count)
(message (replace-match "" nil nil word-count))))
~~~

I would like to add a feature to this: counting selected text.

## For Markdown

## For Python

### Elpy python mode
[Elpy](https://github.com/jorgenschaefer/elpy) combines several packages to provide a lot of nice features, e.g. code coloring, completion, syntax checks, formatting recommendations.

To install, follow instructions on the [GitHub page](https://github.com/jorgenschaefer/elpy) and add to `.emacs`:

~~~lisp
(package-initialize)
(elpy-enable)
~~~

### Add some key bindings
I added key bindings to send regions or the entire buffer to the opened Python shell. In `.emacs`:

~~~lisp
(add-hook 'python-mode-hook 'my-python)
(defun my-python ()
  (define-key python-mode-map (kbd "C-c r") 'python-shell-send-region)
  (define-key python-mode-map (kbd "C-c b") 'python-shell-send-buffer))
~~~

## For Shell

To open a *shell* buffer, type `M-x shell`.

Then I use the [*Emacs Speaks SHELL*](http://www.emacswiki.org/emacs/essh) package, that adds all the nice commands to send lines/regions from a script to a Shell buffer. In my `.emacs` I added:

~~~lisp
(require 'essh)
(defun essh-sh-hook ()
  (define-key sh-mode-map "\C-c\C-r" 'pipe-region-to-shell)
  (define-key sh-mode-map "\C-c\C-b" 'pipe-buffer-to-shell)
  (define-key sh-mode-map "\C-c\C-j" 'pipe-line-to-shell)
  (define-key sh-mode-map "\C-c\C-n" 'pipe-line-to-shell-and-step)
  (define-key sh-mode-map "\C-c\C-f" 'pipe-function-to-shell)
  (define-key sh-mode-map "\C-c\C-d" 'shell-cd-current-directory))
(add-hook 'sh-mode-hook 'essh-sh-hook)
~~~

The shortcuts are self-explanatory.

## For Evernote

I use [Evernote](https://evernote.com/) for easily keep notes synchronized across computer, tablet and smartphone. And there is a [Emacs mode for it](https://github.com/pymander/evernote-mode) (of course!).

To install it, first run:

~~~sh
gem install evernote_oauth
git clone https://github.com/pymander/evernote-mode
cd evernote-mode/ruby
ruby setup.rb
~~~

I had an error with the last command and fixed it by changing `::Config::CONFIG` with `::RbConfig::CONFIG` in `setup.rb`.

Then, copy `evernote-mode.el` to the load path and add to `.emacs`:

~~~lisp
(require 'evernote-mode)
(setq evernote-developer-token "<MYTOKEN>")
(setq evernote-username "<MYUSERNAME>")
(setq evernote-enml-formatter-command '("w3m" "-dump" "-I" "UTF8" "-O" "UTF8"))
(global-set-key "\C-cec" 'evernote-create-note)
(global-set-key "\C-ceo" 'evernote-open-note)
(global-set-key "\C-ces" 'evernote-search-notes)
(global-set-key "\C-ceS" 'evernote-do-saved-search)
(global-set-key "\C-cew" 'evernote-write-note)
(global-set-key "\C-cep" 'evernote-post-region)
(global-set-key "\C-ceb" 'evernote-browser)
~~~

I retrieved my developer token (to use instead of `<MYTOKEN>`) [there](https://www.evernote.com/api/DeveloperToken.action). 

Side notes:

1. I also had to install *w3m* software.
2. By default the notes are in read-only XHTML mode, I use `M-x evernote-change-edit-mode TEXT` to change the edit mode to text.