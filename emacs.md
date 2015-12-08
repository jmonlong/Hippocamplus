---
layout: pagetoc
title: Emacs
---

I use Emacs for almost everything: **coding, writing, taking notes, preparing presentations**. I'm using it right now ! Well I mean, at the time I'm writing this. There is still a chance I'm using it when you read this.

## Basic configuration

## General commands

+ Select a region and press `M-=` to count words. There are other ways for LaTeX.

## For R

## For LaTeX

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

## For Python

## For Markdown

