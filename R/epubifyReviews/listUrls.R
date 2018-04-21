library(rvest)
filterAttr <- function(x, name, value){
  values = html_attr(x, name)
  x[which(values==value)]
}

##
## Points of Significance
##
## Page 1
page = read_html('https://www.nature.com/search?title=%22point%20of%20significance%22&order=date_desc')
links = page %>% html_nodes('h2') %>% html_nodes('a') %>% filterAttr('data-track-click','search_result_click') %>% html_attr('href')
## Page 2
page = read_html('https://www.nature.com/search?order=date_desc&title=%22point%20of%20significance%22&page=2')
links = page %>% html_nodes('h2') %>% html_nodes('a') %>% filterAttr('data-track-click','search_result_click') %>% html_attr('href') %>% c(links)
write(links, file='pointsOfSignificance-urls.txt')
## Rscript epubify-naturereviews.R -i pointsOfSignificance-urls.txt -list -title "Points of Significance"


##
## Nature Reviews collections
##
## Genome Editing
page = read_html('https://www.nature.com/collections/rpdbdzpccx/content/reviews')
links = page %>% html_nodes('h3') %>% html_nodes('a') %>% html_attr('href') %>% paste0('https://www.nature.com', .)
write(links, file='NatureReviews-GenomeEditing-urls.txt')
## Rscript epubify-naturereviews.R -i NatureReviews-GenomeEditing-urls.txt -list -title "Genome Editing"

## Computational Tools
page = read_html('https://www.nature.com/collections/vzsqzylnvx/content/content')
links = page %>% html_nodes('h3') %>% html_nodes('a') %>% html_attr('href') %>% paste0('https://www.nature.com', .)
write(links, file='NatureReviews-ComputationalTools-urls.txt')
## Rscript epubify-naturereviews.R -i NatureReviews-ComputationalTools-urls.txt -list -title "Computational Tools"


##
## Annual Reviews
##
## Microbiome & Sequencing keywords
page = read_html('https://www.annualreviews.org/action/doSearch?content=articlesChapters&countTerms=true&target=default&field1=Keyword&text1=Microbiome&field2=Keyword&text2=sequencing')
links = page %>% html_nodes('a.btn.icon-html')  %>% html_attr('href') %>% paste0('https://www.annualreviews.org', .)
write(links, file='AnnualReviews-MicrobiomeSequencing-urls.txt')
## Rscript epubify-annualreviews.R -i AnnualReviews-MicrobiomeSequencing-urls.txt -list -title "Microbiome and Sequencing"
