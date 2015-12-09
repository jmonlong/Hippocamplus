---
layout: pagetoc
title: Emacs
---

I use Emacs for almost everything: **coding, writing, taking notes, preparing presentations**. I'm using it right now ! Well I mean, at the time I'm writing this. There is still a chance I'm using it when you read this.

## Basic configuration

+ Apparently `(setq comint-scroll-to-bottom-on-output t)` will force the convenient scroll-down when a line/region is send to a console buffer (e.g. R, Shell).

## General commands

+ Select a region and press `M-=` to count words. There are other ways for LaTeX.
+ In a console (R, Shell), previous/next line in the history is accessed by `M-p`/`M-n`. (Useful in clusters when `C-up` doesn't work).

## For R

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

Then I use the [*Emacs Speaks SHELL*](http://www.emacswiki.org/emacs/essh) package, that adds all the nice commands to sending lines/regions from a script to a Shell buffer. In my `.emacs` I added:

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

The created shortcuts are self-explanatory.
