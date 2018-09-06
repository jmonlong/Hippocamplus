## Arguments
args = commandArgs(TRUE)
html.urls = NA
htmllist = FALSE
title = NA
if(length(args)==0 | args[1]=='-h'){
  message('usage: Rscript epubify-annualreviews.R [-h] -i HTML [-list] [-title TITLE]\n\noptional arguments:\n  -h           show this help message and exit\n  -i HTML      the input URL (or HTML file) or a text file with a list of URLs (or HTML file names)\n  -list        the input is a file with a list\n  -title TITLE   the title of the ebook')
} else {
  ii = 1
  while(ii <=length(args)){
    if(args[ii] == '-i'){
      html.urls = args[ii+1]
      ii = ii + 2
    } else if(args[ii] == '-list'){
      htmllist = TRUE
      ii = ii + 1
    } else if(args[ii] == '-title'){
      title = args[ii+1]
      ii = ii + 2
    } else {
      stop('unrecognized argument. Run with -h for help.')
    }
  }
}
if(is.na(html.urls)){
  stop('input html file missing. Run with -h for help.')
}

library(rvest)
library(knitr)
filterAttr <- function(x, name, value){
  values = html_attr(x, name)
  x[which(values==value)]
}

if(htmllist){
  html.urls = scan(html.urls, 'a')
}

outfile = ifelse(is.na(title), html.urls[1], title)
if(grepl('http', outfile)){
  outfile = gsub('.*/([^/]*)', '\\1', outfile)
}
if(!grepl('.html', outfile)){
  outfile = paste0(outfile, '.html')
}
outfile = gsub('\\.html$','-v2.html', outfile)
outfile = gsub(' ', '_', outfile)
outfile = gsub('\\|', '_', outfile)
outfile = gsub('\\:', '_', outfile)

new.html = '<!DOCTYPE html>\n<html class="js svg" lang="en"><head>'
cpt = 1
for(html.url in html.urls){
  linklab = paste0('l',cpt,'l')
  message('Reading ', html.url)
  page = read_html(html.url)
  html.title = page %>% html_node('title') %>% html_text
  if(cpt == 1){
    if(is.na(title)) {
      title = html.title
    }
    new.html = c(new.html, paste0('<title>', title, '</title></head><body>'))
  }
  new.html = c(new.html, '<h1>', html.title, '</h1>')
  new.html = page %>% html_nodes('article') %>% html_nodes('.article-details') %>% as.character %>% c(new.html, .)
  new.html = page %>% html_nodes('article') %>% html_nodes('.author') %>% as.character %>% c(new.html, .)
  new.html = page %>% html_nodes('article') %>% html_nodes('.abstractSection') %>% as.character %>% c(new.html, '<h2>Abstract</h2>', .)
  divs = page %>% html_nodes('article') %>% html_nodes('div')
  main = divs[divs %>% html_attr('class') %>% grepl('Fulltext', .) %>% which]
  main = main %>% html_children
  main.content = main %>% as.character
  ## Remove stuff
  torm = main %>% html_nodes('.off-links') %>% as.character
  torm = main %>% html_nodes('.article-locations') %>% as.character %>% c(torm)
  torm = main %>% html_nodes('.otherReviewsList') %>% as.character %>% c(torm)
  torm = main %>% html_nodes('.citation-content') %>% as.character %>% c(torm)
  torm = main %>% filterAttr('id', 'citations') %>% as.character %>% c(torm)
  torm = main %>% html_nodes('a') %>% filterAttr('href','#citations') %>% as.character %>% c(torm)
  torm = main %>% html_nodes('.caption') %>% as.character %>% c(torm)
  for(tr in torm){
    main.content = gsub(tr, '', main.content, fixed=TRUE)
  }
  ## Tables
  tabs = page %>% html_nodes('table .table')
  if(length(tabs)>0){
    tabs.title = tabs %>% html_nodes('caption') %>% html_nodes('b') %>% html_text()
    tabs.intext = main %>% html_nodes('figure .table')
    for(ii in 1:length(tabs.intext)){
      tab.title = tabs.intext[[ii]] %>% html_attr('title')
      tab.old = tabs.intext[[ii]] %>% as.character
      tab.id = gsub('.*id="([^"]+)".*', '\\1', tab.old)
      tab.new = paste0('<figcaption><h4 id="', linklab, tab.id,'">', tab.title,'</h4></figcaption>')
      tab.content = tabs[[which(tabs.title==tab.title)]] %>% as.character %>% gsub(' colspan="[^"]*"','',.) %>% read_html %>% html_table(fill=TRUE) %>% .[[1]] %>% kable(format='html') %>% as.character
      main.content = gsub(tab.old, paste0(tab.new,tab.content), main.content, fixed=TRUE)
    }
  }
  main.content = gsub('data-id="([^"]+)"([^>]+)href="#"', paste0('\\2href="#', linklab, '\\1"'), main.content)
  ## Fix links
  main.content = gsub('href="#"([^>]+)refid="([^"]+)"', paste0('href="#', linklab, '\\2"\\1'), main.content)
  main.content = gsub('<li refid="([^"]+)"([^<]+)<div class="number">([0-9]+). *</div>', paste0('<li \\2<h4 id="', linklab, '\\1">\\3. </h4>'),main.content)
  ## Fix glossary links
  h1s = page %>% html_nodes('h1') %>% as.character
  if(any(grepl('acronym', h1s, ignore.case=TRUE))){
    main.content = gsub('<a href="#g[0-9]+"', paste0('<a href="#', linklab,'glossary"'), main.content)
    h1s = grep('acronym', h1s, value=TRUE, ignore.case=TRUE)[1]
    h1s.replace = gsub('<h1', paste0('<h1 id="', linklab, 'glossary"'), h1s)
    main.content = gsub(h1s, h1s.replace, main.content, fixed=TRUE)
  }
  ## Remove link on image and fix figure links
  main.content = gsub('href="#"([^>]+)data-figindex="([^"]+)"', paste0('href="#', linklab, '\\2"\\1'), main.content)
  main.content = gsub('<figure><a[^>]+id="([^"]+)">(<img[^>]*>)<figcaption>([^<]+)</figcaption></a></figure>', paste0('<figure>\\2<figcaption><h4 id="', linklab, '\\1">\\3</h4></figcaption></figure>'), main.content)
  ## Full res figures
  figs = main %>% html_nodes('figure .figure')
  if(length(figs)>0){
    links = page %>% html_nodes('a')
    links = links[which(links %>% html_text == 'Download Full-Resolution')]
    links = links %>% html_attr('href')
    for(ii in 1:length(figs)){
      img = figs[[ii]] %>% html_nodes('img') %>% as.character
      new.img = gsub('src="[^"]*"', paste0('src="', links[ii], '"'), img)
      main.content = gsub(img, new.img, main.content)
    }
  }
  ## Fix relative links
  main.content = gsub(' src="/', ' src="https://www.annualreviews.org/', main.content)
  new.html = c(new.html, main.content)
  cpt = cpt + 1
}

new.html = c(new.html, '</body>\n</html>\n')
cat(new.html, file=outfile)

message('Pandoc conversion: HTML -> EPUB')
system2('pandoc', args=c(outfile, '-o', gsub('\\-v2.html$','.epub', outfile)))
message(gsub('\\-v2.html$','.epub', outfile), ' written.')
