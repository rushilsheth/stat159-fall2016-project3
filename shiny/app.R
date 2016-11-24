#read in client data

dat<-read.csv("../data/client_data.csv",row.names=1)


#UI for drop down menu


UI <- pageWithSidebar(
  headerPanel('California is Artsy'),
  sidebarPanel(
    selectInput('school', 'Schools', c("ALL", dat[,4])),
    selectInput('facet', 'Facet', c("age", "gender", "income"))
  ),
  mainPanel(
    plotOutput(outputId = "main_plot")
  )
)

## plots for regression methods 
server <- function(input, output) {

output$main_plot <- renderPlot({

  if(input$school == "ALL"){
    hist(dat$Avg_Fam_Inc,main="Histogram of Averag Family Income", xlab="Average Family Income",col="lightblue")
      } else

    hist(dat$Avg_Fam_Inc,main="Histogram of Averag Family Income", xlab="Average Family Income",col="blue")

   })

 }


shinyApp(ui = UI, server = server) 




# # library(shiny) 
# #library (pls)
# #library (glmnet)

# library(png) # For writePNG function


# client_data <- read.csv("../data/client_data.csv")

# #UI for drop down menu


# pageWithSidebar(
#   headerPanel('Getting Artsy in California'),
#   sidebarPanel(
#     selectInput('school', 'Schools', colnames(client_data)),
#     selectInput('facet', 'Facet', c("age", "gender", "income"),
#                 selected= "age")
#   ),
#   mainPanel(
#     readPNG("../images/EDA/histogram-age.png")
#   )
# )