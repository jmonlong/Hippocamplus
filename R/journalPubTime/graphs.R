library(ggplot2)
library(dplyr)
library(magrittr)
library(tidyr)
library(ggrepel)

pub.df = read.table('journalPubTime.tsv', header=TRUE, as.is=TRUE, sep='\t', quote=NULL)

## Keep research articles
art.types = c('Article','Research Article','Research article', 'Research', 'PEER-REVIEWED', 'INVESTIGATIONS','Meta-Research Article')
meth.types = c('Methodology article','Methodology Article', 'METHOD', 'Method','Methodolgy article')
letter.types = c('Letter', 'Brief Communication')
report.types = c('Registered Report', 'Report', 'Short Report', 'Technical Report')
pub.df %<>% filter(type %in% c(art.types, meth.types, letter.types, report.types))

## Compute summary metrics for each journal
pub.s = pub.df %>% group_by(journal) %>% summarize(n.subset=n(), n=sum(ss), ra=median(ra, na.rm=TRUE), rp=median(rp, na.rm=TRUE)) %>% gather(type,days, -n.subset, -n, -journal) %>% mutate(type=factor(type, levels=c('ra','rp'),labels=c('accepted', 'published')), pubs=cut(n, c(0,300,1000,2e4,Inf), labels=c('<300','300-1000','1000-20K','>20K')))

## Graph
ggplot(pub.s, aes(x=reorder(journal,days, min), y=days)) + geom_point(aes(colour=type, size=pubs)) + theme_bw() + geom_hline(yintercept=0) + theme(legend.background = element_rect(colour='black'), legend.position=c(.01,.99), legend.justification = c(0,1), legend.box='horizontal', axis.text.x=element_blank()) + scale_y_continuous(breaks=seq(0,max(pub.s$days),25), limits=c(0,max(pub.s$days))) + xlab('') + ylab('median time (days)') + scale_colour_brewer(palette='Set1', name='received to', direction=-1) + scale_size_manual(name='research articles in 2016', values=c(2,4,6,9)) + guides(colour = guide_legend(direction='horizontal', override.aes = list(size=3)), size=guide_legend(direction='horizontal')) + geom_text(aes(label=journal), data=subset(pub.s, type=='accepted'), angle=90, hjust=1, nudge_y = -8)
