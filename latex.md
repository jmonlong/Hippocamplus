---
layout: page
title: LaTeX
---

{% include toc.html %}


## Standard packages

This is my default (more or less) :

~~~ latex
\usepackage[english]{babel}
\usepackage[utf8]{inputenc}
\usepackage{graphicx}
\usepackage{tabularx}
\usepackage[colorlinks=true,linkcolor=black,citecolor=black]{hyperref}
\usepackage{amsmath, amssymb, amsthm}
\usepackage{float}
\usepackage{caption}
\usepackage{subcaption}
\usepackage{fullpage}
~~~

## Basics

### Font sizes

`\tiny`, `\scriptsize`, `\footnotesize`, `\small`, `\normalsize`, `\large`, `\Large`, `\LARGE`, `\huge`, `\Huge`.

### Change the symbol in lists

~~~latex
\renewcommand{\labelitemi}{\textgreater}
~~~

Here are some appropriate symbols: `\ast`, `\star`, `\diamond`, `\blacktriangleleft`, `\blacktriangleright`, `\rightarrow`, `\Rightarrow`.

### Math calligraphy

The two most popular math calligraphy are used with :

+ `$\mathcal{A}$` for calligraphy.
+ `$\mathbb{A}$` for blackboard (e.g. sets).
+ `$\mathbf{A}$` for bold.

### Languages and encoding

At some time when writing in French or Spannish I used:

~~~latex
\usepackage[utf8]{inputenc}
\usepackage[frenchb]{babel}
\usepackage[T1]{fontenc}
~~~

and

~~~latex
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[spanish]{babel}
~~~

An accent was specified as `\'i`.

## Figures

### Position

+ `[h]` meand **h**ere.
+ `[t]` means at the **t**op of the page.
+ `[p]` means on its own **p**age.

I usually use `[ht]` for small/medium figures, and `[htp]` for large ones.

### Sub-figures

After adding `\usepackage{subcaption}`, use like this:

~~~latex
\begin{subfigure}[b]{.48\textwidth}
	\includegraphics{example.pdf}
	\caption{}
	\label{fig:example}
end{subfigure}
~~~

For more custom organization of the sub-figures, feel free to use `minipage` environment. To force a caption number/letter, use `\addtocounter{subfigure}{XX}`. For example, to have the second subfigure as a long vertical panel on the right and figure {\it a} and {\it c}, smaller on the left:

~~~latex
\begin{figure}[htp]
	\begin{minipage}[c]{.4\textwidth}
		\begin{subfigure}[b]{\linewidth}
			\includegraphics{example.pdf}
			\caption{}
			\label{figa}
		\end{subfigure}
		\addtocounter{subfigure}{1}
		\begin{subfigure}[b]{\linewidth}
			\includegraphics[page=3]{example.pdf}
			\caption{}
			\label{figc}
		\end{subfigure}
	\end{minipage}
	\begin{minipage}[c]{.6\textwidth}
		\addtocounter{subfigure}{-2}
		\begin{subfigure}[b]{\linewidth}
			\includegraphics[page=2]{example.png}
			\caption{}
			\label{figb}
		\end{subfigure}
	\end{minipage}    
	\caption{Whole figure caption}
\end{figure}
~~~

### Supplementary figures

The counter and style for supplementary figures (and tables) can be changed. I place this block at the beginning of the supplementary figure section: 

~~~latex
\setcounter{figure}{0}
\renewcommand{\thefigure}{S\arabic{figure}}
~~~

Moreover, some journals require the supplementary figures to be named *Supplementary Fig. 1*. As it is, with the configuration above, it would look like *Fig. S1* when using `Fig. \ref{fig:toto}`. The only solution I can think of is to manually write or not the *Supplementary* and remove the *S* in the number. But it's painful. Eventually I could write a small script that does this automatically.

Side-note: I don't like this style. Ok it looks a bit more fancy but using *S12* is shorter and clearer, and avoids any confusion even when citing multiple figures.


## Tables

### Control tabular width

~~~latex
\resizebox{.8\textwidth}{!}{
	TABULAR
}
~~~

### Supplementary tables

Similar to figures I use:

~~~latex
\setcounter{table}{0}
\renewcommand{\thetable}{S\arabic{table}}%
~~~

### Spanning columns/rows

+ `\multicolumn{2}{c|}{Multi-column}` for a column spanning 2 columns. 
+ `\multirow{2}{*}{Multi-row}` for a row spanning 2 rows.
+ `\cline{2-10}` to avoid `\hline` crossing a multi-row cell (one the first column).

### Align columns

In Emacs, place the cursor within the tabular and press `M-x align-current`.

### Rectangular selection/cut/paste

In Emacs, the columns can be *"easily"* rearranged using rectangular selection. Depending on Emacs' version it could be:

+ `C-x space` starts the selection.
+ `C-x r k` cut the selection.
+ `C-x r y` paste the selection, considering the cursor in the top-left corner of the desired location.

### Tables from *R*

Package [*knitr*](https://cran.r-project.org/web/packages/knitr/) has a function `kable` to easily format a *data.frame* in LaTeX format. 

## Code blocks

The easiest is to use [Listings](https://en.wikibooks.org/wiki/LaTeX/Source_Code_Listings) environment.

In Emacs to avoid misinterpreting special character (e.g. `$` or `_`) I added to `.emacs` :

~~~lisp
(setq LaTeX-verbatim-environments-local '("lstlisting"))
~~~

Then in the LaTeX document I setup the *lstlisting* environment with something like:

~~~latex
\lstset{ 
  basicstyle=\scriptsize\ttfamily, % the size of the fonts that are used for the code
  breakatwhitespace=false,         % sets if automatic breaks should only happen at whitespace
  breaklines=true,                 % sets automatic line breaking
  frame=single,	                   % adds a frame around the code
  keepspaces=true,                 % keeps spaces in text, useful for keeping indentation of code
  language=sh,                     % the language of the code
}
~~~

## For manuscripts

### Abstract

An abstract environment exists:

~~~latex
\begin{abstract}
Genetics has been shown to be important...
\end{abstract}
~~~

### Author affiliation

Using `\usepackage{authblk}`, the authors' affiliations can be defined like this:

~~~latex
\author[1,2]{Jean Monlong}
...
\affil[1]{Department of Human Genetics, McGill University, Montréal, H3A 1B1, Canada}
\affil[2]{McGill University and Génome Québec Innovation Center, Montréal, H3A 1A4, Canada}
...
~~~

### Text formatting

+ `\linespread{1.6}` for double-spacing.
+ To add line numbers, *lineno* package:

~~~latex
\usepackage[modulo]{lineno}
\linenumbers
~~~

### Notes

~~~latex
\usepackage{todonotes}
\newcounter{mycomment}
\newcommand{\comment}[2][]{%
  \refstepcounter{mycomment}%
  {%
    %\setstretch{0.7}% spacing
    \todo[color={red!100!green!33},size=\tiny]{%
      \textbf{[\uppercase{#1}\themycomment]:}~#2}%
  }}
~~~

By default, for an inline comment: `\todo[inline]{...}`.

## Bibliography

I use `\usepackage[comma,super]{natbib}`.

### Reduce long list of authors

To change a long list of authors into *"First Author et al"* in the references, use a custom `.bst` file.

I downloaded the original version of the file [there](http://ctan.org/tex-archive/macros/latex/contrib/natbib) and change the `FUNCTION {format.names}` part by

~~~
INTEGERS { max.num.names.before.forced.et.al num.names.shown.with.forced.et.al }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  #5 'max.num.names.before.forced.et.al :=
  #1 'num.names.shown.with.forced.et.al :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{f.~}{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
        { nameptr num.names.shown.with.forced.et.al #1 + =
          numnames max.num.names.before.forced.et.al >
          and
            { "others" 't :=
              #1 'namesleft :=
            }
            { skip$ }
          if$
          namesleft #1 >
            { ", " * t * }
            { t "others" =
                { " " * "et~al." emphasize * }
                { numnames #2 >
                    { "," * }
                    { skip$ }
                  if$
                  " and " * t *
                }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}
~~~

This allows maximum five authors before it switches to *"First Author et al"* mode. These numbers are defined in lines with `'max.num.names.before.forced.et.al :=` and `'num.names.shown.with.forced.et.al :`.

I put this new `.bst` file in the folder of my `.tex` file and called it in the style command: `\bibliographystyle{unsrtnat5}`.


## Presentations

### Changing the font

By default, Beamer uses a sans-serif font. It looks a bit harsh. I find the *Palatino* font easier on the eye. To switch to serif font and choose the *Palatino*, I add at the beginning of the document:

~~~latex
\renewcommand*{\familydefault}{\rmdefault}
\renewcommand*\rmdefault{ppl}
~~~

### Section slides

To introduce sections, Beamer can automatically insert slides. These automated slides can be defined with:

~~~latex
\AtBeginSection{
  \begin{frame}
    \begin{center}
      \structure{\Large\bf \insertsection}
    \end{center}
  \end{frame}
}
\AtBeginSubsection{
  \begin{frame}
    \begin{center}
      \structure{\large \insertsubsection}
    \end{center}
  \end{frame}
}
~~~

### Themes

I tend to use the minimalist *default* theme, remove the navigation bar but add slide number: 

~~~latex
\usetheme{default}
\setbeamertemplate{navigation symbols}{}
\setbeamertemplate{footline}[page number]
~~~

For an important presentation, I could use a more fancy theme, such as the [Metropolis](https://github.com/matze/mtheme) theme or the [Execushares](http://hamaluik.com/posts/better-beamer-themes/) one. Eventually I would like to mix and customize these two (see current state [there](https://github.com/jmonlong/Hippocamplus/blob/master/LaTeX/theme/beamerthemeMyExecushares.sty)).
