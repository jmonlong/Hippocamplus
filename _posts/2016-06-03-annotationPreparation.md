---
layout: post
title: Preparing some genomic annotations
tags: genome
---




## Mappability track

A mappability track was produced from the UCSC track. The raw file contains, for each base in the genome, an estimation of how likely a read is correctly mapped to this position. 

Using a sliding-window approach, I compute the average mappability in regions of size 1 Kbp.
This is a more manageable amount of data and still informative, especially when interested in large regions (e.g. SVs).

I used a custom Perl script to efficiently parse the bedGraph-transformed original file. See the code on [GitHub](https://github.com/jmonlong/Hippocamplus/blob/gh-pages/_source/mappabilityBin.pl).



I uploaded the result there: [https://dl.dropboxusercontent.com/s/i537zjs65dpw34n/map100mer-1kbp.bed.gz?dl=0](https://dl.dropboxusercontent.com/s/i537zjs65dpw34n/map100mer-1kbp.bed.gz?dl=0).



We can cut the genome into three mappability classes:

+ **unique** regions with high mappability estimate (>0.95).
+ **low-map** regions with a non-null mappability but lower than 0.95.
+ **no-map** regions with mappability 0.

![plot of chunk unnamed-chunk-4]({{ site.baseurl }}images/figure/source/2016-06-03-annotationPreparation/unnamed-chunk-4-1.png)

|map.class |       Mb|  prop|
|:---------|--------:|-----:|
|unique    | 2485.972| 0.803|
|low-map   |  375.608| 0.121|
|no-map    |  233.228| 0.075|
