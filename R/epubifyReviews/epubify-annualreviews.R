args = commandArgs(TRUE)

if(length(args)==0){
  stop('input html file missing.')
}

library(rvest)

filterAttr <- function(x, name, value){
  values = html_attr(x, name)
  x[which(values==value)]
}

html.url = args[1]
message('Reading ', html.url)
outfile = gsub('\\.html$','-v2.html', html.url)
outfile = gsub(' ', '_', outfile)
outfile = gsub('\\|', '_', outfile)
outfile = gsub('\\:', '_', outfile)
page = read_html(html.url)

new.html = '<!DOCTYPE html>\n<html class="js svg" lang="en"><head>'
new.html = page %>% html_node('title') %>% as.character %>% c(new.html, ., '</head>\n<body>\n')
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
tabs.title = tabs %>% html_nodes('caption') %>% html_nodes('b') %>% html_text()
tabs.intext = main %>% html_nodes('figure .table')
for(ii in 1:length(tabs.intext)){
  tab.title = tabs.intext[[ii]] %>% html_attr('title')
  tab.old = tabs.intext[[ii]] %>% as.character
  tab.id = gsub('.*id="([^"]+)".*', '\\1', tab.old)
  tab.new = paste0('<figcaption><h4 id="', tab.id,'">', tab.title,'</h4></figcaption>')
  tab.content = tabs[[which(tabs.title==tab.title)]] %>% as.character
  main.content = gsub(tab.old, paste0(tab.new,tab.content), main.content, fixed=TRUE)
}
main.content = gsub('data-id="([^"]+)"([^>]+)href="#"', '\\2href="#\\1"', main.content)
## Fix links
main.content = gsub('href="#"([^>]+)refid="([^"]+)"', 'href="#\\2"\\1', main.content)
main.content = gsub('<li refid="([^"]+)"([^<]+)<div class="number">([0-9]+). </div>','<li \\2<h4 id="\\1">\\3. </h4>',main.content)
## Remove link on image and fix figure links
main.content = gsub('href="#"([^>]+)data-figindex="([^"]+)"', 'href="#\\2"\\1', main.content)
main.content = gsub('<figure><a[^>]+id="([^"]+)">(<img[^>]*>)<figcaption>([^<]+)</figcaption></a></figure>', '<figure>\\2<figcaption><h4 id="\\1">\\3</h4></figcaption></figure>', main.content)
## Full res figures
figs = main %>% html_nodes('figure .figure')
links = page %>% html_nodes('a')
links = links[which(links %>% html_text == 'Download Full-Resolution')]
links = links %>% html_attr('href')
for(ii in 1:length(figs)){
  img = figs[[ii]] %>% html_nodes('img') %>% as.character
  new.img = gsub('src="[^"]*"', paste0('src="', links[ii], '"'), img)
  main.content = gsub(img, new.img, main.content)
}
new.html = c(new.html, main.content, '</body>\n</html>\n')
cat(new.html, file=outfile)

message('Pandoc conversion: HTML -> EPUB')
system2('pandoc', args=c(outfile, '-o', gsub('\\.html$','.epub', outfile)))
message(gsub('\\.html$','.epub', outfile), ' written.')
