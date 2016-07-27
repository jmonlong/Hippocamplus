---
layout: posttoc
title: Human Genome - CNV Catalogs Exploration
tags: genome
---




# CNV map from DGV

I downloaded the *stringent* map from [Zarrei et al., Nat Reviews 2015](http://www.nature.com/nrg/journal/v16/n3/full/nrg3871.html). These CNVs were derived from the [Database of Genomic Variants](http://dgvbeta.tcag.ca/dgv/app/home) ("healthy" individuals). In their stringent map, they kept CNVs seen in at least two studies.



## Loss versus Gain

More loss of DNA than gain are present in the catalog (15.3x more).

![plot of chunk unnamed-chunk-3]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-3-1.png)

## Size

As expected the size distribution is wider for losses than for gain (deletions are easier to detect). However we can see some peaks in the distribution of losses. These are not due to the classic 300bp/6kbp transposon polymorphism, so I think it's due to the different methods/studies that were combined. Hence this distribution is not completely representative of the real CNV size distribution.

![plot of chunk unnamed-chunk-4]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-4-1.png)![plot of chunk unnamed-chunk-4]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-4-2.png)

 As shown in the cumulative proportion curves, we see that 90% of the deletions are smaller than 10 Kbp while only 40% of detected gains are.

![plot of chunk unnamed-chunk-5]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-5-1.png)![plot of chunk unnamed-chunk-5]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-5-2.png)

To investigate a bit the suspicious peaks, I look at the effect of the three studies contributing the most to the catalog. We can see that *Wong2012b* is responsible for the first large peak, and *1000GenomesPhase1*/*Conrad2009* for the second peak.

![plot of chunk unnamed-chunk-6]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-6-1.png)![plot of chunk unnamed-chunk-6]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-6-2.png)![plot of chunk unnamed-chunk-6]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-6-3.png)

## Density

Using non-overlapping windows of 1 Mb the CNV density looks like this:

![plot of chunk unnamed-chunk-7]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-7-1.png)![plot of chunk unnamed-chunk-7]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-7-2.png)![plot of chunk unnamed-chunk-7]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-7-3.png)

*Of note, this graph is NOT based on the CNV frequency, but rather the location of any CNVs, not matter their frequency.*

There is, on average, 3.81 annotated CNVs per Mb.

## Mappability

The mappability track was produced from the UCSC track. The raw file contains, for each base in the genome, an estimation of how likely a read is correctly mapped to this position. Using a sliding-window approach, I computed the average mappability in regions of size 1 Kbp.

![plot of chunk unnamed-chunk-8]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-8-1.png)

|cov.class |       mb|  prop|
|:---------|--------:|-----:|
|unique    | 2485.972| 0.803|
|low-map   |  375.608| 0.121|
|no-map    |  233.228| 0.075|

I defined *unique* regions that have an average mappability higher than 0.95, *no-map* when the mappability is null, and the rest as *low-map*.


|cov.class | nb.cnv| prop.cnv|
|:---------|------:|--------:|
|no-map    |      1|    0.000|
|low-map   |   6174|    0.526|
|unique    |   9629|    0.821|

Most CNVs overlap unique regions but many still overlap low-mappability regions. Actually only 12.1% of the genome is annotated as *low-map* but 52.6% of the CNVs overlap such regions.


## Distance to centromere/telomere/gaps



Then I compute the distance between each CNV and the nearest centromere/telomere/gap.



As a control, the same is done for random regions of similar sizes.



The cumulative distribution of the distance to the nearest CTG shows that CNVs are closer to CTG than expected by chance.

![plot of chunk unnamed-chunk-13]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-13-1.png)

In this graph we see that control regions overlap CTG much more than CNVs (*x=0*) but that CNVs catch up and become quickly present close to CTGs. Most likely, the lack of CNV overlapping CTGs is mostly due to difficulties detecting them there, more than real absence.


## Per sample catalog

As it is, the samples affected are jointly associated for each CNV. However, I transform the format in order to have regions representing one CNV in one sample. Although it duplicates information, it makes it easier to have an idea of what is in one genome.

I eventually tried to guess the study each sample is coming from. It didn't work completely... It seems that some samples were analyzed by several studies.

![plot of chunk unnamed-chunk-14]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-14-1.png)![plot of chunk unnamed-chunk-14]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-14-2.png)

I keep only the samples with at least 500 CNVs. Samples with less are suspicious while samples with more than 500 CNVs have a smooth enough distribution.

![plot of chunk unnamed-chunk-15]({{ site.baseurl }}images/figure/source/2016-06-05-CNVcatalogs/unnamed-chunk-15-1.png)

On average, 32 Mbp of a genome is annotated as CNV.


# CNV map from 1000 Genomes Project

# CNV map from long-read sequencing
