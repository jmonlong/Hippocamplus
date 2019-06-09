library(shiny)
library(visNetwork)
library(rbokeh)

width = 800

shinyUI(fluidPage(

  headerPanel("HGEN in publications"),

  mainPanel(
    tabsetPanel(
      tabPanel('Timeline',
               h3("What was the highlight of the year?"),
               helpText("Pick how many top paper/year to show. Then, hover over the points for some quick info or find out more in the table. The table is searchable and columns can be reordered. "),
               helpText("NOTE: Article published before 1996 are not well tracked by Scopus."),
               numericInput("nbtop", "Top paper per year:", 2, min=1, max=10, step=1),
               hr(),
               rbokehOutput("timeline",height=300),
               hr(),
               dataTableOutput("timelinetable")),

      tabPanel('Summary Table',
               h3("HGEN author information"),
               helpText("The table is searchable and columns can be reordered"),
               dataTableOutput("table")),

      tabPanel('Co-authors Table',
               h3("HGEN authors that published together"),
               helpText("The table is searchable and columns can be reordered"),
               dataTableOutput("cotable")),

      tabPanel('Co-authors Network',
               h3("What does HGEN collaboration look like ?"),
               helpText("Pick how many of the most collaborative authors to display. Hover over nodes/edges, and zoom by scrolling. Also, have fun dragging the nodes around."),
               column(width=3,
                      numericInput("nbcoa", "Top co-authors:", 10, min=10, max=100, step=10)),
               column(width=9, style='border-color:black; border-style:inset',
                      visNetworkOutput("network", height=600))),

      tabPanel('Families',
               h3("Infering families of Mentor-Mentees relationships"),
               helpText("Choose a person to search. Hover over nodes/edges, and zoom by scrolling. Also, have fun dragging the nodes around."),
               column(width=3,
                      textInput("famnw.search", "", 'majewski'),
                      actionButton("updatefamnw", "Search")),
               column(width=9, style='border-color:black; border-style:inset',
                      visNetworkOutput("famnw", height=600))),

      tabPanel('Wordcloud',
               h3("What's in a HGEN title ?"),
               helpText("Pick the period to consider. Also you can choose the minimum frequency, maximum number of words, or scale difference in the word cloud."),
               fluidRow(
                 column(4,
                        numericInput("year.s", "From", 1988, min=1988, max=2016),
                        numericInput("year.e", "Until", 2018, min=1988, max=2018),
                        actionButton("update", "Update"),
                        hr(),
                        sliderInput("freqwd",
                                    "Minimum Frequency:",
                                    min = 1,  max = 50, value = 10),
                        sliderInput("maxwd",
                                    "Maximum Number of Words:",
                                    min = 1,  max = 300,  value = 300),
                        sliderInput("scalewd",
                                    "Scale difference:",
                                    min = 1,  max = 100,  value = 50)
                        ),
                 column(6,
                        plotOutput("wordcloud", height=600)
                        )
               )
               ),
      tabPanel('Trends',
               h3("Search for trends in HGEN titles"),
               helpText("Search for a keyword in HGEN titles and see how they evolved with time."),
               hr(),
               textInput("trend", "Keyword", "sequencing"),
               actionButton("updatetrend", "Search titles"),
               hr(),
               checkboxInput("normtrend", "Correct for total pubs/year"),
               rbokehOutput("trend",height=300)
               )
    )
  )
))
