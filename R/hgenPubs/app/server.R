library(shiny)
library(dplyr)
library(magrittr)
library(visNetwork)
library(rbokeh)
library(wordcloud)
library(tm)

load("HGenpubs-dataForApp.RData")
pub.year = pm.small %>% group_by(Year) %>% summarize(pubs=n()) %>% ungroup %>%
  mutate(pubs=pubs/mean(pubs))

shinyServer(function(input, output) {

  output$table <- renderDataTable({
    auth.sum %>% arrange(desc(Pubs))
  }, options = list(pageLength = 15))

  output$cotable <- renderDataTable({
    co.df
  }, options = list(pageLength = 15))

  output$network <- renderVisNetwork({
    if(input$nbcoa > 100){
      stop("That's too many authors, your browser might freeze.")
    }
    withProgress({
      setProgress(message = "Creating network...")
      coauths = unique(as.character(rbind(co.df$Author, co.df$Coauthor)))
      coauths = head(coauths, input$nbcoa-1)
      cut.ii = min(which(!(co.df$Author %in% coauths)), which(!(co.df$Coauthor %in% coauths)))
      bro.df = co.df[1:cut.ii,]
      nodes = data.frame(id=c(bro.df$Author, bro.df$Coauthor)) %>% unique %>%
        mutate(title=id, label=id)
      edges = bro.df %>% mutate(from=Author, to=Coauthor, value=Pubs, title=Pubs) %>%
        select(from, to, value, title) %>% as.data.frame
      visNetwork(nodes, edges) %>% visOptions(highlightNearest = FALSE)
    })
  })

  famnw <- reactive({
    input$updatefamnw
    isolate({
      person = grep(input$famnw.search, names(fam.comps$membership), value=TRUE, ignore.case=TRUE)
      if(length(person)==0){
        stop("Person not found.")
      }
      withProgress({
        setProgress(message = "Creating network...")
        search.comp = fam.comps$membership[person]
        all.comp = names(fam.comps$membership)[which(fam.comps$membership %in% search.comp)]
        fam.nw = fam.df %>% filter(mentor %in% all.comp)
        nodes = data.frame(id=c(fam.nw$mentor, fam.nw$student)) %>% unique %>%
          mutate(title=id, label=id)
        edges = fam.nw %>%
          mutate(from=mentor, to=student, value=n, title=n, arrows='to') %>%
          select(from, to, value, title, arrows) %>% as.data.frame
        return(list(edges=edges, nodes=nodes))
      })
    })
  })

  output$famnw <- renderVisNetwork({
    nw = famnw()
    visNetwork(nw$nodes, nw$edges) %>% visOptions(highlightNearest = FALSE)
  })

  output$timeline <- renderRbokeh({
    cit.n = pm.small %>% group_by(Year) %>% arrange(desc(Citations)) %>%
      mutate(Year.rank=factor(1:n())) %>% do(head(.,input$nbtop))
    figure(legend_location=NULL, width=1000, height=300,tools="reset") %>%
      ly_points(Date, Citations, data = cit.n, color=Year.rank,
                hover=list(Title, Citations, Journal, Year)) %>%
      tool_pan %>% tool_wheel_zoom %>% y_axis(log = TRUE) %>%
      ly_abline(v = as.Date(paste0(min(cit.n$Year):max(cit.n$Year),"-01-01")), alpha=.3)
  })

  output$timelinetable <- renderDataTable({
    pm.small %>% group_by(Year) %>% arrange(desc(Citations)) %>%
      mutate(Year.rank=factor(1:n())) %>% do(head(.,input$nbtop)) %>% ungroup %>%
        arrange(desc(Citations)) %>%
        mutate(URL=paste0("<a href=\"http://www.ncbi.nlm.nih.gov/pubmed/",pmid,"\">PubMed</a>")) %>%
        select(Citations, Year, Title, URL)
  }, options = list(pageLength = 15), escape=FALSE)

  wordcloud_rep = repeatable(wordcloud)

  titles <- reactive({
    input$update
    isolate({
      withProgress({
        setProgress(message = "Processing titles...")
        titleW = pm.small %>% filter(Year<=input$year.e, Year>=input$year.s) %>%
          .$Title %>% VectorSource %>% Corpus %>%
          tm_map(content_transformer(tolower)) %>% tm_map(removePunctuation) %>%
          tm_map(removeNumbers) %>%
          tm_map(removeWords, c(stopwords("SMART"), "the", "and"))
        titleW.dtm = TermDocumentMatrix(titleW, control = list(minWordLength = 1))
        titleW.dtm %>% as.matrix %>% rowSums %>% sort(decreasing = TRUE)
      })
    })
  })

  output$wordcloud <- renderPlot({
    titleW.f = titles()
    wordcloud_rep(names(titleW.f), titleW.f, scale=c(4, 4/input$scalewd),
                  min.freq = input$freqwd, max.words=input$maxwd,
                  colors=brewer.pal(8, "Dark2"))
  })

  
  titletrend <- reactive({
    input$updatetrend
    isolate({
      withProgress({
        setProgress(message = "Processing titles...")
        if(!any(grepl(input$trend, pm.small$Title, ignore.case=TRUE))){
          stop("No titles with keyword: ", input$trend)
        }
        pm.small %>% filter(grepl(input$trend, Title, ignore.case=TRUE)) %>%
          arrange(Title) %>% merge(pub.year)
      })
    })
  })

  output$trend <- renderRbokeh({
    tt = titletrend()
    tt %<>% group_by(Year) %>%
      mutate(publication=seq(1, n()/ifelse(input$normtrend, pubs,1), length.out=n()))
    figure(legend_location=NULL, width=1000, height=300,tools=NULL) %>%
      ly_points(Year, publication, data = tt, hover=list(Title, Year))
  })

})
