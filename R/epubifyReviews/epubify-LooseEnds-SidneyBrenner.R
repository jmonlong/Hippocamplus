## EPUB compilation of Current Biology columns "Loose Ends" by Sidney Brenner

library(rvest)
library(magrittr)
library(knitr)

filterAttr <- function(x, name, value){
  values = html_attr(x, name)
  x[which(values==value)]
}

## URLs to each column
page = read_html('https://www.cell.com/current-biology/libraries/loose-ends')
html.urls = page %>% html_nodes('.title')  %>% html_nodes('a') %>% html_attr('href') %>%
  paste0('https://www.cell.com', .)

## Prepare "book" metadata 
book.title = 'Loose Ends by Sidney Brenner'
outfile = book.title %>% paste0('.html') %>% gsub(' ', '_', .) %>% gsub('\\|', '_', .) %>%
  gsub('\\:', '_', .)
new.html = c('<!DOCTYPE html>\n<html class="js svg" lang="en"><head>',
             '<title>Loose Ends</title>',
             '<meta name="author" content="Sidney Brenner">',
             '</head><body>')

## Scrape each URL
h2.filter = c('Article Info', 'Comments') # sections to remove
h2s = c()
for(html.url in html.urls){
  message('Reading ', html.url)
  page = read_html(html.url)
  ## Title
  page.date = page %>% html_nodes('.article-header__date') %>% html_text
  page.title = page %>% html_nodes('.article-header__title') %>% html_text
  page.title = gsub('Loose end: ', '', page.title)
  new.html = c(new.html, '<h1>', page.date, ' - ', page.title, '</h1>')
  ## Text sections
  sections = page %>% html_nodes('section')
  page.h2s = page %>% html_nodes('h2.top') %>% html_text
  h2s = c(h2s, setdiff(page.h2s, h2.filter))
  secs.html = sapply(sections, function(sec){
    sec.title = sec %>% html_nodes('h2.top') %>% html_text
    if(length(sec.title)>0 && !(sec.title %in% h2.filter)){
      return(as.character(sec))
    } else {
      return('')
    }
  })
  new.html = c(new.html, secs.html)
  ## Sometimes section paragraphs not in section (e.g. 2000s columns)
  section.pars = page %>% html_nodes('.section-paragraph')
  section.pars = sapply(section.pars, as.character)
  section.pars.in.secs = page %>% html_nodes('section') %>% html_nodes('.section-paragraph')
  section.pars.in.secs = sapply(section.pars.in.secs, as.character)
  section.pars = setdiff(section.pars, section.pars.in.secs)
  if(length(section.pars) > 0){
    new.html = c(new.html, as.character(section.pars))
  }
}

## Double-check titles of the sections included
unique(h2s) 

## Finish HTML doc and write it
new.html = c(new.html, '</body>\n</html>\n')
cat(new.html, file=outfile)

## Pandoc conversion: HTML -> EPUB
system2('pandoc', args=c(outfile, '-o', gsub('.html$','.epub', outfile)))
