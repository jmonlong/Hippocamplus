---
layout: page
title: Emacs
---

I use Emacs for almost everything: **coding, writing, taking notes, preparing presentations**. I'm using it right now ! Well I mean, at the time I'm writing this. There is still a good chance I'm using it now *now*.

{% include toc.html %}

## Basic configuration

Some of the basic tweaks on my `.emacs` file:

+ Disable startup screen with `(setq inhibit-splash-screen t)`.
+ Turn the blinking off with `(blink-cursor-mode 0)`.
+ Turn off the tool bar with `(tool-bar-mode 0)`.
+ Change the font with `(set-default-font "DejaVu Sans Mono 12")`.

## General commands

+ Select a region and press `M-=` to count words. There are other ways for LaTeX.
+ In a console (R, Shell), previous/next line in the history is accessed by `M-p`/`M-n`. (Useful when ssh-tunneling with broken key-bindings).
+ Look for a regular expression in files using `M-x lgrep` command.

Regexp replace :
+ Command: `C-M-%`.
+ `\(` and `\)` to define groups.
+ `\1` to refer to the first group.

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

ESS can also be installed through **MELPA**.

### Auto-complete

To get auto-completion (with objects, functions or parameters) I use *auto-complete*. It's also available through MELPA.

Then I configure it in my `.emacs`:

~~~lisp
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/lisp/ac-dict")
(ac-config-default)
(setq ac-auto-start nil)
(define-key ac-mode-map [C-tab] 'auto-complete)
(define-key ac-completing-map "\t" 'ac-complete)
(define-key ac-completing-map "\r" nil)
(setq ac-quick-help-delay 0.1)
~~~


### Smart underscores
By default, pressing underscore will insert a ` <- ` instead of a `_`. This was supposed to ease the pain of writing assignments with the arrow. However now we want a `_` most of the time (e.g. for *ggplot2* functions). Using smart underscore, ` <- ` will be inserted only when following a space.

Simply put [this *.el* file](http://www.emacswiki.org/emacs/download/ess-smart-underscore.el) in the load path and add these lines to `~/.emacs`:

~~~lisp
(require 'ess-smart-underscore)
(setq ess-S-underscore-when-last-character-is-a-space t)
~~~

Also in **MELPA**.

### Poly-mode for R + Markdown

With polymode (MELPA), the mode depends on the position of the cursor in the document. For R + Markdown it means that we can edit the Markdown part in the markdown-mode and run the R code as if in a R script.

I added this to my `.emacs`:

~~~lisp
(require 'poly-R)
(require 'poly-markdown)
(add-to-list 'auto-mode-alist '("\\.Rmd\\'" . poly-markdown+r-mode))
~~~

## Spell checking

I use *ispell* and *flyspell*.

To turn on automatically the live spell check for Latex and markdown documents:

~~~lisp
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'markdown-mode-hook 'flyspell-mode)
~~~

I use the *american* dictionary by default:

~~~lisp
(setq ispell-dictionary "american")
(setq ispell-local-dictionary "american")
~~~

## For LaTeX

I put some Emacs tricks (e.g. for table manipulation) on the [LaTeX page]({{ site.baseurl }}latex).

I general I prefer to use AUCTeX (available through MELPA).
For example, it handles multi-file documents and keeps the annoying compilation buffer closed.
My configuration is:

~~~lisp
(setq TeX-PDF-mode t)
(setq-default TeX-master nil)
~~~


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

Pressing `TAB` when the cursor is in a heading will cycle through *heading-only/full* view.

`M-x orgtbl-mode` to format markdown tables.

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

### Send commands to a specific buffer

Sometimes I want to send the commands to a specific buffer. For example, when testing new packages within a Docker container, I start a *shell* buffer, run docker and python.

I installed *isend* from MELPA. Then I simply go to the *code* buffer and run `M-x isend-associate RET *shell* RET`. At this point `C-Enter` will send the command to the *shell* buffer.

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


## For file manipulation

To compare and merge two files, use Ediff mode by calling `M-x ediff` (or `M-x ediff-buffers` when *diff* should be done between existing buffers). Once launched press:

+ `|` to change the split mode (vertical/horizontal).
+ `n`/`p` to go to the next/previous difference.
+ `a` to put A's version to B.
+ `b` to put B's version to A.
+ `q` to quit.
+ `?` to get the full list of shortcuts.

To visualize blanks (tabs, spaces, new lines) I use the minor mode `whitespace-mode`.

### CSV/TSV

I use the `csv-mode` and the command `c-c c-a` to align columns.
By default it understand `,`, `;` and `\t` as separator.
If not I think the variable to customize is `csv-separators`.

## For Version Control

+ `C-x v +` to pull.
+ `C-x v v` to commit.
+ `C-x v i` to add.
+ `C-x v =` to see differences.

## For online notes

### Evernote

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

### Simplenote

I now use [Simplenote](https://app.simplenote.com/) instead of Evernote, in order to make sure that I have an offline version of my notes at all time. Moreover it integrates (almost completely) the Markdown format. It makes it easy to take notes and to transfer them in our wiki (e.g. for conference notes). It's also easier to clean the notes through emacs compared to the online page or apps.

There is a [Emacs package](https://github.com/alpha22jp/simplenote2.el) that can be installed using MELPA: `M-x package-install [RET] simplenote2 [RET]`.

The Simplenote buffer can be summoned by `M-x simplenote2-browse` or `M-x simplenote2-list`.

In list mode, the relevant commands are:

- `g`: sync with the server.
- `a`: create a new note
- `d`: mark note on the current line for deletion
- `u`: unmark note on the current line for deletion
- `t`: set tags for filtering
- `^`: toggle tags filtering condition between "AND" and "OR"

Other general commands include:

- `simplenote2-add-tag` and `simplenote2-delete-tag`
- `simplenote2-set-markdown`


## File encryption

Encryption is integrated directly. Just add the extension `.gpg` to a file.


## For OSX

Here are some bits of configuration specific to OSX.

### Maximize window at opening

Using the *maxframe* elisp from [Ryan McGeary](https://github.com/rmm5t/maxframe.el). I'll copy the `maxframe.el` in the *master* branch of this repo in case it disappears.

~~~lisp
(require 'maxframe)
(add-hook 'window-setup-hook 'maximize-frame t)
~~~

### Keybindings

To change the annoying OSX bindings: paragraph jumping, home/end for line not page.

~~~lisp
(define-key function-key-map (kbd "M-<down>") 'forward-paragraph)
(define-key function-key-map (kbd "M-<up>") 'backward-paragraph)
(global-set-key (kbd "<home>") 'beginning-of-line)
(global-set-key (kbd "<end>") 'end-of-line)
~~~

### Ispell

To specify where is *ispell* located.

~~~lisp
(setq ispell-program-name "/usr/local/Cellar/ispell/3.4.00/bin/ispell")
~~~

Also something about the right-click (I don't remember why I have that).

~~~lisp
(eval-after-load "flyspell"
    '(progn
       (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
       (define-key flyspell-mouse-map [mouse-3] #'undefined)))
~~~

	
