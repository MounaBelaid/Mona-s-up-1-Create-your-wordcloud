library(shiny)
library(shinythemes)


  shinyUI(fixedPage(theme=shinytheme("cerulean"),
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"
    ),
                     
    
  headerPanel("Mona's up 1: Create your wordcloud"),
  tags$img(src="image.png",height=70,width=70),
  
  textInput("text", label = h3("Enter text"), value = "",width=1200),
  hr(),
  fluidRow(column(12,verbatimTextOutput("value"))),
  submitButton(text="Run"),
   tabsetPanel( 
     
     tabPanel(
    "Plot",imageOutput("wordcl",width=1,height=1),
     downloadButton("downloadplot","Download Plot")),
     tabPanel(
    "Table", DT::dataTableOutput("table")
  ) ),
  
  tags$footer(h5("This Shiny app is powered by:"),align="right",style="position:relative;"),
  tags$footer(h5("Mouna Belaid"),align="right",style="position:relative;")
  
  
  )
  )
  
   
  
  




