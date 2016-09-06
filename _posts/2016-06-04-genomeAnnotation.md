---
layout: posttoc
title: Human Genome - Annotation Exploration
tags: genome
---



{% highlight text %}
Error in library(ggrepel): there is no package called 'ggrepel'
{% endhighlight %}

# Quick look at the annotations

## Genes


In Gencode V19 and focusing on autosomes/X/Y, there are 57783 "genes" of different types:


|type                     |     n|
|:------------------------|-----:|
|protein_coding           | 20332|
|pseudogene               | 13931|
|lincRNA                  |  7114|
|antisense                |  5276|
|miRNA                    |  3055|
|misc_RNA                 |  2034|
|snRNA                    |  1916|
|snoRNA                   |  1457|
|sense_intronic           |   742|
|rRNA                     |   527|
|processed_transcript     |   515|
|sense_overlapping        |   202|
|IG_V_pseudogene          |   187|
|IG_V_gene                |   138|
|TR_V_gene                |    97|
|TR_J_gene                |    74|
|polymorphic_pseudogene   |    45|
|IG_D_gene                |    37|
|TR_V_pseudogene          |    27|
|3prime_overlapping_ncrna |    21|
|IG_J_gene                |    18|
|IG_C_gene                |    14|
|IG_C_pseudogene          |     9|
|TR_C_gene                |     5|
|TR_J_pseudogene          |     4|
|IG_J_pseudogene          |     3|
|TR_D_gene                |     3|



## Exons


In Gencode V19 and focusing on autosomes/X/Y, there are 1196256 "exons" from different types of genes:


|type                     |       n|
|:------------------------|-------:|
|protein_coding           | 1070764|
|pseudogene               |   39909|
|lincRNA                  |   33455|
|antisense                |   26981|
|processed_transcript     |   10846|
|miRNA                    |    3055|
|misc_RNA                 |    2034|
|snRNA                    |    1916|
|polymorphic_pseudogene   |    1750|
|sense_intronic           |    1619|
|snoRNA                   |    1457|
|sense_overlapping        |     834|
|rRNA                     |     527|
|IG_V_pseudogene          |     298|
|IG_V_gene                |     284|
|TR_V_gene                |     193|
|TR_J_gene                |      74|
|IG_C_gene                |      60|
|3prime_overlapping_ncrna |      54|
|TR_V_pseudogene          |      45|
|IG_D_gene                |      37|
|TR_C_gene                |      19|
|IG_J_gene                |      18|
|IG_C_pseudogene          |      17|
|TR_J_pseudogene          |       4|
|IG_J_pseudogene          |       3|
|TR_D_gene                |       3|

I focus on exons from protein-coding genes because it's what we think about most of the time.



## Mappability

The mappability track was produced from the UCSC track. The raw file contains, for each base in the genome, an estimation of how likely a read is correctly mapped to this position. Using a sliding-window approach, I computed the average mappability in regions of size 1 Kbp.



![plot of chunk unnamed-chunk-9]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-9-1.png)![plot of chunk unnamed-chunk-9]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-9-2.png)

For later use I also define regions of low-mappability as regions with an average mappability below 0.75, which represents 14% of the genome.



## Centromere, telomeres and gaps
I group different elements in this class:


|type            |   n| mean.size.kb|
|:---------------|---:|------------:|
|telomere        | 232|         10.0|
|clone           | 207|         56.2|
|contig          | 163|         98.9|
|centromere      |  24|       3000.0|
|heterochromatin |  12|       6039.8|
|short_arm       |   5|      13432.2|

## Simple repeats


|sequence |     n|
|:--------|-----:|
|T        | 35301|
|A        | 34898|
|AC       | 23317|
|TG       | 19739|
|GT       | 13727|
|AT       | 12311|
|TA       | 11429|
|CA       |  9722|
|AAAT     |  6875|
|TTTA     |  5345|

In total there are 962714 annotated simple repeats.

## RepeatMasker annotation



There are different classes of repeats in RepeatMasker annotation:


|repClass       |       n|
|:--------------|-------:|
|SINE           | 1793723|
|LINE           | 1498690|
|LTR            |  717656|
|DNA            |  461751|
|Simple_repeat  |  417913|
|Low_complexity |  371543|
|Satellite      |    9566|
|Unknown        |    7036|
|snRNA          |    4386|
|Other          |    3733|
|RC             |    2236|
|tRNA           |    2002|
|DNA?           |    1881|
|rRNA           |    1769|
|srpRNA         |    1481|
|scRNA          |    1340|
|RNA            |     729|
|SINE?          |     425|
|LTR?           |     122|
|Unknown?       |      97|
|LINE?          |      51|

I extract DNA satellites. They are grouped in different families:


|repName   |repFamily |    n|
|:---------|:---------|----:|
|BSR/Beta  |Satellite | 1984|
|(GAATG)n  |Satellite | 1362|
|ALR/Alpha |centr     | 1301|
|(CATTC)n  |Satellite | 1096|
|SST1      |centr     |  612|
|SATR1     |Satellite |  544|
|HSATII    |Satellite |  399|
|MSR1      |Satellite |  316|
|SATR2     |Satellite |  262|
|HSAT5     |Satellite |  260|
|D20S16    |Satellite |  254|
|REP522    |telo      |  244|
|GSATII    |centr     |  190|
|TAR1      |telo      |  161|
|LSAU      |Satellite |  129|
|HSAT4     |centr     |   99|
|CER       |Satellite |   72|
|GSAT      |centr     |   67|
|ACRO1     |acro      |   61|
|GSATX     |centr     |   56|
|HSATI     |Satellite |   45|
|SUBTEL_sa |Satellite |   34|
|HSAT6     |Satellite |   17|
|SAR       |Satellite |    1|

I also extract transposable elements.


|repFamily     |repClass |       n|
|:-------------|:--------|-------:|
|Alu           |SINE     | 1194734|
|L1            |LINE     |  951780|
|MIR           |SINE     |  595094|
|L2            |LINE     |  466438|
|ERVL-MaLR     |LTR      |  347105|
|hAT-Charlie   |DNA      |  254646|
|ERV1          |LTR      |  175937|
|ERVL          |LTR      |  160346|
|TcMar-Tigger  |DNA      |  104026|
|CR1           |LINE     |   61303|
|hAT-Tip100    |DNA      |   30669|
|hAT-Blackjack |DNA      |   19755|
|RTE           |LINE     |   17874|
|TcMar-Mariner |DNA      |   16348|
|hAT           |DNA      |   12573|
|Gypsy         |LTR      |   10892|
|ERVK          |LTR      |   10868|
|TcMar-Tc2     |DNA      |    8156|
|Gypsy?        |LTR      |    7869|
|Other         |Other    |    3733|
|TcMar?        |DNA      |    3424|
|hAT?          |DNA      |    3050|
|DNA           |DNA      |    2744|
|LTR           |LTR      |    2206|
|PiggyBac      |DNA      |    2120|
|MuDR          |DNA      |    1992|
|TcMar         |DNA      |    1950|
|ERVL?         |LTR      |    1854|
|tRNA          |SINE     |    1668|
|Deu           |SINE     |    1265|
|SINE          |SINE     |     962|
|RTE-BovB      |LINE     |     655|
|ERV           |LTR      |     579|
|Dong-R4       |LINE     |     556|
|PiggyBac?     |DNA      |     241|
|L1?           |LINE     |      84|
|Merlin        |DNA      |      57|

Moreover they are organized in 909 sub-families.


# Genes

## Size

![plot of chunk unnamed-chunk-17]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-17-1.png)

The largest annotated genes are


|chr |name    |type.f         |  size.kb|
|:---|:-------|:--------------|--------:|
|7   |CNTNAP2 |protein_coding | 2304.637|
|9   |PTPRD   |protein_coding | 2298.477|
|X   |DMD     |protein_coding | 2241.764|
|3   |LSAMP   |protein_coding | 2194.860|
|11  |DLG2    |protein_coding | 2172.911|
|8   |CSMD1   |protein_coding | 2059.619|
|20  |MACROD2 |protein_coding | 2057.827|
|6   |EYS     |protein_coding | 1987.242|
|2   |LRP1B   |protein_coding | 1900.278|
|10  |PCDH15  |protein_coding | 1825.171|

The smallest protein-coding annotated genes are


|chr |name       |type.f         | size.kb|
|:---|:----------|:--------------|-------:|
|2   |AC011308.1 |protein_coding |   0.058|
|12  |AC055736.1 |protein_coding |   0.065|
|16  |PIH1       |protein_coding |   0.092|
|2   |AC012360.2 |protein_coding |   0.095|
|5   |AC008914.1 |protein_coding |   0.101|
|2   |MGC4771    |protein_coding |   0.104|
|2   |CATX-2     |protein_coding |   0.110|
|X   |GAGE12B    |protein_coding |   0.116|
|7   |AC083862.1 |protein_coding |   0.119|
|1   |AL606500.1 |protein_coding |   0.123|

## Density
Using non-overlapping windows of 1 Mb the gene density looks like this:

![plot of chunk unnamed-chunk-20]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-20-1.png)![plot of chunk unnamed-chunk-20]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-20-2.png)![plot of chunk unnamed-chunk-20]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-20-3.png)

## Mappability

Here I compute how many genes overlap regions of low-mappability (defined previously).Also how many genes are within those regions, defined as genes with at least 50% of their body overlapping low-mappability regions.

![plot of chunk unnamed-chunk-21]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-21-1.png)![plot of chunk unnamed-chunk-21]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-21-2.png)![plot of chunk unnamed-chunk-21]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-21-3.png)![plot of chunk unnamed-chunk-21]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-21-4.png)

## Centromere, telomeres and gaps


As a control, random regions of similar sizes are used.



![plot of chunk unnamed-chunk-24]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-24-1.png)

## Summary table


|type.f         |    nb| min.kb| mean.kb| med.kb|  max.kb| inLowMap| olLowMap| genePerMb|
|:--------------|-----:|------:|-------:|------:|-------:|--------:|--------:|---------:|
|protein_coding | 20332|   0.06|   65.35|  25.70| 2304.64|     0.05|     0.31|      6.96|
|pseudogene     | 13931|   0.02|    3.58|   0.73|  586.57|     0.17|     0.21|      4.49|
|other          |  7417|   0.01|   20.29|   3.71| 1536.21|     0.05|     0.17|      2.43|
|lincRNA        |  7114|   0.09|   27.98|   5.69| 1375.32|     0.08|     0.25|      2.35|
|RNA            |  5934|   0.03|    0.14|   0.11|    0.52|     0.06|     0.06|      1.91|
|miRNA          |  3055|   0.04|    0.09|   0.08|    0.19|     0.08|     0.08|      0.98|

# Exons

## Size

![plot of chunk unnamed-chunk-26]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-26-1.png)![plot of chunk unnamed-chunk-26]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-26-2.png)

The largest annotated exons are


|chr |name    | size.kb|
|:---|:-------|-------:|
|8   |TRAPPC9 |  29.059|
|5   |MCC     |  27.198|
|12  |GRIN2B  |  24.408|
|19  |MUC16   |  21.692|
|2   |ABI2    |  20.546|
|6   |CNKSR3  |  19.148|
|8   |XKR4    |  18.773|
|2   |SLC8A1  |  18.359|
|11  |AHNAK   |  18.169|
|21  |KCNJ6   |  18.108|

The smallest protein-coding annotated exons are


|chr |name       | size.kb|
|:---|:----------|-------:|
|2   |ALK        |       0|
|3   |ACAD11     |       0|
|4   |PPA2       |       0|
|5   |PAM        |       0|
|5   |GALNT10    |       0|
|5   |CYFIP2     |       0|
|6   |HDDC2      |       0|
|7   |SRRM3      |       0|
|11  |AP002884.3 |       0|
|12  |YAF2       |       0|

*ToDo: Size per type (first exon, second exon, ...)*

## Density
Using non-overlapping windows of 1 Mb the gene density looks like this:

![plot of chunk unnamed-chunk-29]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-29-1.png)

There are, on average, 357.8926476 exons per Mb.

## Mappability
![plot of chunk unnamed-chunk-30]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-30-1.png)

35201 exons overlap low-mappability regions.

## Centromere, telomeres and gaps


As a control, random regions of similar sizes are used.



![plot of chunk unnamed-chunk-33]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-33-1.png)

# GWAS

# Mappability

## Density
Using non-overlapping windows of 1 Mb the density of low-mappability regions looks like this:

![plot of chunk unnamed-chunk-34]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-34-1.png)![plot of chunk unnamed-chunk-34]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-34-2.png)

*Yellow regions are 1 Mb regions fully annotated as low-mappability.*

# Segmental duplications

# DNA Satellites

# Centromeres, telomeres and gaps

# Simple repeats

![plot of chunk unnamed-chunk-35]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-35-1.png)![plot of chunk unnamed-chunk-35]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-35-2.png)![plot of chunk unnamed-chunk-35]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-35-3.png)![plot of chunk unnamed-chunk-35]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-35-4.png)

+ Interestingly, there is much less STR of period 3 than expected. Why ?
+ There is also this burst at copy-number 25. Methodological artifact ?

Grouping the repeats according to their motif, we can ask how frequent is each motif.


{% highlight text %}
Error in eval(expr, envir, enclos): could not find function "geom_text_repel"
{% endhighlight %}



{% highlight text %}
Error in eval(expr, envir, enclos): could not find function "geom_text_repel"
{% endhighlight %}

## Summary tables

Most numerous STRs:


|sequence | period|     n| n.100| n.400| n.1k| size.mean| total.kb|period.class |
|:--------|------:|-----:|-----:|-----:|----:|---------:|--------:|:------------|
|T        |      1| 35301|     5|     1|    0|     31.12|  1098.73|1            |
|A        |      1| 34898|     9|     0|    0|     31.14|  1086.68|1            |
|AC       |      2| 23317|   258|    70|   11|     43.12|  1005.36|2            |
|TG       |      2| 19739|   300|    75|   10|     44.27|   873.94|2            |
|GT       |      2| 13727|   240|    84|   12|     45.87|   629.69|2            |
|AT       |      2| 12311|  2747|   354|   64|     92.65|  1140.66|2            |
|TA       |      2| 11429|  2801|   377|   85|    100.86|  1152.69|2            |
|CA       |      2|  9722|   258|    78|   17|     48.64|   472.84|2            |
|AAAT     |      4|  6875|     1|     0|    0|     38.98|   268.02|4            |
|TTTA     |      4|  5345|     8|     0|    0|     39.57|   211.48|4            |

Most numerous in term of instances larger than 100 bp:


|sequence | period|     n| n.100| n.400| n.1k| size.mean| total.kb|period.class |
|:--------|------:|-----:|-----:|-----:|----:|---------:|--------:|:------------|
|TA       |      2| 11429|  2801|   377|   85|    100.86|  1152.69|2            |
|AT       |      2| 12311|  2747|   354|   64|     92.65|  1140.66|2            |
|AAAG     |      4|  3163|  1272|    16|    0|    101.49|   321.00|4            |
|TTTC     |      4|  2843|  1217|    34|    0|    107.36|   305.22|4            |
|TCTT     |      4|  1580|   749|    11|    0|    114.62|   181.09|4            |
|AGAA     |      4|  1305|   693|    15|    0|    125.65|   163.97|4            |
|GAAA     |      4|  1166|   627|    12|    0|    127.67|   148.86|4            |
|CTTT     |      4|  1241|   620|     2|    0|    118.08|   146.53|4            |
|TTCC     |      4|  1888|   552|    21|    1|     95.04|   179.44|4            |
|AAGG     |      4|  1734|   541|    35|    2|    100.42|   174.13|4            |

Most numerous in term of instances larger than 400 bp:


|sequence                                 | period|     n| n.100| n.400| n.1k| size.mean| total.kb|period.class |
|:----------------------------------------|------:|-----:|-----:|-----:|----:|---------:|--------:|:------------|
|TA                                       |      2| 11429|  2801|   377|   85|    100.86|  1152.69|2            |
|AT                                       |      2| 12311|  2747|   354|   64|     92.65|  1140.66|2            |
|GCCTCTGCCCGGCCGCCACCCCGTCTGGGAAGTGAGGAGC |     40|   182|   182|   153|    0|    468.81|    85.32|>6           |
|TCCCAGACGGGGTGGCGGCCGGGCAGAGACGCTCCTCACT |     40|   111|   111|    98|    0|    459.25|    50.98|>6           |
|ATATATA                                  |      7|   348|   258|    91|   15|    305.88|   106.45|>6           |
|GT                                       |      2| 13727|   240|    84|   12|     45.87|   629.69|2            |
|CA                                       |      2|  9722|   258|    78|   17|     48.64|   472.84|2            |
|TG                                       |      2| 19739|   300|    75|   10|     44.27|   873.94|2            |
|TATATAT                                  |      7|   286|   209|    72|   17|    335.49|    95.95|>6           |
|AC                                       |      2| 23317|   258|    70|   11|     43.12|  1005.36|2            |

Set of large and numerous STRs (names annotated in the previous graphs):


|sequence | period|     n| n.100| n.400| n.1k| size.mean| total.kb|period.class |
|:--------|------:|-----:|-----:|-----:|----:|---------:|--------:|:------------|
|AT       |      2| 12311|  2747|   354|   64|     92.65|  1140.66|2            |
|TA       |      2| 11429|  2801|   377|   85|    100.86|  1152.69|2            |
|AAAG     |      4|  3163|  1272|    16|    0|    101.49|   321.00|4            |
|TTTC     |      4|  2843|  1217|    34|    0|    107.36|   305.22|4            |
|TTCC     |      4|  1888|   552|    21|    1|     95.04|   179.44|4            |
|AAGG     |      4|  1734|   541|    35|    2|    100.42|   174.13|4            |
|TCTT     |      4|  1580|   749|    11|    0|    114.62|   181.09|4            |
|TATC     |      4|  1426|   195|    23|    6|     83.24|   118.70|4            |
|CCTT     |      4|  1404|   354|    20|    0|     92.31|   129.60|4            |
|AGAA     |      4|  1305|   693|    15|    0|    125.65|   163.97|4            |
|GAAG     |      4|  1284|   410|    12|    0|     96.08|   123.36|4            |
|CTTT     |      4|  1241|   620|     2|    0|    118.08|   146.53|4            |
|GAAA     |      4|  1166|   627|    12|    0|    127.67|   148.86|4            |
|ATAG     |      4|  1133|   186|    24|    8|     87.22|    98.82|4            |
|AGGA     |      4|  1130|   303|    26|    2|     97.65|   110.35|4            |
|AGAT     |      4|  1009|   187|    21|    0|     86.98|    87.76|4            |
|TCTA     |      4|   945|   163|    18|    1|     85.68|    80.97|4            |
|GGAA     |      4|   907|   270|    16|    0|     98.79|    89.60|4            |
|TCCT     |      4|   901|   278|    10|    0|     96.36|    86.82|4            |
|ATCT     |      4|   836|   145|    19|    4|     91.24|    76.28|4            |
|CTTC     |      4|   817|   246|    11|    0|     96.46|    78.81|4            |
|AAGA     |      4|   761|   390|    10|    0|    127.96|    97.38|4            |
|TTCT     |      4|   748|   340|    10|    0|    115.62|    86.48|4            |
|TAGA     |      4|   706|   118|    28|    2|     95.19|    67.21|4            |
|GATA     |      4|   682|   137|    26|    4|    105.61|    72.03|4            |


# DNA satellites

![plot of chunk unnamed-chunk-41]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-41-1.png)

|repName   | mean.size|
|:---------|---------:|
|SUBTEL_sa |     87.74|
|HSAT5     |    126.92|
|D20S16    |    149.57|
|HSAT6     |    233.24|
|LSAU      |    267.70|
|MSR1      |    279.90|
|(GAATG)n  |    319.12|
|(CATTC)n  |    332.20|
|HSATI     |    442.89|
|TAR1      |    554.02|
|SST1      |    602.01|
|HSATII    |    712.02|
|REP522    |    712.68|
|BSR/Beta  |    720.22|
|ACRO1     |    744.80|
|GSATII    |   1044.12|
|SATR2     |   1253.72|
|SATR1     |   1696.22|
|GSATX     |   1834.30|
|HSAT4     |   2390.72|
|GSAT      |   3575.97|
|SAR       |   4775.00|
|ALR/Alpha |   5723.55|
|CER       |   7535.17|

![plot of chunk unnamed-chunk-41]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-41-2.png)

# Transposable elements

![plot of chunk unnamed-chunk-42]({{ site.baseurl }}images/figure/source/2016-06-04-genomeAnnotation/unnamed-chunk-42-1.png)
