---
layout: post
title: Summary epigenetic mark tracks
tags: genome
---



To assess the potential impact of variants (SNV, SVs) we might want to use some of the public epigentic datasets. The amount and heterogeneity of this data is a bit overwhelming. I would like to get a summary of which regions of the genome are the most functionally important.

The plan is to:

+ get annotated **peaks**
+ for the 6 **typical histone marks**
+ in **5-6 tissues**, merging sub-tissues (e.g. brain subregions)
+ keep regions **supported by enough replicates**

Eventually, I could also annotate the regions that are tissue-specific or shared across tissues.

The R-markdown source code is in the website's [GitHub](https://github.com/jmonlong/Hippocamplus/blob/gh-pages/_source/2016-09-06-epigeneticTracks.Rmd).

## AnnotationHub

I'll use the [AnnotationHub](http://bioconductor.org/packages/release/bioc/html/AnnotationHub.html) package, which links Encode and EpigenomeRoadmap data (and more) directly in R. 

I search for *peaks* in *hg19* from H3K27ac, H3K27me3, H3K36me3, H3K4me1, H3K4me3 or H3K9me3, in brain, blood, liver, muscle, lung, kidney, skin or heart. Let's see if I can find what I want.

![plot of chunk unnamed-chunk-2]({{ site.baseurl }}images/figure/source/2016-09-06-epigeneticTracks/unnamed-chunk-2-1.png)

Except for liver and kidney, the other tissues have more than 3 tracks for each mark. In total, it represents 686 different tracks, that I want to merge into one track per mark/tissue.

## Download and merge tracks

For each mark/tissue, I download the available tracks, overlap the peaks into sub-peaks (*disjoin*) and keep the pieces supported by more than half the tracks. Finally, these recurrent sub-peaks are stitched (*reduce*) if closer than 500 bp.

Afterwards, the regions for each mark is annotated with the number of tissues with overlapping regions.



The results were uploaded there: [https://dl.dropboxusercontent.com/s/8c412u1ug2lwrc2/epiTracks.RData?dl=0](https://dl.dropboxusercontent.com/s/8c412u1ug2lwrc2/epiTracks.RData?dl=0).

## Overview

![plot of chunk unnamed-chunk-4]({{ site.baseurl }}images/figure/source/2016-09-06-epigeneticTracks/unnamed-chunk-4-1.png)![plot of chunk unnamed-chunk-4]({{ site.baseurl }}images/figure/source/2016-09-06-epigeneticTracks/unnamed-chunk-4-2.png)![plot of chunk unnamed-chunk-4]({{ site.baseurl }}images/figure/source/2016-09-06-epigeneticTracks/unnamed-chunk-4-3.png)

## Density map

Using non-overlapping windows of 1 Mb the top 10 denser Mb in tissue-specific marks looks like this:

![plot of chunk unnamed-chunk-5]({{ site.baseurl }}images/figure/source/2016-09-06-epigeneticTracks/unnamed-chunk-5-1.png)

## Limitations

I searched all tracks with keywords *$tissue*, *$mark* (and *peak*, *hg19*). 
**It's possible that several tracks correspond to the same sample**, for example one has *narrowPeaks* while the other has *broadPeaks*.
In summary, I can't make sure that the different tracks come from different replicates.
Maybe there is a way to automatically find and integrate this information but it might be painful if the metadata is messy.
Instead I decided to use a **more stringent cutoff** when selecting the "replicated" regions: I keep regions that are seen in more than half the tracks.

I also made **some arbitrary choices**. 
For example, in for a particular mark/tissue, I stitch together regions that are at 500 bp or less.
The main motivation is to reduce the amount of data.
Also, I'm interested in large variants (SVs), so this resolution is fine.
