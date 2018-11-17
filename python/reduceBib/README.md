Some more info at [http://jmonlong.github.io/Hippocamplus/2018/11/17/speedup-blogwdown-pandoc-large-bibliography/](http://jmonlong.github.io/Hippocamplus/2018/11/17/speedup-blogwdown-pandoc-large-bibliography/).

```sh
usage: reduceBib.py [-h] [-b BIB] [-o OUT] [-a NAUTHS] [-f FIELDS]
                    mds [mds ...]

Reduce a .bib file.

positional arguments:
  mds         the markdown files to scan

optional arguments:
  -h, --help  show this help message and exit
  -b BIB      the original bib file
  -o OUT      the new bib file
  -a NAUTHS   the maximum number of authors. Default: 5.
  -f FIELDS   the BibTeX fields to keep (comma separated). Default:
              "author,title,doi,journal,year,url"
```
