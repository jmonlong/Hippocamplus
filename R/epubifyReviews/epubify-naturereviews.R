## Arguments
args = commandArgs(TRUE)
html.urls = NA
htmllist = FALSE
title = NA
if(length(args)==0 | args[1]=='-h'){
  message('usage: Rscript epubify-naturereviews.R [-h] -i HTML [-list] [-title TITLE]\n\noptional arguments:\n  -h           show this help message and exit\n  -i HTML      the input URL (or HTML file) or a text file with a list of URLs (or HTML file names)\n  -list        the input is a file with a list\n  -title TITLE   the title of the ebook')
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
  ## Clean up Header
  header = page %>% html_nodes('header')
  torm = header %>% html_nodes('.js-hide') %>% as.character
  torm = header %>% html_nodes('h1') %>% as.character %>% c(torm)
  torm = header %>% html_nodes('li') %>% html_nodes('a') %>% filterAttr('data-track-source','citation-download') %>% as.character %>% paste0('<li>',.,'</li>') %>% c(torm)
  torm = header %>% html_nodes('.pa10') %>% as.character %>% c(torm)
  torm = header %>% html_nodes('ul') %>% filterAttr('data-component','article-subject-links') %>% as.character %>% paste0('<li>',.,'</li>')  %>% c(torm)
  header = as.character(header)
  for(tr in torm){
    header = gsub(as.character(tr), '', header, fixed=TRUE)
  }
  new.html = c(new.html, '<h1>', html.title, '</h1>')
  new.html = c(new.html, header, '\n')
  ## Main text
  sections = page %>% html_nodes('.article-body') %>% html_nodes('section')
  presection = page %>% html_nodes('.article-body') %>% as.character %>% paste0(' ',.) %>% strsplit('<section') %>% unlist %>% head(1)
  if(nchar(presection)>200){
    presection = read_html(paste0('<section aria-labelledby="main"><div><h2><span>Main</span></h2></div><div>', presection, '</div></section>')) %>% html_nodes('section')
    sections = c(presection, sections)
  }
  secs.html = sapply(sections, function(sec){
    sec.title = html_attr(sec, 'aria-labelledby')
    sec.div = sec %>% html_nodes('div')
    sec.head = sec.div[1] %>% html_node('h2') %>% html_node('span') %>% html_text
    if(is.na(sec.head)){
      sec.head = sec.div[1] %>% html_node('h2') %>% html_text
    }
    if(sec.title %in%  c('Bib1', 'references')){ # Add h4 with link
      refs = sec.div[2] %>% html_nodes('p')
      ids = refs %>% html_attr('id')
      sec.cont = lapply(which(grepl('ref[0-9]', ids)), function(ii){
        ref.id = gsub('ref','',ids[ii])
        paste0('<h4 id="', linklab, ids[ii], '">', ref.id, '</h4>\n', as.character(refs[ii]),'\n')
      })
      return(paste0('<h2>',sec.head,'</h2>\n', paste0(sec.cont, collapse=''), '\n\n'))
    }
    if(sec.title == 'glossary'){ # Change to h4 for links
      dts = sec.div[2] %>% html_nodes('dt')
      ids = dts %>% html_attr('id')
      dds = sec.div[2] %>% html_nodes('dd')
      sec.cont = lapply(1:length(ids), function(ii){
        df.name = dts[ii] %>% html_text
        df.content = dds[ii] %>% html_nodes('p') %>% as.character
        paste0('<h4 id="', linklab, ids[ii], '">', df.name , '</h4>\n', df.content,'\n')
      })
      return(paste0('<h2>',sec.head,'</h2>\n', paste0(sec.cont, collapse=''), '\n\n'))
    }
    if(sec.title == 'related-links'){ # No Related links
      return('')
    }
    sec.content = as.character(sec.div[2])
    ## Download tables. Conversion problem, tables are flattened...
    figs = sec %>% html_nodes('figure')
    table.links = lapply(figs, function(fig){
      fig %>% html_nodes('a') %>% filterAttr('data-track-action','view table') %>% html_attr('href')
    })
    tabs = figs[unlist(lapply(table.links, function(e)length(e)==1))]
    table.links = unlist(table.links[unlist(lapply(table.links, function(e)length(e)==1))])
    tabs = tabs[!duplicated(table.links)]
    table.links = table.links[!duplicated(table.links)]
    if(length(table.links)>0){
      for(ii in 1:length(table.links)){
        if(!grepl('http', table.links[ii])){
          html.root = gsub('(https?://[^/]+)/.*', '\\1', html.url)
          table.links[ii] = paste0(html.root, table.links[ii])
        }
        tab.ii = read_html(table.links[ii]) %>% html_nodes('table') %>% html_table(fill=TRUE) %>% .[[1]] %>% kable(format='html') %>% as.character
        tabcaption = tabs[ii] %>% html_nodes('figcaption') %>% as.character
        sec.content = gsub(tabcaption, paste0(tabcaption, tab.ii)[1], sec.content, fixed=TRUE)
      }
    }
    ## Clean up
    torm = sec %>% html_nodes('.js-hide') %>% as.character
    torm = sec %>% html_nodes('.hide-print') %>% as.character %>% c(torm)
    for(tr in torm){
      sec.content = gsub(tr, '', sec.content, fixed=TRUE)
    }
    ## Fix links
    sec.content = gsub('href="[^"]+#([^"]+)', paste0('href="#',linklab,'\\1'), sec.content)
                                   ## Fix box
                                   sec.content = gsub('style="height: [^;]+;"', '', sec.content)
    ## Remove link on image
    links = sec %>% html_nodes('a')
    linkimgs = sapply(links, function(link) length(html_node(link, 'img'))>0)
    for(fig in links[which(linkimgs)]){
      fig.replace = fig %>% html_nodes('img') %>% as.character
      sec.content = gsub(as.character(fig), fig.replace, sec.content, fixed=TRUE)
    }
    ## Add h4 for link to figures
    sec.content = gsub('<figcaption><b', '<figcaption><h4', sec.content)
    sec.content = gsub('</b></figcaption>', '</h4></figcaption>', sec.content)
    ## Weird bug with image links (sometimes)
    sec.content = gsub(' src="//media.springernature.com', ' src="https://media.springernature.com', sec.content)
    ## Return section content
    return(paste0('<h2>',sec.head,'</h2>\n', sec.content, '\n\n'))
  })
  new.html = c(new.html, secs.html)
  cpt = cpt + 1
}

new.html = c(new.html, '</body>\n</html>\n')
cat(new.html, file=outfile)

message('Pandoc conversion: HTML -> EPUB')
system2('pandoc', args=c(outfile, '-o', gsub('\\-v2.html$','.epub', outfile)))
message(gsub('\\-v2.html$','.epub', outfile), ' written.')
