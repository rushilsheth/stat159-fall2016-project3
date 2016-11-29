#read in client data

dat<-read.csv("../data/client_data.csv")


#UI for drop down menu


UI <- pageWithSidebar(
  headerPanel('California is Artsy'),
  sidebarPanel(
    selectInput('school', 'Schools', c("ALL", as.character(dat[,5]))),
    selectInput('facet', 'Facet', c("ALL", "age", "gender", "income"))
  ),
  mainPanel(
    plotOutput(outputId = "main_plot")
  )
)

## plots for regression methods 
server <- function(input, output) {

output$main_plot <- renderPlot({

  if(input$school == "ALL"){
    if(input$facet == "ALL"){
      hist(dat$Avg_Fam_Inc,main="Histogram of Averag Family Income", xlab="Average Family Income",col="red")
    } else {hist(dat$Avg_Fam_Inc,main="Histogram of Averag Family Income", xlab="Average Family Income",col="green")}
  } else{ 
      if(input$facet == "ALL"){
        hist(dat$Avg_Fam_Inc,main="Histogram of Averag Family Income", xlab="Average Family Income",col="yellow")
      } else{hist(dat$Avg_Fam_Inc,main="Histogram of Averag Family Income", xlab="Average Family Income",col="blue")}
    }
  })
}







shinyApp(ui = UI, server = server) 


