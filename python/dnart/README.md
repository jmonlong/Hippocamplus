To generate images from genomic variants, e.g. results from 23andMe/Ancestry DNA tests.
See commands in the `trace.sh` file and more information on [this post](http://jmonlong.github.io/Hippocamplus/2018/12/08/dna-art/).

```sh
python dnart.py -i dnatree.tsv -o dbart.svg -a "2000x1000" -u 200 -p 10000
```

Usage:

```txt
usage: dnart.py [-h] [-i INF] [-o OUTF] [-a ASPECT] [-w WIDTH] [-u UNPACK]
                [-p PACK] [-s STYLE]

Generate image from DNA results (4 styles).

optional arguments:
  -h, --help  show this help message and exit
  -i INF      the input file
  -o OUTF     the output svg file
  -a ASPECT   the aspect ratio desired (either ratio or WxH)
  -w WIDTH    the width of lines.
  -u UNPACK   the number of unpacked SNPs. -1: no packing
  -p PACK     the number of packed SNPs.
  -s STYLE    the style.
```
