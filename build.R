library(knitr)

local({
    knitr::render_jekyll()
    a = commandArgs(TRUE)
    d = gsub('^_|[.][a-zA-Z]+$', '', a[1])
    knitr::opts_chunk$set(
        fig.path   = sprintf('figure/%s/', d),
        cache.path = sprintf('cache/%s/', d)
        )
    opts_knit$set(base.url = '{{ site.baseurl }}images/')
    opts_knit$set(base.dir=paste0(getwd(),"/images"))
    ##opts_knit$set(unnamed.chunk.label=gsub(".Rmd","",a[1]))
    opts_chunk$set(comment=NA, fig.width=13)
    knitr::knit(a[1], a[2], quiet = TRUE, encoding = 'UTF-8', envir = .GlobalEnv)
})
