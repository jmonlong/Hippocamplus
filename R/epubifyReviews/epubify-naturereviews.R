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
new.html = page %>% html_node('title') %>% as.character %>% c(new.html, .)
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
new.html = c(new.html, '</head>', header, '\n\n<body>\n')
## Main text
sections = page %>% html_nodes('.article-body') %>% html_nodes('section')
secs.html = sapply(sections, function(sec){
  sec.title = html_attr(sec, 'aria-labelledby')
  sec.div = sec %>% html_nodes('div')
  sec.head = sec.div[1] %>% html_node('h2') %>% html_node('span') %>% html_text
  if(sec.title == 'references'){ # Add h4 with link
    refs = sec.div[2] %>% html_nodes('p')
    ids = refs %>% html_attr('id')
    sec.cont = lapply(which(grepl('ref[0-9]', ids)), function(ii){
      ref.id = gsub('ref','',ids[ii])
      paste0('<h4 id="', ids[ii], '">', ref.id, '</h4>\n', as.character(refs[ii]),'\n')
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
      paste0('<h4 id="', ids[ii], '">', df.name , '</h4>\n', df.content,'\n')
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
  tabs = figs[unlist(lapply(table.links, function(e)length(e)>0))]
  table.links = unlist(table.links)
  if(length(table.links)>0){
    for(ii in 1:length(table.links)){
      tab.ii = read_html(table.links[ii]) %>% html_nodes('table') %>% as.character
      tabcaption = tabs[ii] %>% html_nodes('figcaption') %>% as.character
      sec.content = gsub(tabcaption, paste0(tabcaption, tab.ii), sec.content, fixed=TRUE)
    }
  }
  ## Clean up
  torm = sec %>% html_nodes('.js-hide') %>% as.character
  torm = sec %>% html_nodes('.hide-print') %>% as.character %>% c(torm)
  for(tr in torm){
    sec.content = gsub(tr, '', sec.content, fixed=TRUE)
  }
  ## Fix links
  sec.content = gsub('href="[^"]+#([^"]+)', 'href="#\\1', sec.content)
  ## Fix box
  sec.content = gsub('style="height: [^;]+;"', '', sec.content)
  ## Remove link on image
  figs = sec %>% html_nodes('a') %>% filterAttr('data-track-source','image')
  for(fig in figs){
    fig.replace = fig %>% html_nodes('img') %>% as.character
    sec.content = gsub(as.character(fig), fig.replace, sec.content, fixed=TRUE)
  }
  ## Add h4 for link to figures
  sec.content = gsub('<figcaption><b', '<figcaption><h4', sec.content)
  sec.content = gsub('</b></figcaption>', '</h4></figcaption>', sec.content)
  ## Return section content
  return(paste0('<h2>',sec.head,'</h2>\n', sec.content, '\n\n'))
})
new.html = c(new.html, secs.html, '</body>\n</html>\n')
cat(new.html, file=outfile)

message('Pandoc conversion: HTML -> EPUB')
system2('pandoc', args=c(outfile, '-o', gsub('\\.html$','.epub', outfile)))
message(gsub('\\.html$','.epub', outfile), ' written.')
