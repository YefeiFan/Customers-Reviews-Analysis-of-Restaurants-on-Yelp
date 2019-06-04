library(shiny)
library(shinydashboard)
library(shinythemes)
library(leaflet)
library(RODBC)
library(stringr)
library(DT)
library(tidytext)
library(dplyr)
library(tidyr)
library(widyr)
library(igraph)
library(tm)
library(ggraph)
library(ggplot2)
library(sentimentr)
library(geosphere)
library(plotly)
library(shinydashboardPlus)


ui<-dashboardPage(
  dashboardHeaderPlus(title = tags$a(href='http://www.testudo.umd.edu/',
                                     tags$img(src='https://i.ibb.co/WsvJBTF/Picture1.png',height = 40, width = 180)),
                      tags$li(class = "dropdown", tags$a(HTML(paste(uiOutput("Refresh1")))))
                      ,left_menu = tagList(
                        
                        dropdownBlock(
                          id = "mydropdown",
                          title = "Your Customer Acquisition Application")
                        
                        
                        #                    dropdownBlock(
                        #                      id = "mydropdown",
                        #                      title = "Search for Customer by Name",
                        #                      textInput(inputId = "customer_name",
                        #                                label = "Search for Customer by Name",
                        #                                value = "Jack Astor's Bar & Grill")
                        #                    ),
                        #                    dropdownBlock(
                        #                      id = "mydropdown2",
                        #                      title = "Search for Customer by Category",
                        #                      selectInput(inputId = "customer_catname",
                        #                                  label = "Search for Customer by Category", 
                        #                                  choices = c("Chinese","Mexican","American","Italian"),
                        #                                  selected = "American")
                        #                      )
                      )
  ),
  
  dashboardSidebar(
    #    sidebarUserPanel(name = "Good Morning!"),
    sidebarMenu(id = "tabs",
                menuItem("Good Morning!"),
                menuItem("Select Customer", tabName = "customer_selection",icon = icon(name = 'fa-list-ul',class = 'fas fa-list-ul',lib = "font-awesome")),
                menuItem("Customer Analysis", tabName = "customer_analysis",icon = icon(name = 'fa-atom',class = 'fas fa-atom',lib = "font-awesome")),
                menuItem("Leading Competitors",tabName = "competitor_location",icon = icon(name = 'fa-atlas',class = 'fas fa-atlas',lib = "font-awesome")),
                menuItem("Competitor Word Network", tabName = "competitors_wordnetwork",icon = icon(name = 'fa-file-image',class = 'far fa-file-image',lib = "font-awesome")),
                menuItem("Competitor Sentiment Score",tabName = "competitor_sentiment_score",icon = icon(name = 'fa-chart-area',class = 'fas fa-chart-area',lib = "font-awesome")),
                menuItem("Insert Business Data",tabName = "insert_data",icon = icon(name = 'fa-plus-square',class = 'far fa-plus-square',lib = "font-awesome")),
                menuItem("Delete Business Data",tabName = "delete_data",icon = icon(name = 'fa-trash-alt',class = 'fas fa-trash-alt',lib = "font-awesome"))
    )),
  
  dashboardBody(
    tabItems(
      
      tabItem(tabName = "customer_selection",
              h3("Customer Identifier"),
              fluidRow(
                boxPlus(textInput(inputId = "customer_name",label = "Search for Customer by Name",value = "Jack Astor's Bar & Grill"),width = 6,collapsible = TRUE,background = 'blue'),
                boxPlus(selectInput(inputId = "customer_catname",label = "Search for Customer by Category", choices = c("Chinese","Mexican","American","Italian"),selected = "American"),width = 6,collapsible = TRUE,background = 'blue'),
                boxPlus(title = "List of Customer in the Database",dataTableOutput(outputId = "customer_list"), width = 12, solidHeader = TRUE)
              )
      ),
      
      tabItem(tabName = "customer_analysis",
              h3("Insights on Customer"),
              fluidRow(
                boxPlus(textInput(inputId = "customer_businessId2",label = "Search for Customer by Id",value = "0EeciPtb--c42OUE7Nm9mg"),width = 6,collapsible = TRUE,background = 'blue'),
                box(
                  title = "Analysis of Client's Reviews", width = 12, solidHeader = TRUE,
                  plotOutput("Word_Network_Positive")
                ),
                box(
                  title = "Summary of Sentences in Client's Reviews", width = 6, solidHeader = TRUE,
                  plotlyOutput("Review_Sentiments")
                ),
                boxPlus(
                  title = "Summary of User Reviews for the Client", width = 6, solidHeader = TRUE,
                  plotlyOutput("Review_Sentiments2")
                ))
      ),
      
      tabItem(tabName = "competitor_location",
              h3("Location of High Rated Competitors"),
              
              fluidRow(
                boxPlus(numericInput(inputId = "Distance_Filter",label = "Select Distance Filter for Competitor",value = 4,min = 0.5,max = 50.0,step = 0.5),width = 5,collapsible = TRUE,background = 'blue'),
                boxPlus(sliderInput(inputId = "Number_of_Customer",label = "Select Number of Top Rated Competitor for Comparison",min = 5,max = 20,value = 5),width = 7,collapsible = TRUE,background = 'blue'),
                box(title = "Location of Highest Rated Competitors", width = 12, solidHeader = TRUE,
                    leafletOutput(outputId = "Leaflet_Customers"))
              )
      ),
      
      
      tabItem(tabName = "competitors_wordnetwork",
              h3("Word Network of Competitors"),
              fluidRow(
                box(title = "Analysis of Reviews for All Restuarant in the Category", width = 12, solidHeader = TRUE,
                    plotOutput(outputId = "Word_Network_Positive_competitors"))
              )
      ),
      
      tabItem(tabName = "competitor_sentiment_score",
              h3("Sentiment Analysis of Competitors Reviews"),
              fluidRow(
                box(title = "Analysis of Reviews for All Restuarant in the Category", width = 12, solidHeader = TRUE,
                    plotOutput(outputId = "Review_Sentiments_competitors"))
              )
      ),
      
      tabItem(tabName = "insert_data",
              h3("Insert Data of a New Customer"),
              fluidRow(
                boxPlus(textInput(inputId = "businessId2",label = "Choose an aplhanumeric businessID",value = "PfOCPjBrlQAnz__NXj9h_w222"),width = 3,collapsible = TRUE,background = 'light-blue'),
                boxPlus(textInput(inputId = "businessName2",label = "Choose an customer Name",value = "Hello Kitchen"),width = 3,collapsible = TRUE,background = 'light-blue'),
                boxPlus(textInput(inputId = "neighborhood2",label = "Choose an customer Neighborhood",value = "Near Home Depot"),width = 3,collapsible = TRUE,background = 'light-blue'), 
                boxPlus(numericInput(inputId = "isOpen2",label = "Is the resturant Open", value = 1,min = 0,max = 1,step = 1),width = 3,collapsible = TRUE,background = 'light-blue'),
                boxPlus(actionButton("insert_data23","Click Here to Insert Data"), width = 3, solidHeader = TRUE,background = 'light-blue'),
                boxPlus(title = "Status", textOutput(outputId = "insert_data124"),width = 12,background = 'light-blue'),
                boxPlus(actionButton("insert_data24","Click Here to Check Status"), width = 3, solidHeader = TRUE,background = 'light-blue')
              )
      ),
      
      tabItem(tabName = "delete_data",
              h3("Delete Data of a Customer"),
              fluidRow(
                boxPlus(textInput(inputId = "businessId3",label = "Choose an aplhanumeric businessID",value = "PfOCPjBrlQAnz__NXj9h_w222"),width = 3,collapsible = TRUE,background = 'light-blue'),
                boxPlus(actionButton("delete_data233","Click Here to Delete Data"), width = 3, solidHeader = TRUE,background = 'light-blue'),
                boxPlus(title = "Status", textOutput(outputId = "delete_data1243"),width = 12,background = 'light-blue')
#                boxPlus(actionButton("delete_data243","Click Here to Check Status"), width = 3, solidHeader = TRUE,background = 'light-blue')
              )
      )
    )
  )
)






server<-function(input,output){
  
  output$Refresh1 <- renderText({
    paste("Today's Date: ",toString(format(Sys.Date(), format = "%A  %d %b %Y")),sep = "")
  })
  
  
  output$customer_list<-renderDataTable({
    dbhandle1 <- odbcDriverConnect('Driver=FreeTDS;TDS_Version=7.2;server=thaque2050.cgz0la30vrak.us-east-2.rds.amazonaws.com;port=1433;database=Group_Project_BUDT758Y;uid=thaque786;pwd=tariq214H')
    sqlcot1<-'SELECT * FROM Brief_BusinessDetails_V'
    res <- sqlQuery(dbhandle1, sqlcot1)
    odbcClose(dbhandle1)
    new<-res%>%filter(str_detect(businessName,regex(input$customer_name,ignore_case = TRUE)))
    new<-new%>%filter(categoryName==input$customer_catname)
    datatable(new)
  })
  
  #Customer Analysis
  
  output$Word_Network_Positive<-renderPlot({
    
    dbhandle2 <- odbcDriverConnect('Driver=FreeTDS;TDS_Version=7.2;server=thaque2050.cgz0la30vrak.us-east-2.rds.amazonaws.com;port=1433;database=Group_Project_BUDT758Y;uid=thaque786;pwd=tariq214H')
    sqlcot2<-'SELECT * FROM Business_Reviews_Details_V'
    rtext <- sqlQuery(dbhandle2, sqlcot2)%>%filter(str_detect(businessId,input$customer_businessId2))
    odbcClose(dbhandle2)
    
    #get business name of client
    business_name_27<-rtext$businessName[1]
    
    rtext_only<-rtext$reviewText
    corpus<-Corpus(VectorSource(rtext_only))
    corpus <- tm_map(x = corpus,removeNumbers)
    corpus <- tm_map(corpus, content_transformer(tolower)) 
    corpus <- tm_map(corpus, removePunctuation)
    corpus <- tm_map(corpus, stripWhitespace)
    corpus <- tm_map(corpus, stemDocument)
    
    myStopwords <- c(stopwords(kind = 'en'),"is","the","are","they")
    corpus <- tm_map(corpus, removeWords, myStopwords) 
    
    
    df<-data.frame(text = sapply(corpus, as.character), stringsAsFactors = FALSE)
    
    
    #Identify paired words
    review_words_paired <- df%>%select(text) %>%
      unnest_tokens(paired_words, text, token = "ngrams", n = 2)
    
    review_words_paired %>% count(paired_words, sort = TRUE)
    
    #put words in separate columns
    review_words_separated <- review_words_paired %>%
      separate(paired_words, c("word1", "word2"), sep = " ")
    
    # new bigram counts:
    review_words_counts <- review_words_separated %>% count(word1, word2, sort = TRUE)
    
    review_words_counts_5<-review_words_counts%>%filter(n >= 5)
    nrow_123<-nrow(review_words_counts_5)
    if(nrow_123<1){
      x=as.data.frame(rnorm(100))
      colnames(x)<-"rnorm"
      myplots<-x%>%ggplot+geom_histogram(aes(rnorm),bins = 10)+ggtitle(label = "Not enough reviews to build word network")
      
    }
    else{
      
      #Plot connected words
      myplots<-review_words_counts %>%
        filter(n >= 5) %>%
        graph_from_data_frame()%>%
        ggraph(layout = "fr") +
        geom_edge_link(aes(edge_alpha = n, edge_width = n),label_colour = "blue2") +
        geom_node_point(color = "red", size = 3) +
        geom_node_text(aes(label = name), vjust = 1.8, size = 3) +
        labs(title = paste("Word Network: ",business_name_27),
             subtitle = "Reviews from Users",x = "", y = "")
      
      myplots
    }
    myplots
    
  })
  
  output$Review_Sentiments<-renderPlotly({
    
    dbhandle3 <- odbcDriverConnect('Driver=FreeTDS;TDS_Version=7.2;server=thaque2050.cgz0la30vrak.us-east-2.rds.amazonaws.com;port=1433;database=Group_Project_BUDT758Y;uid=thaque786;pwd=tariq214H')
    sqlcot3<-'SELECT * FROM Business_Reviews_Details_V'
    
    bId<-input$customer_businessId2
    #bId<-"VPoI6WUJmKZrP3HObqBL9A"
    
    rtext <- sqlQuery(dbhandle3, sqlcot3)%>%filter(str_detect(businessId,bId))
    odbcClose(dbhandle3)
    
    rtext_only<-as.character(rtext$reviewText)
    
    sentiment_score<-sentiment(rtext_only)
    
    k<-0
    for (k in 1:nrow(sentiment_score)){
      if(sentiment_score$sentiment[k]>.15){
        sentiment_score$sentiment_final[k]="Positive"
      }
      else if (sentiment_score$sentiment[k]<0.01){
        sentiment_score$sentiment_final[k]="Negative"
      }
      else{
        sentiment_score$sentiment_final[k]="Neutral"
      }
    }
    
    number_of_positive<-nrow(sentiment_score[which(sentiment_score$sentiment_final=="Positive"),])
    number_of_negative<-nrow(sentiment_score[which(sentiment_score$sentiment_final=="Negative"),])
    total_value<-number_of_positive+number_of_negative
    
    a<-c("Positive","Negative")
    #b<-c(number_of_positive,number_of_negative)
    f<-round((number_of_positive/total_value)*100,digits = 2)
    g<-round((number_of_negative/total_value)*100,digits = 2)
    e<-c(f,g)
    d<-data.frame(cbind(a,e))
    colnames(d)<-c("Sentiment_Type","Percent_Share")
    
    
    p <- plot_ly(d, labels = ~Sentiment_Type, values = ~Percent_Share, type = 'pie',textposition='outside',
                 marker = list(colors=c("red", "blue"))) %>% add_pie(hole=0.6)%>%
      layout(title = 'Percent of + / - Sentences in Reviews',
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    p
    
    
  })
  
  
  output$Review_Sentiments2<-renderPlotly({
    
    dbhandle3 <- odbcDriverConnect('Driver=FreeTDS;TDS_Version=7.2;server=thaque2050.cgz0la30vrak.us-east-2.rds.amazonaws.com;port=1433;database=Group_Project_BUDT758Y;uid=thaque786;pwd=tariq214H')
    sqlcot3<-'SELECT * FROM Business_Reviews_Details_V'
    
    bId<-input$customer_businessId2
    #bId<-"VPoI6WUJmKZrP3HObqBL9A"
    
    rtext <- sqlQuery(dbhandle3, sqlcot3)%>%filter(str_detect(businessId,bId))
    odbcClose(dbhandle3)
    
    number_of_positive<-nrow(rtext[which(rtext$reviewRating>2.9),])
    number_of_negative<-nrow(rtext[which(rtext$reviewRating<2.01),])
    total_value<-number_of_positive+number_of_negative
    
    a<-c("Positive","Negative")
    #b<-c(number_of_positive,number_of_negative)
    f<-round((number_of_positive/total_value)*100,digits = 2)
    g<-round((number_of_negative/total_value)*100,digits = 2)
    e<-c(f,g)
    d<-data.frame(cbind(a,e))
    colnames(d)<-c("Sentiment_Type","Percent_Share")
    
    
    p <- plot_ly(d, labels = ~Sentiment_Type, values = ~Percent_Share, type = 'pie',textposition='outside',
                 marker = list(colors=c("red", "blue"))) %>% add_pie(hole=0.6)%>%
      layout(title = 'Percent of + / - Reviews',
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    p
    
  })
  
  
  
  
  #Competitor Analysis
  
  output$Leaflet_Customers<-renderLeaflet({
    
    dbhandle4 <- odbcDriverConnect('Driver=FreeTDS;TDS_Version=7.2;server=thaque2050.cgz0la30vrak.us-east-2.rds.amazonaws.com;port=1433;database=Group_Project_BUDT758Y;uid=thaque786;pwd=tariq214H')
    a<-'SELECT * FROM Competitor_Business_Details_V'
    rtext4 <- sqlQuery(dbhandle4, a)
    odbcClose(dbhandle4)
    
    bId<-input$customer_businessId2
    #bId<-"VPoI6WUJmKZrP3HObqBL9A"
    
    bcompetitor<-input$Number_of_Customer
    #bcompetitor<-10
    
    bdistance<-input$Distance_Filter*1000
    #bdistance<-5000
    
    
    along1<-rtext4[which(rtext4$businessId==bId),]
    along2<-as.numeric(as.character(along1[1,7]))
    alat2<-as.numeric(as.character(along1[1,8]))
    
    
    for (i in 1:nrow(rtext4)){
      rtext4$distance[i]=abs(distm (c(along2, alat2), c(as.numeric(as.character(rtext4[i,7])), 
                                                        as.numeric(as.character(rtext4[i,8]))), fun = distHaversine))
    }
    
    client_data<-rtext4%>%filter(businessId==bId)
    
    rtext5<-rtext4%>%filter(businessId!=bId)
    rtext6<-rtext5%>%filter(distance<bdistance)
    
    
    category_127<-as.character(client_data$categoryName[1])
    rtext6<-rtext6%>%filter(str_detect(categoryName,category_127))
    
    temprat<-rtext6%>%group_by(businessId,businessName)%>%summarise(rating=mean(reviewRating),longitude1=mean(longitude),latitude1=mean(latitude))
    if(nrow(temprat)<bcompetitor){
      lkt<-nrow(temprat)
      min_avg_rating<-temprat$rating[lkt]
      temprat2<-temprat
    }
    
    else{
      temprat2<-temprat[order(temprat$rating,decreasing=TRUE),][1:bcompetitor,]
      min_avg_rating<-temprat2$rating[bcompetitor]
    }
    
    new_client<-client_data[1,c(1,2,5,7,8)] 
    colnames(temprat2)<-c("businessId","businessName","Average_Rating","longitude","latitude")
    temprat2<-as.data.frame(temprat2)
    
    rtext8<-rbind(temprat2,new_client)
    
    leafplot<-rtext8%>%leaflet()%>%addTiles()%>%addMarkers(lng = ~longitude,lat = ~latitude,label = ~businessName)
    leafplot
    
  })
  
  
  
  
  
  
  output$Word_Network_Positive_competitors<-renderPlot({
    
    dbhandle3 <- odbcDriverConnect('Driver=FreeTDS;TDS_Version=7.2;server=thaque2050.cgz0la30vrak.us-east-2.rds.amazonaws.com;port=1433;database=Group_Project_BUDT758Y;uid=thaque786;pwd=tariq214H')
    a<-'SELECT * FROM Business_Competitor_Word_V'
    rtext2 <- sqlQuery(dbhandle3, a)
    odbcClose(dbhandle3)
    
    #   CHECK HERE
    tempto<-rtext2[which(rtext2$businessId==input$customer_businessId2),]
    category_127<-as.character(tempto$categoryName[1])
    rtext2<-rtext2%>%filter(str_detect(categoryName,category_127))
    
    if(nrow(rtext2)>2000){
      rtext2<-rtext2[1:2000,]
    }
    
    else{
      rtext2<-rtext2
    }
    
    rtext_only2<-rtext2$reviewText
    
    corpus<-Corpus(VectorSource(rtext_only2))
    corpus <- tm_map(x = corpus,removeNumbers)
    corpus <- tm_map(corpus, content_transformer(tolower)) 
    corpus <- tm_map(corpus, removePunctuation)
    corpus <- tm_map(corpus, stripWhitespace)
    corpus <- tm_map(corpus, stemDocument)
    
    myStopwords <- c(stopwords(kind = 'en'),"is","the","are","they")
    corpus <- tm_map(corpus, removeWords, myStopwords) 
    
    
    df<-data.frame(text = sapply(corpus, as.character), stringsAsFactors = FALSE)
    
    
    #Identify paired words
    review_words_paired <- df%>%select(text) %>%
      unnest_tokens(paired_words, text, token = "ngrams", n = 2)
    
    review_words_paired %>% count(paired_words, sort = TRUE)
    
    #put words in separate columns
    review_words_separated <- review_words_paired %>%
      separate(paired_words, c("word1", "word2"), sep = " ")
    
    # new bigram counts:
    review_words_counts <- review_words_separated %>% count(word1, word2, sort = TRUE)
    
    review_words_counts_5<-review_words_counts%>%filter(n >= 20)
    nrow_123<-nrow(review_words_counts_5)
    
    if(nrow_123<1){
      x=as.data.frame(rnorm(100))
      colnames(x)<-"rnorm"
      myplots<-x%>%ggplot+geom_histogram(aes(rnorm),bins = 10)+ggtitle(label = "Not enough reviews to vuild word network")
      myplots
    }
    else{
      
      #Plot connected words
      myplots<-review_words_counts %>%
        filter(n >= 20) %>%
        graph_from_data_frame()%>%
        ggraph(layout = "fr") +
        geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
        geom_node_point(color = "red", size = 3) +
        geom_node_text(aes(label = name), vjust = 1.8, size = 3) +
        labs(title = paste("Word Network: ",category_127),
             subtitle = "Reviews from Users",
             x = "", y = "")
      myplots
    }
    myplots
  })
  
  output$Review_Sentiments_competitors<-renderPlot({
    
    dbhandle4 <- odbcDriverConnect('Driver=FreeTDS;TDS_Version=7.2;server=thaque2050.cgz0la30vrak.us-east-2.rds.amazonaws.com;port=1433;database=Group_Project_BUDT758Y;uid=thaque786;pwd=tariq214H')
    a<-'SELECT * FROM Competitor_Business_Details_V'
    rtext4 <- sqlQuery(dbhandle4, a)
    odbcClose(dbhandle4)
    
    bId<-input$customer_businessId2
    #bId<-"VPoI6WUJmKZrP3HObqBL9A"
    
    bcompetitor<-input$Number_of_Customer+1
    #bcompetitor<-10+1
    
    bdistance<-input$Distance_Filter*1000
    #bdistance<-5000
    
    
    along1<-rtext4[which(rtext4$businessId==bId),]
    along2<-as.numeric(as.character(along1[1,7]))
    alat2<-as.numeric(as.character(along1[1,8]))
    
    
    for (i in 1:nrow(rtext4)){
      rtext4$distance[i]=abs(distm (c(along2, alat2), c(as.numeric(as.character(rtext4[i,7])), 
                                                        as.numeric(as.character(rtext4[i,8]))), fun = distHaversine))
    }
    
    client_data<-rtext4%>%filter(businessId==bId)
    
    rtext5<-rtext4%>%filter(businessId!=bId)
    rtext6<-rtext5%>%filter(distance<bdistance)
    
    
    category_127<-as.character(client_data$categoryName[1])
    rtext6<-rtext6%>%filter(str_detect(categoryName,category_127))
    
    temprat<-rtext6%>%group_by(businessId)%>%summarise(rating=mean(reviewRating))
    if(nrow(temprat)<bcompetitor){
      lkt<-nrow(temprat)
      min_avg_rating<-temprat$rating[lkt]
    }
    
    else{
      temprat2<-temprat[order(temprat$rating,decreasing=TRUE),][1:bcompetitor,]
      min_avg_rating<-temprat2$rating[bcompetitor]
    }
    
    rtext7<-rtext6%>%filter(Average_Rating>min_avg_rating)
    
    rtext8<-data.frame(rbind(rtext7,client_data))
    
    temp<-NULL
    rtext_only<-NULL
    y<-NULL
    total_value<-NULL
    number_of_positive<-NULL
    number_of_negative<-NULL
    
    for (i in 1:nrow(rtext8)){
      
      rtext_only[i]<-as.character(rtext8$reviewText[i])
      sentiment_score<-NULL
      sentiment_score<-sentiment(rtext_only[i])
      
      k<-0
      for (k in 1:nrow(sentiment_score)){
        if(sentiment_score$sentiment[k]>.15){
          sentiment_score$sentiment_final[k]="Positive"
        }
        else if (sentiment_score$sentiment[k]<0.01){
          sentiment_score$sentiment_final[k]="Negative"
        }
        else{
          sentiment_score$sentiment_final[k]="Neutral"
        }
      }
      
      number_of_positive<-nrow(sentiment_score[which(sentiment_score$sentiment_final=="Positive"),])
      number_of_negative<-nrow(sentiment_score[which(sentiment_score$sentiment_final=="Negative"),])
      total_value<-number_of_positive+number_of_negative
      businessName<-as.character(rtext8[i,2])
      businessId<-as.character(rtext8[i,1])
      temp<-c(businessId,businessName,number_of_positive,number_of_negative,total_value)
      y <- rbind(y, temp)
      
    }
    
    y<-as.data.frame(y)
    colnames(y)<-c("businessId","businessName","Num_Pos","Num_Neg","Total")
    
    y$Num_Pos<-as.numeric(as.character(y$Num_Pos))
    y$Num_Neg<-as.numeric(as.character(y$Num_Neg))
    y$Total<-as.numeric(as.character(y$Total))
    
    new_y<-y%>%group_by(businessId,businessName)%>%summarise(pos_tot=sum(Num_Pos), neg_tot=sum(Num_Neg),total=sum(Total))
    
    
    
    new_y$Share_Pos<-round(as.numeric(new_y$pos_tot)/as.numeric(new_y$total)*100,digits = 2)
    new_y$Share_Neg<-round(as.numeric(new_y$neg_tot)/as.numeric(new_y$total)*100,digits = 2)
    
    constant_y<-new_y[which(new_y$businessId==bId),]
    constant_y<-as.numeric(constant_y[1,6])
    
    final_data<-new_y[,c(2,6,7)]
    
    final2<- final_data%>%select(businessName,Share_Pos,Share_Neg)%>%gather(Share_Pos,Share_Neg,-c(businessName))
    
    colnames(final2)<-c("Business_Name","Sentiment_Share","Value_in_Percent")
    final2<-as.data.frame(final2)
    
    
    new_plot<-final2%>%ggplot()+geom_col(aes(x=Business_Name,y=Value_in_Percent,fill=Sentiment_Share))+
      scale_fill_manual(values = c("blue","red"))+
      geom_hline(yintercept = constant_y)+
      theme(axis.text.x = element_text(angle = 90,size = 8),plot.background = element_blank(),
            panel.background = element_blank(),panel.grid = element_blank(),
            legend.background = element_blank())+
      annotate(geom = "text",x = 0,y = 106,label="Horizontal Line Represents Share of Positive Score of Chosen Customer",color="black",hjust=0)
    
    new_plot
    
  })
  
  
  
  query12 <- eventReactive(input$insert_data23, {
    
    BID2<-input$businessId2
    #BID<-"PfOCPjBrlQAnz__NXj9h_w222"
    
    BName2<-input$businessName2
    #BName<-"Brick House Your Tavern + Tap"
    
    BNeigh2<-input$neighborhood2
    #BNeigh<-"Uptown"
    
    BOPen2<-input$isOpen2
    #BOPen<-1
    
    
    
    dbhandle5 <- odbcDriverConnect('Driver=FreeTDS;TDS_Version=7.2;server=thaque2050.cgz0la30vrak.us-east-2.rds.amazonaws.com;port=1433;database=Group_Project_BUDT758Y;uid=thaque786;pwd=tariq214H')
    
    res2<-sqlQuery(dbhandle5,'SELECT COUNT(*) FROM P_Business')
    
    query1<-paste("INSERT INTO P_Business VALUES (","'",BID2,"'",",","'",BName2,"'",",","'",BNeigh2,"'",",","'",BOPen2,"'",")",sep = "")
    sqlcot1<-query1
    res <- sqlQuery(dbhandle5, sqlcot1)
    odbcClose(dbhandle5)
   res2
 #  query1
    
    
    
  })
  
  
  query13 <- eventReactive(input$insert_data24, {
    
    dbhandle5 <- odbcDriverConnect('Driver=FreeTDS;TDS_Version=7.2;server=thaque2050.cgz0la30vrak.us-east-2.rds.amazonaws.com;port=1433;database=Group_Project_BUDT758Y;uid=thaque786;pwd=tariq214H')
    res3<-sqlQuery(dbhandle5,'SELECT COUNT(*) FROM P_Business')
    odbcClose(dbhandle5)
    res3
  })
  
  
  output$insert_data124<-renderText({
    res1<-query12()
    res3<-query13()
    
    if(res3>res1){
      a<-paste("Data is successfully added and now there are ",res3," businesses in the database",sep = "")
    }
    else{
      a<-paste("Data is not successfully added and there are still ",res3," businesses in the database",sep = "")
    }

    a
    
  })
  
  
  query56 <- eventReactive(input$delete_data233, {
    
    BID2<-input$businessId3
#    BID2<-'PfOCPjBrlQAnz__NXj9h_w222'
    
    dbhandle5 <- odbcDriverConnect('Driver=FreeTDS;TDS_Version=7.2;server=thaque2050.cgz0la30vrak.us-east-2.rds.amazonaws.com;port=1433;database=Group_Project_BUDT758Y;uid=thaque786;pwd=tariq214H')
    
    query1<-paste("SELECT COUNT(*) FROM P_BusinessCategory WHERE businessId= ","'",BID2,"'",sep = "")
    res1<-sqlQuery(dbhandle5,query1)
    
    query2<-paste("SELECT COUNT(*) FROM P_BusinessLocation WHERE businessId= ","'",BID2,"'",sep = "")
    res2<-sqlQuery(dbhandle5,query2)
    
    query3<-paste("SELECT COUNT(*) FROM P_BusinessSuggestion WHERE businessId= ","'",BID2,"'",sep = "")
    res3<-sqlQuery(dbhandle5,query3)
    
    query4<-paste("SELECT COUNT(*) FROM P_BusinessSuggestion WHERE businessId= ","'",BID2,"'",sep = "")
    res4<-sqlQuery(dbhandle5,query4)
    
    query6<-paste("DELETE FROM P_Business WHERE businessId= ","'",BID2,"'",sep = "")
    res6<-sqlQuery(dbhandle5,query6)
    
    
    res5<-max(res1,res2,res3,res4)
  })
  
  
  
  
  output$delete_data1243<-renderText({
    tres1<-query56()
    
    if(tres1>0){
      a<-"Data cannot be deleted due to referential integrity constraints"
    }
    else{
      a<-"Data Deleted"
    }
    
    a
    
  })

  
}




shinyApp(ui = ui,server = server)

