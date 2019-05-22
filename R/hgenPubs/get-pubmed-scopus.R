library(rentrez)
library(xml2)
library(dplyr)

## Functions to tranform "NULL" into "NA"
nullToNA = function(x){
  ifelse(is.null(x), NA, x)
}

## Fetches information for one publication
fetchpmid = function(pmid){
  pub.xml <- entrez_fetch(db="pubmed", id=pmid, rettype='xml')
  pub.xml = read_xml(pub.xml)
  pub.l = as_list(pub.xml)
  art.l = pub.l$PubmedArticleSet$PubmedArticle$MedlineCitation$Article
  auths = art.l$AuthorList
  df = lapply(1:length(auths), function(auth.ii){
    ## message(auth.ii)
    auth = auths[[auth.ii]]
    affs.i = which(names(auth) == 'AffiliationInfo')
    affs = unlist(auth[affs.i])
    if(all(names(auth) != 'LastName')){
      affs = paste(unlist(auth), collapse='')
      return(tibble(auth.lastname=NA, auth.firstname=NA, aff=affs, auth.pos=NA))
    }
    tibble(auth.lastname=nullToNA(unlist(auth$LastName)),
           auth.firstname=nullToNA(unlist(auth$ForeName)),
           aff=nullToNA(affs), auth.pos=auth.ii)
  })
  df = do.call(rbind, df)
  df$title = paste(unlist(art.l$ArticleTitle), collapse='')
  df$journal = nullToNA(unlist(art.l$Journal$ISOAbbreviation))
  df$type = paste(unlist(art.l$PublicationTypeList), collapse=';')
  df$nb.auth = length(auths)
  df$pmid = pmid
  ## Date
  if('Year' %in% names(art.l$ArticleDate)){
    dat.l = art.l$ArticleDate
  } else if('Year' %in% names(art.l$Journal$JournalIssue$PubDate)){
    dat.l = art.l$Journal$JournalIssue$PubDate
  } else {
    dat.l = list(Day=NA, Month=NA, Year=NA)
  }
  df$day = nullToNA(unlist(dat.l$Day))
  df$month = nullToNA(unlist(dat.l$Month))
  df$year = unlist(dat.l$Year)  
  df
}

## Search potential publications and init objects
pm.res = entrez_search(db='pubmed', term='(Human Genetics[Affiliation]) AND McGill[Affiliation]', retmax=2000)
res.l = list()
save(pm.res, res.l, file="hgen-pubmed.RData")

## Fetch info for each candidate publication
## Can be stopped and restarted without refetching everything
load("hgen-pubmed.RData")

pb = txtProgressBar(style=3)
while(length(res.l) < length(pm.res$ids)){
  if(length(res.l) %% 50 == 0) setTxtProgressBar(pb,length(res.l)/length(pm.res$ids))
  res.l = c(res.l, list(fetchpmid(pm.res$ids[length(res.l)+1])))
}

close(pb)

save(pm.res, res.l, file="hgen-pubmed.RData")


pm.df = do.call(rbind, res.l)

## Check dates
monthConv = 1:12
names(monthConv) = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
pm.df$month.num = as.numeric(pm.df$month)
pm.df$month = ifelse(is.na(pm.df$month.num), monthConv[pm.df$month],
                     pm.df$month)
pm.df$month = ifelse(is.na(pm.df$month), 1, pm.df$month)
pm.df$day = ifelse(is.na(pm.df$day), 1, pm.df$day)
pm.df$date = as.Date(paste(pm.df$year, pm.df$month, pm.df$day, sep='-'))
pm.df$month.num = NULL

## Catch when only the first author has affiliation
## -> use this affiliations for all authors
fixSingleAff = function(df){
  if(nrow(df)>1 && !is.na(df$aff[1]) && all(is.na(df$aff[-1]))){
    df$aff = df$aff[1]
  }
  df
}
pm.df = pm.df %>% group_by(pmid) %>% do(fixSingleAff(.))

## Where are the NAs?
## apply(pm.df, 2, function(x) sum(is.na(x)))

## Check Consortia like Care 4 Rare
## subset(pm.df, grepl('care', auth.lastname, ignore.case=TRUE))
## subset(pm.df, grepl('care', auth.firstname, ignore.case=TRUE))
## subset(pm.df, grepl('care', aff, ignore.case=TRUE) & is.na(auth.firstname))

## Length of the affiliation, if too long maybe not specific to author
pm.df$aff.nchar = nchar(pm.df$aff)

## HGEN author?
pm.df$hgen = grepl("Human Genetics", pm.df$aff) & grepl("McGill", pm.df$aff)

## Remove affiliation info and transform to one row per author/publication
## Also removes pubs with no HGEN authors
pm.df = pm.df %>% group_by(pmid, auth.firstname, auth.lastname) %>%
  mutate(hgen=any(hgen), aff.nchar=max(aff.nchar)) %>%
  select(-aff) %>% unique %>%
  group_by(pmid) %>% filter(any(hgen, na.rm=TRUE))

## Remove non journal articles
pm.df$type %>% strsplit(split=';') %>% unlist %>% table %>% sort
pm.df = pm.df %>% filter(grepl('Journal Article', type))

## Write tsv file
write.table(pm.df, file="hgen-pubmed.tsv", quote=FALSE, sep='\t', row.names=FALSE)

## Scopus
pm.df %>% filter(hgen) %>% .$pmid %>% unique %>% paste0("PMID(",.,")") %>% paste(collapse=" OR ") %>% cat(file="pmids-hgen-forscopus.txt")
