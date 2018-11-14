serve:
	Rscript -e 'blogdown::serve_site()'

build: 
	Rscript -e 'blogdown::hugo_build()'
