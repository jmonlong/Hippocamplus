The scripts I used to get the received-to-accepted and received-to-published time for [this post](http://jmonlong.github.io/Hippocamplus/2018/02/23/journals-comparison/).

## Script

`journalPubTimeCrawler.R` R script uses `rvest` and `RSelenium` to scrape information from journals' websites.

After starting the selenium Docker image, the workflow for each journal is:

1. PubMed search for publications in 2016 and export results as CSV.
1. Read and format this CSV into a R object: <journal>.pm
1. Write/adapt the functions to get infos from website: scrape.<journal>
1. Optional: keep a subset of papers, remembering how much was sub-sampled (ss column). 'ss' also keeps track of missing data for future extrapolation.
1. Scrape each publication into a list <journal>.l and save in <journal>.RData

At the end, merge and clean up everything. Decide which articles to remove (reviews, ...) etc.

For some journals I could reuse scrape functions: same function for all PLoS journals, same for all BMC journals, or for Nature journals, etc

More details in the code.

## Data

The data for *Am J Hum Genet.*, *Bioinformatics*, *BMC Bioinformatics*, *BMC Biology*, *BMC Genomics*, *Cell*, *Cell Reports*, *eLife*, *Genetics*, *Genome Biology*, *Genome Research*, *GigaScience*, *NAR*, *Nature*, *Nature Biotech*, *Nature Communications*, *Nature Genetics*, *Nature Methods*, *PeerJ*, *PLoS Biology*, *PLoS Comput Biol*, *PLoS Genet.*, *PLoS ONE*, *Science*, *Scientific Reports*.

In `journalPubTime.tsv`:

- *ra*: received-to-accepted time in days.
- *rp*: received-to-published time in days.
- *ss*: how much sub-sampling occurred. Extrapolate total number of pubs by summing the ss.
- *typec*: manually standardized article types (see end of `journalPubTimeCrawler.R`).

In R, read with `read.table('journalPubTime.tsv', header=TRUE, as.is=TRUE, sep='\t', quote=NULL)`. 
