library(ggplot2)
library(dplyr)
library(knitr)
library(magrittr)
library(igraph)

pm.df = read.table('./hgen-pubmed.tsv', as.is=TRUE, header=TRUE, sep='\t', quote='')
pm.df %<>% filter(year<2019, !grepl('Published Erratum', type),
                  !is.na(auth.firstname), !is.na(auth.lastname)) %>%
  mutate(author=paste(auth.firstname, auth.lastname),
         big=journal %in% c("Nature", "Science", "Cell"),
         date=as.Date(date))

## 'Per-author' data.frame
auth.sum = pm.df %>% filter(hgen) %>% select(author, pmid, big, year) %>%
  unique %>% group_by(author) %>%
  summarize(since=min(year),
            until=max(year),
            pubs=n(),
            pubsPerYear=ifelse(until>since, round(pubs/(until-since),2), NA),
            pubsNatScCell=sum(big))

## Co-authors
co.df = lapply(auth.sum$author, function(auth){
  pmids = pm.df %>% filter(author==auth, aff.nchar<400, hgen) %>% .$pmid %>%
    as.character %>% unique
  pm.df %>% filter(pmid %in% pmids, hgen) %>% group_by(author) %>%
    summarize(nb.pubs=n()) %>% ungroup %>% mutate(coauthor=author, author=auth)
})
co.df = do.call(rbind, co.df)
co.df %<>% filter(author!=coauthor) %>% mutate(hgen=coauthor %in% auth.sum$author)

## Update per-author stats
auth.sum = co.df %>% group_by(author) %>%
  summarize(coauthor=n(), coauthor.hgen=sum(hgen)) %>%
  merge(auth.sum)

## Families
fam.df = pm.df %>% filter(!is.na(auth.pos)) %>% 
  group_by(pmid) %>% filter(auth.pos==1 | auth.pos==max(auth.pos)) %>%
  filter(n()>1, all(hgen)) %>% arrange(auth.pos) %>%
  summarize(student=author[1], mentor=author[2]) %>%
  group_by(student, mentor) %>% summarize(n=n()) %>% filter(n>0)

## Update per-author stats
auth.sum = fam.df %>% mutate(author=mentor) %>%
  group_by(author) %>% summarize(students=n()) %>%
  merge(auth.sum, all.y=TRUE)

### Family tree
## Keep only one mentor (the one with most pubs) per student
fam.df = fam.df %>% arrange(desc(n)) %>% group_by(student) %>%
  do(head(.,1))
## Find components in the graph
fam.g = rbind(fam.df$mentor, fam.df$student) %>% as.character %>% graph
fam.comps = components(fam.g)





## Keep only information needed for the app
pm.small = pm.df %>% dplyr::rename(Citations=cited, Date=date, Journal=journal,
                                   Year=year, Title=title) %>%
  select(Title, Citations, Date, Journal, Year, pmid) %>% unique

auth.sum %<>% dplyr::rename(Author=author, Mentees=students,
                            Coauthors=coauthor, HGEN.Coauthors=coauthor.hgen,
                            Since=since, Until=until, Pubs=pubs,
                            PubsPerYear=pubsPerYear) %>% select(-pubsNatScCell)

co.df %<>% select(author, coauthor, nb.pubs) %>%
  filter(author>coauthor) %>%  arrange(desc(nb.pubs)) %>% 
  dplyr::rename(Author=author, Coauthor=coauthor, Pubs=nb.pubs)

fam.df %<>% select(mentor, student, n)

save(auth.sum, co.df, pm.small, fam.df, fam.comps, file="app/HGenpubs-dataForApp.RData")
