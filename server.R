library(shiny)
library(RColorBrewer) #color pallet
library(tm) #package text mining (tm)
library(wordcloud)
library(DT)
library(rsconnect)

shinyServer(function(input, output) {
  
  #This reactive output contains the text which we enter in the box
  output$value <- renderPrint({ input$text })
  
  #This reactive output contains the text input and cleans it in order to build a dataset
  data<-reactive({
    text<-input$text
    #Removing the stopwords
    text1<-removeWords(text,stopwords(c("en","german","SMART")))
    #Removing the punctuations
    text1<-removePunctuation(text1)
    #Making all text lowercase
    for (i in 1:length(text1)) 
    text1[i]<-tolower(text1[i])
    #Corpus is a set of text vectors
    doc<-Corpus(VectorSource(text1))
    #The term-documents matrix is a table containing the frequency of each word in the text
    tdm<-TermDocumentMatrix(doc)
    #Building a matrix of words 
    m<-as.matrix(tdm)
    v<-sort(rowSums(m),decreasing = TRUE)
    #Building a dataset 
    d<-data.frame(word=names(v),freq=v)
    return(d)
    })  
  
  
  #This reactive output contains the dataset and displays it in a dynamic format 
  output$table<-DT::renderDataTable(
  DT::datatable(data(),class='compact',options=list( initComplete = JS(
    "function(settings, json) {",
    "$(this.api().table().header()).css({'background-color': '#2b8cbe', 'color': '#fff'});",
    "}")     
    ))
  )
  
 #This reactive output draws the wordcloud according to the dataset 
make_cloud<-reactive(
  { png("Wordcloud.png",width=10, height=8,units="in",res=350)
    wc<-wordcloud(words = data()$word, freq = data()$freq,scale=c(8,.8), min.freq = 1,
                 random.order=FALSE,
             rot.per=0.35,colors=brewer.pal(20, "Paired"))
    dev.off()
  filename<-"Wordcloud.png"
    }
  )

output$downloadplot<-downloadHandler(
  filename="Wordcloud.png",
  content=function(file){
    file.copy(make_cloud(),file)
    
  })

output$wordcl<- renderImage({
  list(src=make_cloud(), alt="",height=600)
},
deleteFile = FALSE)


}
)

