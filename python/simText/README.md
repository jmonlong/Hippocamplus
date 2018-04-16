Some more info at [http://jmonlong.github.io/Hippocamplus/2018/04/16/text-similarity/](http://jmonlong.github.io/Hippocamplus/2018/04/16/text-similarity/).

```sh
usage: simText.py [-h] -1 D1 -2 D2 [-k K] [-e EXT] [-s MINSIM] [-tex]

Find similar text between two documents.

optional arguments:
  -h, --help  show this help message and exit
  -1 D1       Text document 1
  -2 D2       Text document 2
  -k K        The number of char for 1st pass. Default 20
  -e EXT      The number of additional char. Default 70
  -s MINSIM   The minimum similarity to define a match. Default 0.8
  -tex        Skip LaTeX header and lines starting with %
```
