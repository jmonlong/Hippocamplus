The scripts I use to convert reviews from [*Nature Reviews*](https://www.nature.com/reviews/index.html) or [*Annual Reviews*](https://www.annualreviews.org/) to EPUB. 
[More info here](http://jmonlong.github.io/Hippocamplus/XXX/).

```sh
Rscript epubify-annualreviews.R -i https://www.annualreviews.org/doi/full/10.1146/annurev-genet-120215-034854
```

### Usage

```sh
usage: Rscript epubify-annualreviews.R [-h] -i HTML [-list] [-title TITLE]

optional arguments:
  -h           show this help message and exit
  -i HTML      the input URL (or HTML file) or a text file with a list of URLs (or HTML file names)
  -list        the input is a file with a list
  -title TITLE   the title of the ebook
```

### Dependencies: 

- [pandoc](http://pandoc.org/installing.html) command line.
- [rvest](https://github.com/hadley/rvest) R package (install with `install.packages('rvest')`).
- [knitr](https://yihui.name/knitr/) R package (install with `install.packages('knitr')`).

### Collections

`listUrls.R` has some R code to easily get lists of URLs from search results (e.g. Points of Significance serie) or other collections. 

To create a EPUB for the Points of Significance articles or some Nature Reviews/Annual Reviews lists of reviews:

```sh
## download the *-urls.txt files or recreate them with 'listUrls.R'

## Points of Significance
Rscript epubify-naturereviews.R -i pointsOfSignificance-urls.txt -list -title "Points of Significance"

## Genome Editing (Nat Reviews)
Rscript epubify-naturereviews.R -i NatureReviews-GenomeEditing-urls.txt -list -title "Genome Editing"

## Computational Tools (Nat Reviews)
Rscript epubify-naturereviews.R -i NatureReviews-ComputationalTools-urls.txt -list -title "Computational Tools"

## Microbiome & Sequencing (Annual Reviews)
Rscript epubify-annualreviews.R -i AnnualReviews-MicrobiomeSequencing-urls.txt -list -title "Microbiome and Sequencing"
```

### Loose Ends by Sidney Brenner

I compiled the ["Losse Ends" columns](https://www.cell.com/current-biology/libraries/loose-ends) by Sidney Brenner.
R commands in `epubify-LooseEnds-SidneyBrenner.R`, output in EPUB or MOBI formats:

- EPUD: [Loose_Ends_by_Sidney_Brenner.epub](https://github.com/jmonlong/Hippocamplus/raw/config/R/epubifyReviews/Loose_Ends_by_Sidney_Brenner.epub)
- MOBI: [Loose_Ends_by_Sidney_Brenner.mobi](https://github.com/jmonlong/Hippocamplus/raw/config/R/epubifyReviews/Loose_Ends_by_Sidney_Brenner.mobi)
