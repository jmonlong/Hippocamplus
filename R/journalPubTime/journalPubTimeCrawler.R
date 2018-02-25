## After starting the selenium Docker image, the workflow for each journal is:
##  - PubMed search for publications in 2016 and export results as CSV.
##  - Read and format this CSV into a R object: <journal>.pm
##  - Write/adapt the functions to get infos from website: scrape.<journal>
##  - Optional: keep a subset of papers, remembering how much was sub-sampled (ss column). 'ss' also keeps track of missing data for future extrapolation.
##  - Scrape each publication into a list <journal>.l and save in <journal>.RData

## At the end, merge and clean up everything. Decide which articles to remove (reviews, ...) etc.

## For some journals I could reuse scrape functions: same function for all PLoS journals, same for all BMC journals, or for Nature journals, etc


library(rvest)
library(magrittr)
library(dplyr)
library(tidyr)
library(ggplot2)

getDOI <- function(det){
  ## Get the first DOI in PubMed's field or NA if no DOI information.
  res = det %>% sub('doi', 'doidoi', .) %>% gsub('.*doidoi: ([^ ]+)\\..*', '\\1', .)
  return(ifelse(res==det, NA, res))
}


##
## Start Selenium
##

### docker run -d -p 4446:4444 selenium/standalone-firefox:2.53.1
### The IP from 'docker-machine ip' is used as param for 'remoteServerAddr'

library(RSelenium)
remDr <- remoteDriver(remoteServerAddr = "192.168.99.100", port = 4446L)
remDr$open()


##
## Functions that navigate to the journal's page and retrieve infos
##

## PLoS
scrape.plosg <- function(doi, max.tries=10){
  pub.url = paste0('http://dx.doi.org/', doi)
  remDr$navigate(pub.url)
  pubh  = read_html(remDr$getPageSource()[[1]])
  type = pubh %>% html_nodes('#artType') %>% html_text()
  cpt=0
  while(length(type)==0 & cpt<max.tries){
    cpt = cpt + 1
    remDr$navigate(pub.url)
    pubh  = read_html(remDr$getPageSource()[[1]])
    type = pubh %>% html_nodes('#artType') %>% html_text()
  }
  info = pubh %>% html_nodes('.articleinfo') %>% html_nodes('p') %>% html_text()
  date.r = info[grepl('Received:', info)] %>% gsub('Received: +([^;]+);.*', '\\1', .) %>% as.Date(format="%B %d, %Y")
  date.p = info[grepl('Received:', info)] %>% gsub('.*Published: +([^;]+)', '\\1', .) %>% as.Date(format="%B %d, %Y")
  date.a = info[grepl('Received:', info)] %>% gsub('.*Accepted: +([^;]+);.*', '\\1', .) %>% as.Date(format="%B %d, %Y")
  if(length(date.r)==0){
    return(data.frame(doi, type, date.r=NA, date.p=NA, date.a=NA, ra=NA, rp=NA))
  }
  return(data.frame(doi, type, date.r, date.p, date.a, ra=  difftime(date.a, date.r, units='days') %>% as.numeric, rp=difftime(date.p, date.r, units='days') %>% as.numeric))
}

## AJHG
scrape.ajhg <- function(doi, max.tries=10){
  pub.url = paste0('http://dx.doi.org/', doi)
  remDr$navigate(pub.url)
  if(grepl('.pdf?', unlist(remDr$getCurrentUrl()))){
    message("Skipping pdf")
    return(data.frame(doi, type=NA, date.r=NA, date.p=NA, date.a=NA, ra=NA, rp=NA))
  }
  pubh  = read_html(remDr$getPageSource()[[1]])
  type = pubh %>% html_nodes('.artLabel') %>% html_text()
  cpt=0
  while(length(type)==0 & cpt<max.tries){
    cpt = cpt + 1
    remDr$navigate(pub.url)
    pubh  = read_html(remDr$getPageSource()[[1]])
    type = pubh %>% html_nodes('.artLabel') %>% html_text()
  }
  if(length(type)==0){
    return(data.frame(doi, type=NA, date.r=NA, date.p=NA, date.a=NA, ra=NA, rp=NA))
  }
  info = pubh %>% html_nodes('.pubDatesRow') %>% html_text()
  date.r = info[grep('Received:', info)[1]] %>% gsub('Received: +', '', .) %>% as.Date(format="%B %d, %Y")
  date.a = info[grep('Accepted:', info)[1]] %>% gsub('Accepted: +', '', .) %>% as.Date(format="%B %d, %Y")
  date.p = info[grep('Published:', info)[1]] %>% gsub('Published: +', '', .) %>% as.Date(format="%B %d, %Y")
  return(data.frame(doi, type, date.r, date.p, date.a, ra=  difftime(date.a, date.r, units='days') %>% as.numeric, rp=difftime(date.p, date.r, units='days') %>% as.numeric))
}

## eLife
scrape.elife <- function(doi, max.tries=10){
  pub.url = paste0('http://dx.doi.org/', doi)
  remDr$navigate(pub.url)
  pubh  = read_html(remDr$getPageSource()[[1]])
  type = pubh %>% html_nodes('.meta') %>% html_nodes('a') %>% html_text() %>% head(1)
  cpt=0
  while(length(type)==0 & cpt<max.tries){
    cpt = cpt + 1
    remDr$navigate(pub.url)
    pubh  = read_html(remDr$getPageSource()[[1]])
    type = pubh %>% html_nodes('.meta') %>% html_nodes('a') %>% html_text() %>% head(1)
  }
  if(length(type)==0){
    return(data.frame(doi, type=NA, date.r=NA, date.p=NA, date.a=NA, ra=NA, rp=NA))
  }
  info = pubh %>% html_nodes('.article-section') %>% html_nodes('li') %>% html_text()
  date.r = info[grep('Received:', info)[1]] %>% gsub('Received: +', '', .) %>% as.Date(format="%B %d, %Y")
  date.a = info[grep('Accepted:', info)[1]] %>% gsub('Accepted: +', '', .) %>% as.Date(format="%B %d, %Y")
  date.p = info[grep('published:', info)[1]] %>% gsub('.*published: +(.+)', '\\1', .) %>% as.Date(format="%B %d, %Y")
  return(data.frame(doi, type, date.r, date.p, date.a, ra=  difftime(date.a, date.r, units='days') %>% as.numeric, rp=difftime(date.p, date.r, units='days') %>% as.numeric))
}

## Genome Research
scrape.genomeresearch <- function(doi, max.tries=10){
  pub.url = paste0('http://dx.doi.org/', doi)
  remDr$navigate(pub.url)
  pubh  = read_html(remDr$getPageSource()[[1]])
  type = pubh %>% html_nodes('#cb-art-cat') %>% html_nodes('.last-child') %>% html_nodes('a') %>% html_text()
  cpt=0
  while(length(type)==0 & cpt<max.tries){
    cpt = cpt + 1
    remDr$navigate(pub.url)
    pubh  = read_html(remDr$getPageSource()[[1]])
    type = pubh %>% html_nodes('#cb-art-cat') %>% html_nodes('.last-child') %>% html_nodes('a') %>% html_text()
  }
  if(length(type)==0){
    return(data.frame(doi, type=NA, date.r=NA, date.p=NA, date.a=NA, ra=NA, rp=NA))
  }
  date.r = pubh %>% html_nodes('.received') %>% html_text() %>% gsub('Received +', '', .) %>% as.Date(format="%B %d, %Y")
  date.a = pubh %>% html_nodes('.accepted') %>% html_text() %>% gsub('Accepted +', '', .) %>% as.Date(format="%B %d, %Y")
  date.p = pubh %>% html_nodes('.slug-ahead-of-print-date') %>% html_text()%>% as.Date(format="%B %d, %Y") %>% head(1)
  if(length(date.p)==0){
    date.p = NA
  }
  if(length(date.a)==0){
    date.r = date.a = NA
  }
  return(data.frame(doi, type, date.r, date.p, date.a, ra=  difftime(date.a, date.r, units='days') %>% as.numeric, rp=difftime(date.p, date.r, units='days') %>% as.numeric))
}

## Genome Biology
scrape.gbiol <- function(doi, max.tries=10){
  pub.url = paste0('http://dx.doi.org/', doi)
  remDr$navigate(pub.url)
  pubh  = read_html(remDr$getPageSource()[[1]])
  type = pubh %>% html_nodes('.ArticleCategory') %>% html_text()
  cpt=0
  while(length(type)==0 & cpt<max.tries){
    cpt = cpt + 1
    remDr$navigate(pub.url)
    pubh  = read_html(remDr$getPageSource()[[1]])
    type = pubh %>% html_nodes('.ArticleCategory') %>% html_text()
  }
  if(length(type)==0){
    return(data.frame(doi, type=NA, date.r=NA, date.p=NA, date.a=NA, ra=NA, rp=NA))
  }
  date.r = pubh %>% html_nodes('.HistoryReceived') %>% html_text() %>% gsub('Received: +', '', .) %>% as.Date(format="%d %B %Y")
  date.a = pubh %>% html_nodes('.HistoryAccepted') %>% html_text() %>% gsub('Accepted: +', '', .) %>% as.Date(format="%d %B %Y")
  date.p = pubh %>% html_nodes('.HistoryOnlineDate') %>% html_text() %>% gsub('Published: +', '', .) %>% as.Date(format="%d %B %Y")
  if(length(date.p)==0){
    date.p = NA
  }
  if(length(date.a)==0){
    date.r = date.a = NA
  }
  return(data.frame(doi, type, date.r, date.p, date.a, ra=  difftime(date.a, date.r, units='days') %>% as.numeric, rp=difftime(date.p, date.r, units='days') %>% as.numeric))
}

## PeerJ
scrape.peerj <- function(doi, max.tries=10){
  pub.url = paste0('http://dx.doi.org/', doi)
  remDr$navigate(pub.url)
  pubh  = read_html(remDr$getPageSource()[[1]])
  type = pubh %>% html_nodes('.peer-reviewed') %>% html_text() %>% head(1) %>% gsub('\n| ','', .)
  cpt=0
  while(length(type)==0 & cpt<max.tries){
    cpt = cpt + 1
    remDr$navigate(pub.url)
    pubh  = read_html(remDr$getPageSource()[[1]])
    type = pubh %>% html_nodes('.peer-reviewed') %>% html_text() %>% head(1) %>% gsub('\n| ','', .)
  }
  if(length(type)==0){
    return(data.frame(doi, type=NA, date.r=NA, date.p=NA, date.a=NA, ra=NA, rp=NA))
  }
  info = pubh %>% html_nodes('.article-dates') %>% html_text()
  date.r =  gsub('.*Received\n([^\n]+)\n.*', '\\1', info) %>% as.Date()
  date.a =  gsub('.*Accepted\n([^\n]+)\n.*', '\\1', info) %>% as.Date()
  date.p =  gsub('.*Published\n([^\n]+)\n.*', '\\1', info) %>% as.Date()
  if(length(date.p)==0){
    date.p = NA
  }
  if(length(date.a)==0){
    date.r = date.a = NA
  }
  return(data.frame(doi, type, date.r, date.p, date.a, ra=  difftime(date.a, date.r, units='days') %>% as.numeric, rp=difftime(date.p, date.r, units='days') %>% as.numeric))
}

## Genetics
scrape.genetics <- function(doi, max.tries=10){
  pub.url = paste0('http://dx.doi.org/', doi)
  remDr$navigate(pub.url)
  pub.url = paste0(remDr$getCurrentUrl(), '.article-info')
  remDr$navigate(pub.url)
  pubh  = read_html(remDr$getPageSource()[[1]])
  type = pubh %>% html_nodes('.pane-node-field-highwire-article-category') %>% html_nodes('.field-item') %>% html_text %>% head(1)
  cpt=0
  while(length(type)==0 & cpt<max.tries){
    cpt = cpt + 1
    remDr$navigate(pub.url)
    pubh  = read_html(remDr$getPageSource()[[1]])
    type = pubh %>% html_nodes('.pane-node-field-highwire-article-category') %>% html_nodes('.field-item') %>% html_text %>% head(1)
  }
  if(length(type)==0){
    return(data.frame(doi, type=NA, date.r=NA, date.p=NA, date.a=NA, ra=NA, rp=NA))
  }
  info = pubh %>% html_nodes('.publication-history') %>% html_nodes('li') %>% html_text()
  date.r =  gsub('Received +(.+)', '\\1', info[1]) %>% as.Date(format="%B %d, %Y")
  date.a =  gsub('Accepted +(.+)', '\\1', info[2]) %>% as.Date(format="%B %d, %Y")
  date.p =  gsub('Published online +(.+)', '\\1', info[3]) %>% as.Date(format="%B %d, %Y")
  if(length(date.p)==0){
    date.p = NA
  }
  if(length(date.a)==0){
    date.r = date.a = NA
  }
  return(data.frame(doi, type, date.r, date.p, date.a, ra=  difftime(date.a, date.r, units='days') %>% as.numeric, rp=difftime(date.p, date.r, units='days') %>% as.numeric))
}

## NAR
scrape.nar <- function(doi, max.tries=10){
  pub.url = paste0('http://dx.doi.org/', doi)
  remDr$navigate(pub.url)
  pubh  = read_html(remDr$getPageSource()[[1]])
  type = pubh %>% html_nodes('.article-metadata-tocSections') %>% html_text %>% gsub('.*Issue Section:\n +([^\n]+)\n.*', '\\1', .)
  cpt=0
  while(length(type)==0 & cpt<max.tries){
    cpt = cpt + 1
    remDr$navigate(pub.url)
    pubh  = read_html(remDr$getPageSource()[[1]])
    type = pubh %>% html_nodes('.article-metadata-tocSections') %>% html_text %>% gsub('.*Issue Section:\n +([^\n]+)\n.*', '\\1', .)
  }
  if(length(type)==0){
    return(data.frame(doi, type=NA, date.r=NA, date.p=NA, date.a=NA, ra=NA, rp=NA))
  }
  info = pubh %>% html_nodes('.pub-history-wrap') %>% html_text()
  date.r =  gsub('.*\n +Received:\n +([^\n]+).*', '\\1', info) %>% as.Date(format='%d %B %Y')
  date.a =  gsub('.*Accepted:\n +([^\n]+).*', '\\1', info) %>% as.Date(format='%d %B %Y')
  date.p =  gsub('.*Published:\n +([^\n]+).*', '\\1', info) %>% as.Date(format='%d %B %Y')
  if(length(date.p)==0){
    date.p = NA
  }
  if(length(date.a)==0){
    date.r = date.a = NA
  }
  type = ifelse(grepl('SURVEY AND SUMMARY', type), 'SURVEY AND SUMMARY', 'Article')
  return(data.frame(doi, type, date.r, date.p, date.a, ra=  difftime(date.a, date.r, units='days') %>% as.numeric, rp=difftime(date.p, date.r, units='days') %>% as.numeric))
}

## Nature
filterAttr <- function(x, attr, value){
  ## Filter on a specific HTML attribute
  attrs = html_attr(x, attr)
  x[which(attrs == value)]
}
scrape.nature <- function(doi, max.tries=10){
  pub.url = paste0('http://dx.doi.org/', doi)
  remDr$navigate(pub.url)
  pubh  = read_html(remDr$getPageSource()[[1]])
  type = pubh %>% html_nodes('.text13') %>% filterAttr('data-test', 'article-identifier') %>% html_text %>% gsub('\\|.*','',.) %>% gsub('\n','',.) %>% gsub('^ *','',.) %>% gsub(' *$','',.)
  cpt=0
  while(length(type)==0 & cpt<max.tries){
    cpt = cpt + 1
    remDr$navigate(pub.url)
    pubh  = read_html(remDr$getPageSource()[[1]])
    type = pubh %>% html_nodes('.text13') %>% filterAttr('data-test', 'article-identifier') %>% html_text %>% gsub('\n','',.) %>% gsub('^ *','',.) %>% gsub(' *$','',.)
  }
  if(length(type)==0){
    return(data.frame(doi, type=NA, date.r=NA, date.p=NA, date.a=NA, ra=NA, rp=NA))
  }
  info = pubh %>% html_nodes('.text14') %>% filterAttr('data-component', 'article-history-list') %>% html_text()
  date.r =  gsub('Received:([^\n]+)Accepted.*', '\\1', info) %>% as.Date(format='%d %B %Y')
  date.a =  gsub('.*Accepted:([^\n]+)Pub.*', '\\1', info) %>% as.Date(format='%d %B %Y')
  date.p =  gsub('.*Published online:([^\n]+).*', '\\1', info) %>% as.Date(format='%d %B %Y')
  if(length(date.p)==0){
    date.p = NA
  }
  if(length(date.a)==0){
    date.r = date.a = NA
  }
  return(data.frame(doi, type, date.r, date.p, date.a, ra=  difftime(date.a, date.r, units='days') %>% as.numeric, rp=difftime(date.p, date.r, units='days') %>% as.numeric))
}

## Science
scrape.science <- function(doi, max.tries=10){
  pub.url = paste0('http://dx.doi.org/', doi)
  remDr$navigate(pub.url)
  pubh  = read_html(remDr$getPageSource()[[1]])
  type = pubh %>% html_nodes('.article__header') %>% html_nodes('.overline') %>% html_text
  cpt=0
  while(length(type)==0 & cpt<max.tries){
    cpt = cpt + 1
    remDr$navigate(pub.url)
    pubh  = read_html(remDr$getPageSource()[[1]])
    type = pubh %>% html_nodes('.article__header') %>% html_nodes('.overline') %>% html_text
  }
  if(length(type)==0){
    return(data.frame(doi, type=NA, date.r=NA, date.p=NA, date.a=NA, ra=NA, rp=NA))
  }
  pub.url = pubh %>% html_nodes('a') %>% filterAttr('data-trigger','tab-article-info') %>% html_attr('href') %>% paste0('http://science.sciencemag.org',.)
  remDr$navigate(pub.url)
  pubh  = read_html(remDr$getPageSource()[[1]])
  type = pubh %>% html_nodes('.article__header') %>% html_nodes('.overline') %>% html_text
  cpt=0
  while(length(type)==0 & cpt<max.tries){
    cpt = cpt + 1
    remDr$navigate(pub.url)
    pubh  = read_html(remDr$getPageSource()[[1]])
    type = pubh %>% html_nodes('.article__header') %>% html_nodes('.overline') %>% html_text
  }
  if(length(type)==0){
    return(data.frame(doi, type=NA, date.r=NA, date.p=NA, date.a=NA, ra=NA, rp=NA))
  }
  info = pubh %>% html_nodes('.publication-history') %>% html_text
  date.r =  gsub('.*Received for publication +([^\n]+)Accepted.*', '\\1', info) %>% as.Date(format='%B %d, %Y')
  date.a =  gsub('.*Accepted for publication +([^\n]+).*.*', '\\1', info) %>% as.Date(format='%B %d, %Y')
  info = pubh %>% html_nodes('.meta-line') %>% html_text %>% gsub(' ','',.)
  date.p =  gsub('.*Science +([^\n]+):Vol.*', '\\1', info) %>% as.Date(format='%d %B %Y')
  if(length(date.p)==0){
    date.p = NA
  }
  if(length(date.a)==0){
    date.r = date.a = NA
  }
  return(data.frame(doi, type, date.r, date.p, date.a, ra=  difftime(date.a, date.r, units='days') %>% as.numeric, rp=difftime(date.p, date.r, units='days') %>% as.numeric))
}

##
## PubMed search and web-scraping for each journal
##

## At first I just wanted to compare PLoS genetics and AJHG.

## PUBMED: ("Plos Genet"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
plosg.pm = read.csv('./plosgenetics2016-pubmed.csv', as.is=TRUE, header=FALSE)
plosg.pm = plosg.pm[,1:11]
colnames(plosg.pm) = plosg.pm[1,]
plosg.pm = plosg.pm[which(plosg.pm[,1]!="Title"),]

## PUBMED: ("Am J Hum Genet."[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
ajhg.pm = read.csv('./ajhg2016-pubmed.csv', as.is=TRUE, header=FALSE)
ajhg.pm = ajhg.pm[,1:11]
colnames(ajhg.pm) = ajhg.pm[1,]
ajhg.pm = ajhg.pm[which(ajhg.pm[,1]!="Title"),]

all.pm = rbind(plosg.pm, ajhg.pm)
all.pm %<>% mutate(journal=gsub('(.+) +.*', '\\1', ShortDetails), doi=gsub('.*doi: ([^ ]+)\\..*', '\\1', Details)) %>% mutate(ss=1)

res.l = list()

while(length(res.l)<nrow(all.pm)){
  ii = length(res.l) + 1
  if(all.pm$journal[ii] == 'Am J Hum Genet. '){
    res.l = c(res.l, list(scrape.ajhg(all.pm$doi[ii])))
  }
  if(all.pm$journal[ii] == 'PLoS Genet. '){
    res.l = c(res.l, list(scrape.plosg(all.pm$doi[ii])))
  }
  if(length(res.l) %% 100 == 0){
    save(all.pm, res.l, file='ajhgPlosg.RData')
    message(length(res.l))
  }
}

save(all.pm, res.l, file='ajhgPlosg.RData')


## Then I decided to analyze more journals

## PUBMED: ("eLife"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
elife.pm = read.csv('./elife2016-pubmed.csv', as.is=TRUE, header=FALSE)
elife.pm = elife.pm[,1:11]
colnames(elife.pm) = elife.pm[1,]
elife.pm = elife.pm[which(elife.pm[,1]!="Title"),]
elife.pm %<>% mutate(journal='eLife', doi=getDOI(Details), ss=1)

elife.l = list()

while(length(elife.l)<nrow(elife.pm)){
  ii = length(elife.l) + 1
  elife.l = c(elife.l, list(scrape.elife(elife.pm$doi[ii])))
  if(length(elife.l) %% 100 == 0){
    save(elife.pm, elife.l, file='elife.RData')
    message(length(elife.l))
  }
}

save(elife.pm, elife.l, file='elife.RData')

## PUBMED: ("Genome Res"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
genomeresearch.pm = read.csv('./genomeresearch2016-pubmed.csv', as.is=TRUE, header=FALSE)
genomeresearch.pm = genomeresearch.pm[,1:11]
colnames(genomeresearch.pm) = genomeresearch.pm[1,]
genomeresearch.pm = genomeresearch.pm[which(genomeresearch.pm[,1]!="Title"),]
genomeresearch.pm %<>% mutate(journal='Genome Research', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(!is.na(doi))

genomeresearch.l = list()

while(length(genomeresearch.l)<nrow(genomeresearch.pm)){
  ii = length(genomeresearch.l) + 1
  genomeresearch.l = c(genomeresearch.l, list(scrape.genomeresearch(genomeresearch.pm$doi[ii])))
  if(length(genomeresearch.l) %% 20 == 0){
    save(genomeresearch.pm, genomeresearch.l, file='genomeresearch.RData')
    message(length(genomeresearch.l))
  }
}

save(genomeresearch.pm, genomeresearch.l, file='genomeresearch.RData')

## PUBMED: ("PLoS Comput Biol"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
ploscb.pm = read.csv('./ploscb2016-pubmed.csv', as.is=TRUE, header=FALSE)
ploscb.pm = ploscb.pm[,1:11]
colnames(ploscb.pm) = ploscb.pm[1,]
ploscb.pm = ploscb.pm[which(ploscb.pm[,1]!="Title"),]
ploscb.pm %<>% mutate(journal='PLoS Comput Biol', doi=getDOI(Details)) %>% sample_frac(1/5) %>% mutate(ss=5)

ploscb.l = list()

while(length(ploscb.l)<nrow(ploscb.pm)){
  ii = length(ploscb.l) + 1
  ploscb.l = c(ploscb.l, list(scrape.plosg(ploscb.pm$doi[ii])))
  if(length(ploscb.l) %% 50 == 0){
    save(ploscb.pm, ploscb.l, file='ploscb.RData')
    message(length(ploscb.l))
  }
}

save(ploscb.pm, ploscb.l, file='ploscb.RData')

## PUBMED: ("PLoS Biol"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
plosbiol.pm = read.csv('./plosbiol2016-pubmed.csv', as.is=TRUE, header=FALSE)
plosbiol.pm = plosbiol.pm[,1:11]
colnames(plosbiol.pm) = plosbiol.pm[1,]
plosbiol.pm = plosbiol.pm[which(plosbiol.pm[,1]!="Title"),]
plosbiol.pm %<>% mutate(journal='PLoS Biology', doi=getDOI(Details), ss=1)

plosbiol.l = list()

while(length(plosbiol.l)<nrow(plosbiol.pm)){
  ii = length(plosbiol.l) + 1
  plosbiol.l = c(plosbiol.l, list(scrape.plosg(plosbiol.pm$doi[ii])))
  if(length(plosbiol.l) %% 50 == 0){
    save(plosbiol.pm, plosbiol.l, file='plosbiol.RData')
    message(length(plosbiol.l))
  }
}

save(plosbiol.pm, plosbiol.l, file='plosbiol.RData')

## PUBMED: ("PLoS One"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
plosone.pm = read.csv('./plosone2016-pubmed.csv', as.is=TRUE, header=FALSE)
plosone.pm = plosone.pm[,1:11]
colnames(plosone.pm) = plosone.pm[1,]
plosone.pm = plosone.pm[which(plosone.pm[,1]!="Title"),]
plosone.pm %<>% mutate(journal='PLoS ONE', doi=getDOI(Details), ss=1/mean(!is.na(doi)))
plosone.pm %<>% sample_frac(1/110) %>% mutate(ss=110*ss)

plosone.l = list()

while(length(plosone.l)<nrow(plosone.pm)){
  ii = length(plosone.l) + 1
  plosone.l = c(plosone.l, list(scrape.plosg(plosone.pm$doi[ii])))
  if(length(plosone.l) %% 50 == 0){
    save(plosone.pm, plosone.l, file='plosone.RData')
    message(length(plosone.l))
  }
}

save(plosone.pm, plosone.l, file='plosone.RData')

## PUBMED: ("Genome Biol."[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
gbiol.pm = read.csv('./gbiol2016-pubmed.csv', as.is=TRUE, header=FALSE)
gbiol.pm = gbiol.pm[,1:11]
colnames(gbiol.pm) = gbiol.pm[1,]
gbiol.pm = gbiol.pm[which(gbiol.pm[,1]!="Title"),]
gbiol.pm %<>% mutate(journal='Genome Biology', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(!is.na(doi))

gbiol.l = list()

while(length(gbiol.l)<nrow(gbiol.pm)){
  ii = length(gbiol.l) + 1
  gbiol.l = c(gbiol.l, list(scrape.gbiol(gbiol.pm$doi[ii])))
  if(length(gbiol.l) %% 20 == 0){
    save(gbiol.pm, gbiol.l, file='gbiol.RData')
    message(length(gbiol.l))
  }
}

save(gbiol.pm, gbiol.l, file='gbiol.RData')

## PUBMED: ("BMC Genomics"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
bmcg.pm = read.csv('./bmcg2016-pubmed.csv', as.is=TRUE, header=FALSE)
bmcg.pm = bmcg.pm[,1:11]
colnames(bmcg.pm) = bmcg.pm[1,]
bmcg.pm = bmcg.pm[which(bmcg.pm[,1]!="Title"),]
bmcg.pm %<>% mutate(journal='BMC Genomics', doi=getDOI(Details)) %>% filter(grepl("doi", Details)) %>% sample_frac(1/5) %>% mutate(ss=5)

bmcg.l = list()

while(length(bmcg.l)<nrow(bmcg.pm)){
  ii = length(bmcg.l) + 1
  bmcg.l = c(bmcg.l, list(scrape.gbiol(bmcg.pm$doi[ii])))
  if(length(bmcg.l) %% 5 == 0){
    save(bmcg.pm, bmcg.l, file='bmcg.RData')
    message(length(bmcg.l))
  }
}

save(bmcg.pm, bmcg.l, file='bmcg.RData')

## PUBMED: ("PeerJ"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
peerj.pm = read.csv('./peerj2016-pubmed.csv', as.is=TRUE, header=FALSE)
peerj.pm = peerj.pm[,1:11]
colnames(peerj.pm) = peerj.pm[1,]
peerj.pm = peerj.pm[which(peerj.pm[,1]!="Title"),]
peerj.pm %<>% mutate(journal='PeerJ', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(!is.na(doi))
peerj.pm %<>% sample_frac(1/6) %>% mutate(ss=6*ss)

peerj.l = list()

while(length(peerj.l)<nrow(peerj.pm)){
  ii = length(peerj.l) + 1
  peerj.l = c(peerj.l, list(scrape.peerj(peerj.pm$doi[ii])))
  if(length(peerj.l) %% 30 == 0){
    save(peerj.pm, peerj.l, file='peerj.RData')
    message(length(peerj.l))
  }
}

save(peerj.pm, peerj.l, file='peerj.RData')

## PUBMED: ("Genetics"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
genetics.pm = read.csv('./genetics2016-pubmed.csv', as.is=TRUE, header=FALSE)
genetics.pm = genetics.pm[,1:11]
colnames(genetics.pm) = genetics.pm[1,]
genetics.pm = genetics.pm[which(genetics.pm[,1]!="Title"),]
genetics.pm %<>% mutate(journal='Genetics', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(!is.na(doi))
genetics.pm %<>% sample_frac(1/2) %>% mutate(ss=2*ss)

genetics.l = list()

while(length(genetics.l)<nrow(genetics.pm)){
  ii = length(genetics.l) + 1
  genetics.l = c(genetics.l, list(scrape.genetics(genetics.pm$doi[ii])))
  if(length(genetics.l) %% 30 == 0){
    save(genetics.pm, genetics.l, file='genetics.RData')
    message(length(genetics.l))
  }
}

save(genetics.pm, genetics.l, file='genetics.RData')

## PUBMED: ("Nucleic Acids Res"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
nar.pm = read.csv('./nar2016-pubmed.csv', as.is=TRUE, header=FALSE)
nar.pm = nar.pm[,1:11]
colnames(nar.pm) = nar.pm[1,]
nar.pm = nar.pm[which(nar.pm[,1]!="Title"),]
nar.pm %<>% mutate(journal='NAR', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(!is.na(doi)) %>% sample_frac(1/7) %>% mutate(ss=7*ss)

nar.l = list()

while(length(nar.l)<nrow(nar.pm)){
  ii = length(nar.l) + 1
  nar.l = c(nar.l, list(scrape.nar(nar.pm$doi[ii])))
  if(length(nar.l) %% 50 == 0){
    save(nar.pm, nar.l, file='nar.RData')
    message(length(nar.l))
  }
}

save(nar.pm, nar.l, file='nar.RData')

## PUBMED: ("Gigascience"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
giga.pm = read.csv('./giga2016-pubmed.csv', as.is=TRUE, header=FALSE)
giga.pm = giga.pm[,1:11]
colnames(giga.pm) = giga.pm[1,]
giga.pm = giga.pm[which(giga.pm[,1]!="Title"),]
giga.pm %<>% mutate(journal='GigaScience', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(!is.na(doi))

giga.l = list()

while(length(giga.l)<nrow(giga.pm)){
  ii = length(giga.l) + 1
  giga.l = c(giga.l, list(scrape.nar(giga.pm$doi[ii])))
  if(length(giga.l) %% 50 == 0){
    save(giga.pm, giga.l, file='giga.RData')
    message(length(giga.l))
  }
}

save(giga.pm, giga.l, file='giga.RData')

## PUBMED: ("Bioinformatics"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
bioinf.pm = read.csv('./bioinf2016-pubmed.csv', as.is=TRUE, header=FALSE)
bioinf.pm = bioinf.pm[,1:11]
colnames(bioinf.pm) = bioinf.pm[1,]
bioinf.pm = bioinf.pm[which(bioinf.pm[,1]!="Title"),]
bioinf.pm %<>% mutate(journal='Bioinformatics', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(!is.na(doi))
bioinf.pm %<>% sample_frac(1/4) %>% mutate(ss=4*ss)

bioinf.l = list()

while(length(bioinf.l)<nrow(bioinf.pm)){
  ii = length(bioinf.l) + 1
  bioinf.l = c(bioinf.l, list(scrape.nar(bioinf.pm$doi[ii])))
  if(length(bioinf.l) %% 50 == 0){
    save(bioinf.pm, bioinf.l, file='bioinf.RData')
    message(length(bioinf.l))
  }
}

save(bioinf.pm, bioinf.l, file='bioinf.RData')

## PUBMED: ("BMC Biol"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
bmcbiol.pm = read.csv('./bmcbiol2016-pubmed.csv', as.is=TRUE, header=FALSE)
bmcbiol.pm = bmcbiol.pm[,1:11]
colnames(bmcbiol.pm) = bmcbiol.pm[1,]
bmcbiol.pm = bmcbiol.pm[which(bmcbiol.pm[,1]!="Title"),]
bmcbiol.pm %<>% mutate(journal='BMC Biology', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(grepl("doi", Details))

bmcbiol.l = list()

while(length(bmcbiol.l)<nrow(bmcbiol.pm)){
  ii = length(bmcbiol.l) + 1
  bmcbiol.l = c(bmcbiol.l, list(scrape.gbiol(bmcbiol.pm$doi[ii])))
  if(length(bmcbiol.l) %% 50 == 0){
    save(bmcbiol.pm, bmcbiol.l, file='bmcbiol.RData')
    message(length(bmcbiol.l))
  }
}

save(bmcbiol.pm, bmcbiol.l, file='bmcbiol.RData')

## PUBMED: ("BMC Bioinformatics"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
bmcbi.pm = read.csv('./bmcbi2016-pubmed.csv', as.is=TRUE, header=FALSE)
bmcbi.pm = bmcbi.pm[,1:11]
colnames(bmcbi.pm) = bmcbi.pm[1,]
bmcbi.pm = bmcbi.pm[which(bmcbi.pm[,1]!="Title"),]
bmcbi.pm %<>% mutate(journal='BMC Bioinformatics', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(grepl("doi", Details))
bmcbi.pm %<>% sample_frac(1/2.5) %>% mutate(ss=2.5*ss)

bmcbi.l = list()

while(length(bmcbi.l)<nrow(bmcbi.pm)){
  ii = length(bmcbi.l) + 1
  bmcbi.l = c(bmcbi.l, list(scrape.gbiol(bmcbi.pm$doi[ii])))
  if(length(bmcbi.l) %% 50 == 0){
    save(bmcbi.pm, bmcbi.l, file='bmcbi.RData')
    message(length(bmcbi.l))
  }
}

save(bmcbi.pm, bmcbi.l, file='bmcbi.RData')

## Nature
## PUBMED: ("Nature"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
nature.pm = read.csv('./nature2016-pubmed.csv', as.is=TRUE, header=FALSE)
nature.pm = nature.pm[,1:11]
colnames(nature.pm) = nature.pm[1,]
nature.pm = subset(nature.pm, Title!="Title" & !grepl('No abstract', Details))
nature.pm %<>% mutate(journal='Nature', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(grepl("doi", Details))
nature.pm %<>% sample_frac(1/4) %>% mutate(ss=4*ss)

nature.l = list()

while(length(nature.l)<nrow(nature.pm)){
  ii = length(nature.l) + 1
  nature.l = c(nature.l, list(scrape.nature(nature.pm$doi[ii])))
  if(length(nature.l) %% 50 == 0){
    save(nature.pm, nature.l, file='nature.RData')
    message(length(nature.l))
  }
}

save(nature.pm, nature.l, file='nature.RData')

## PUBMED: ("Nat Methods"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
natmeth.pm = read.csv('./natmeth2016-pubmed.csv', as.is=TRUE, header=FALSE)
natmeth.pm = natmeth.pm[,1:11]
colnames(natmeth.pm) = natmeth.pm[1,]
natmeth.pm = subset(natmeth.pm, Title!="Title" & !grepl('No abstract', Details))
natmeth.pm %<>% mutate(journal='Nature Methods', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(grepl("doi", Details))

natmeth.l = list()

while(length(natmeth.l)<nrow(natmeth.pm)){
  ii = length(natmeth.l) + 1
  natmeth.l = c(natmeth.l, list(scrape.nature(natmeth.pm$doi[ii])))
  if(length(natmeth.l) %% 50 == 0){
    save(natmeth.pm, natmeth.l, file='natmeth.RData')
    message(length(natmeth.l))
  }
}

save(natmeth.pm, natmeth.l, file='natmeth.RData')

## PUBMED: ("Nat Commun"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
natcom.pm = read.csv('./natcom2016-pubmed.csv', as.is=TRUE, header=FALSE)
natcom.pm = natcom.pm[,1:11]
colnames(natcom.pm) = natcom.pm[1,]
natcom.pm = subset(natcom.pm, Title!="Title" & !grepl('No abstract', Details))
natcom.pm %<>% mutate(journal='Nature Communications', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(grepl("doi", Details))
natcom.pm %<>% sample_frac(1/17) %>% mutate(ss=17*ss)

natcom.l = list()

while(length(natcom.l)<nrow(natcom.pm)){
  ii = length(natcom.l) + 1
  natcom.l = c(natcom.l, list(scrape.nature(natcom.pm$doi[ii])))
  if(length(natcom.l) %% 50 == 0){
    save(natcom.pm, natcom.l, file='natcom.RData')
    message(length(natcom.l))
  }
}

save(natcom.pm, natcom.l, file='natcom.RData')

## PUBMED: ("Nat Genet"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
natgen.pm = read.csv('./natgen2016-pubmed.csv', as.is=TRUE, header=FALSE)
natgen.pm = natgen.pm[,1:11]
colnames(natgen.pm) = natgen.pm[1,]
natgen.pm = subset(natgen.pm, Title!="Title" & !grepl('No abstract', Details))
natgen.pm %<>% mutate(journal='Nature Genetics', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(grepl("doi", Details))

natgen.l = list()

while(length(natgen.l)<nrow(natgen.pm)){
  ii = length(natgen.l) + 1
  natgen.l = c(natgen.l, list(scrape.nature(natgen.pm$doi[ii])))
  if(length(natgen.l) %% 50 == 0){
    save(natgen.pm, natgen.l, file='natgen.RData')
    message(length(natgen.l))
  }
}

save(natgen.pm, natgen.l, file='natgen.RData')

## PUBMED: ("Nat Biotechnol"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
natbt.pm = read.csv('./natbt2016-pubmed.csv', as.is=TRUE, header=FALSE)
natbt.pm = natbt.pm[,1:11]
colnames(natbt.pm) = natbt.pm[1,]
natbt.pm = subset(natbt.pm, Title!="Title" & !grepl('No abstract', Details))
natbt.pm %<>% mutate(journal='Nature Biotech', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(grepl("doi", Details))

natbt.l = list()

while(length(natbt.l)<nrow(natbt.pm)){
  ii = length(natbt.l) + 1
  natbt.l = c(natbt.l, list(scrape.nature(natbt.pm$doi[ii])))
  if(length(natbt.l) %% 50 == 0){
    save(natbt.pm, natbt.l, file='natbt.RData')
    message(length(natbt.l))
  }
}

save(natbt.pm, natbt.l, file='natbt.RData')

## PUBMED: ("Sci Rep"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
scirep.pm = read.csv('./scirep2016-pubmed.csv', as.is=TRUE, header=FALSE)
scirep.pm = scirep.pm[,1:11]
colnames(scirep.pm) = scirep.pm[1,]
scirep.pm = subset(scirep.pm, Title!="Title" & !grepl('No abstract', Details))
scirep.pm %<>% mutate(journal='Scientific Reports', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(grepl("doi", Details))
scirep.pm %<>% sample_frac(1/100) %>% mutate(ss=100*ss)

scirep.l = list()

while(length(scirep.l)<nrow(scirep.pm)){
  ii = length(scirep.l) + 1
  scirep.l = c(scirep.l, list(scrape.nature(scirep.pm$doi[ii])))
  if(length(scirep.l) %% 50 == 0){
    save(scirep.pm, scirep.l, file='scirep.RData')
    message(length(scirep.l))
  }
}

save(scirep.pm, scirep.l, file='scirep.RData')

## PUBMED: ("Cell"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
cell.pm = read.csv('./cell2016-pubmed.csv', as.is=TRUE, header=FALSE)
cell.pm = cell.pm[,1:11]
colnames(cell.pm) = cell.pm[1,]
cell.pm = subset(cell.pm, Title!="Title" & !grepl('No abstract', Details))
cell.pm %<>% mutate(journal='Cell', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(grepl("doi", Details))
cell.pm %<>% sample_frac(1/3) %>% mutate(ss=3*ss)

cell.l = list()

while(length(cell.l)<nrow(cell.pm)){
  ii = length(cell.l) + 1
  cell.l = c(cell.l, list(scrape.ajhg(cell.pm$doi[ii])))
  if(length(cell.l) %% 50 == 0){
    save(cell.pm, cell.l, file='cell.RData')
    message(length(cell.l))
  }
}

save(cell.pm, cell.l, file='cell.RData')

## PUBMED: ("Cell Rep"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
cellrep.pm = read.csv('./cellrep2016-pubmed.csv', as.is=TRUE, header=FALSE)
cellrep.pm = cellrep.pm[,1:11]
colnames(cellrep.pm) = cellrep.pm[1,]
cellrep.pm = subset(cellrep.pm, Title!="Title" & !grepl('No abstract', Details))
cellrep.pm %<>% mutate(journal='Cell Reports', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(grepl("doi", Details))
cellrep.pm %<>% sample_frac(1/5) %>% mutate(ss=5*ss)

cellrep.l = list()

while(length(cellrep.l)<nrow(cellrep.pm)){
  ii = length(cellrep.l) + 1
  cellrep.l = c(cellrep.l, list(scrape.ajhg(cellrep.pm$doi[ii])))
  if(length(cellrep.l) %% 50 == 0){
    save(cellrep.pm, cellrep.l, file='cellrep.RData')
    message(length(cellrep.l))
  }
}

save(cellrep.pm, cellrep.l, file='cellrep.RData')

## PUBMED: ("Science"[Journal]) AND ("2016"[Date - Publication] : "2016"[Date - Publication])
science.pm = read.csv('./science2016-pubmed.csv', as.is=TRUE, header=FALSE)
science.pm = science.pm[,1:11]
colnames(science.pm) = science.pm[1,]
science.pm = subset(science.pm, Title!="Title" & !grepl('No abstract', Details))
science.pm %<>% mutate(journal='Science', doi=getDOI(Details), ss=1/mean(!is.na(doi))) %>% filter(grepl("doi", Details))
science.pm %<>% sample_frac(1/3) %>% mutate(ss=3*ss)

science.l = list()

while(length(science.l)<nrow(science.pm)){
  ii = length(science.l) + 1
  science.l = c(science.l, list(scrape.science(science.pm$doi[ii])))
  if(length(science.l) %% 50 == 0){
    save(science.pm, science.l, file='science.RData')
    message(length(science.l))
  }
}

save(science.pm, science.l, file='science.RData')

##
## Merge all results and clean up
##

fixDataDf <- function(ll){
  ## When the first element has NAs, it messes up the data.frame binding. This function makes sure it doesn't happen.
  good = unlist(lapply(ll, function(e)!is.na(e$date.r))) & unlist(lapply(ll, function(e)!is.na(e$date.p))) & unlist(lapply(ll, function(e)!is.na(e$date.a)))
  good = which(good)[1]
  pbs = unlist(lapply(ll, function(e)is.na(e$type)))
  message(sum(pbs), 'undefined types')
  c(ll[good], ll[-good])
}

load('ajhgPlosg.RData')
load('elife.RData')
load('genomeresearch.RData')
load('ploscb.RData')
load('plosbiol.RData')
load('plosone.RData')
load('gbiol.RData')
load('bmcg.RData')
load('peerj.RData')
load('genetics.RData')
load('nar.RData')
load('giga.RData')
load('bioinf.RData')
load('bmcbiol.RData')
load('bmcbi.RData')
load('nature.RData')
load('natmeth.RData')
load('natcom.RData')
load('natgen.RData')
load('natbt.RData')
load('scirep.RData')
load('cell.RData')
load('cellrep.RData')
load('science.RData')

## Clean up the list and merge with PubMed informations
pub.df = list(fixDataDf(res.l) %>% do.call(rbind, .) %>% merge(all.pm),
              fixDataDf(elife.l) %>% do.call(rbind, .) %>% merge(elife.pm),
              fixDataDf(genomeresearch.l) %>% do.call(rbind, .) %>% merge(genomeresearch.pm),
              fixDataDf(ploscb.l) %>% do.call(rbind, .) %>% merge(ploscb.pm),
              fixDataDf(plosbiol.l) %>% do.call(rbind, .) %>% merge(plosbiol.pm),
              fixDataDf(plosone.l) %>% do.call(rbind, .) %>% merge(plosone.pm),
              fixDataDf(gbiol.l) %>% do.call(rbind, .) %>% merge(gbiol.pm),
              fixDataDf(peerj.l) %>% do.call(rbind, .) %>% merge(peerj.pm),
              fixDataDf(bmcg.l) %>% do.call(rbind, .) %>% merge(bmcg.pm),
              fixDataDf(bmcbiol.l) %>% do.call(rbind, .) %>% merge(bmcbiol.pm),
              fixDataDf(bioinf.l) %>% do.call(rbind, .) %>% merge(bioinf.pm),
              fixDataDf(bmcbi.l) %>% do.call(rbind, .) %>% merge(bmcbi.pm),
              fixDataDf(giga.l) %>% do.call(rbind, .) %>% merge(giga.pm),
              fixDataDf(genetics.l) %>% do.call(rbind, .) %>% merge(genetics.pm),
              fixDataDf(nature.l) %>% do.call(rbind, .) %>% merge(nature.pm),
              fixDataDf(natmeth.l) %>% do.call(rbind, .) %>% merge(natmeth.pm),
              fixDataDf(natcom.l) %>% do.call(rbind, .) %>% merge(natcom.pm),
              fixDataDf(natgen.l) %>% do.call(rbind, .) %>% merge(natgen.pm),
              fixDataDf(natbt.l) %>% do.call(rbind, .) %>% merge(natbt.pm),
              fixDataDf(scirep.l) %>% do.call(rbind, .) %>% merge(scirep.pm),
              fixDataDf(cell.l) %>% do.call(rbind, .) %>% merge(cell.pm),
              fixDataDf(cellrep.l) %>% do.call(rbind, .) %>% merge(cellrep.pm),
              fixDataDf(science.l) %>% do.call(rbind, .) %>% merge(science.pm),
              fixDataDf(nar.l) %>% do.call(rbind, .) %>% merge(nar.pm))

## Bind all in a master data.frame
pub.df = do.call(rbind, pub.df)

## Adjust ss if too many NA types
pub.df %<>% group_by(journal) %>% mutate(ss=ifelse(sum(is.na(type))>50, ss/mean(!is.na(type)), ss))

## Article types differ across journals and are not always scraped correctly...
## I tried to homogenize.
## To list all types: pub.df %>% group_by(journal) %>% summarize(types=paste(c(journal[1],unique(as.character(type))),collapse=';')) %>% .$types %>% cat(sep='\n')
art.types = c('Article','Research Article','Research article', 'Research', 'PEER-REVIEWED', 'INVESTIGATIONS','Meta-Research Article')
meth.types = c('Methodology article','Methodology Article', 'METHOD', 'Method','Methodolgy article')
letter.types = c('Letter', 'Brief Communication')
report.types = c('Registered Report', 'Report', 'Short Report', 'Technical Report')
opinion.types = c('Perspective', 'Open Letter', 'Comment','Commentary','Correspondence','Formal Comment','Letters to the Editor', 'Technical Comments','Communications','Feature Article')
editorial.types = c('Centennial','Correction','Erratum')
resource.types = c('Database','DATABASE', 'Resource','Software','software','Tools and Resources')
other.types = c('Letters', 'Multiparental Populations', 'ReportMagnetohydrodynamics','Wormbook','YeastBook','Genomic Selection')
review.types = c('Review','Review Article','SURVEY AND SUMMARY')
pub.df %<>%  mutate(typec=ifelse(type%in% art.types, 'Article', as.character(type)),
                    typec=ifelse(typec%in% review.types, 'Review', as.character(typec)),
                    typec=ifelse(typec%in% resource.types, 'Resource', as.character(typec)),
                    typec=ifelse(typec%in% opinion.types, 'Opinion/Correpondence', as.character(typec)),
                    typec=ifelse(typec%in% other.types, 'Other', as.character(typec)),
                    typec=ifelse(typec%in% letter.types, 'Letter', as.character(typec)),
                    typec=ifelse(typec%in% report.types, 'Report', as.character(typec)),
                    typec=ifelse(typec%in% editorial.types, 'Editorial', as.character(typec)),
                    typec=ifelse(typec%in% meth.types, 'Method', as.character(typec)))

## Write TSV file
pub.final = pub.df %>% select(-Resource, -Type, -Identifiers, -Db, -EntrezUID, -Properties) %>% write.table(file='journalPubTime.tsv', row.names=FALSE, sep='\t', quote=FALSE)
