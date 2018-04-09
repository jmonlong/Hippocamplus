The scripts I use to convert reviews from [*Nature Reviews*](https://www.nature.com/reviews/index.html) or [*Annual Reviews*](https://www.annualreviews.org/) to EPUB. 
I first save the webpage of the review in HTML and then run the corresponding script.
[More info here](http://jmonlong.github.io/Hippocamplus/XXX/).

```sh
Rscript epubify-annualreviews.R review-I-manually-downloaded.html
```

### Dependencies: 

- [pandoc](http://pandoc.org/installing.html) command line.
- [rvest](https://github.com/hadley/rvest) R package (install with `install.packages('rvest')`.
