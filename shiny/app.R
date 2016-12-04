library(shiny)
library(ggplot2)
library(gridExtra)

# read in client data
dat<-read.csv("data/client_data.csv", stringsAsFactors = FALSE)
dat[dat == 'NULL'] <- NA

# cities to counties
city_loc <- read.csv('https://www.gaslampmedia.com/wp-content/uploads/2013/08/zip_codes_states.csv',
                          header = TRUE, stringsAsFactors = FALSE)
cali_loc <- city_loc[city_loc$state == 'CA',]
cali_city <- cali_loc[,c('city','county')]
unique_cali_city <- unique(cali_city)
row.names(unique_cali_city) <- NULL

# county to region
socal <- c('Imperial', 'Kern',
           'Los Angeles', 'Orange',
           'Riverside', 'San Bernardino',
           'San Diego', 'San Luis Obispo',
           'Santa Barbara', 'Ventura')
cencal <- c('Fresno', 'Monterey',
            'Kings', 'San Benito',
            'Madera', 'Stanislaus',
            'Mariposa', 'Tulare',
            'Merced', 'Tuolumne')
norcal <- c('Alameda', 'San Mateo',
            'Alpine', 'Marin', 'Santa Clara',
            'Amador', 'Santa Cruz',
            'Butte', 'Mendocino',
            'Shasta', 'Calaveras',
            'Sonoma', 'Sierra',
            'Colusa', 'Modoc',
            'Siskiyou', 'Contra Costa',
            'Mono', 'Solano',
            'Del Norte',
            'El Dorado', 'Napa', 'Nevada', 
            'Sutter', 'Glenn',
            'Placer', 'Tehama',
            'Humboldt', 'Plumas',
            'Trinity', 'Inyo',
            'Sacramento',
            'Lake', 'San Francisco',
            'Yolo', 'Lassen',
            'San Joaquin', 'Yuba')
region_indic <- c(rep('socal',length(socal)),
                  rep('cencal', length(cencal)),
                  rep('norcal', length(norcal)))
county <- c(socal,cencal, norcal)
region_df <- data.frame(county, region_indic)
region_final <- merge(unique_cali_city, region_df)
region_final <- region_final[-922,] # taking out san mateo county for sf
hollywood <- data.frame('county' = 'Los Angeles',
                        'city' = 'Hollywood',
                        'region_indic' = 'socal')
region_final <- rbind(region_final, hollywood)


regions = c()
for (index in 1:nrow(dat)) {
  regions[index] <- as.character(region_final$region_indic[which(region_final$city == dat$City[index])])
}         

dat$cali_region <- regions
for (col in 27:35) {
  dat[,col] <- as.numeric(dat[,col])
}

socal <- dat[dat$cali_region == 'socal',]
cencal <- dat[dat$cali_region == 'cencal',]
norcal <- dat[dat$cali_region == 'norcal',]

# Still need to do regions comparison
# Also need to do class age and average income
  




# SHINY APP
ui <- shinyUI(fluidPage(
  titlePanel("Pie Charts of Selected Groups"),
  sidebarLayout(
    sidebarPanel(
      selectInput("groupa",
                  label = "Group A",
                  c(dat$INST)
      ),
      selectInput("groupb",
                  label = "Group B",
                  c(dat$INST)
      ),
      radioButtons('class',
                   label = 'Class Type',
                   c('Gender', 'Ethnicity', 'Graduation Rate (Not Applicable for Pie Charts)')
      ),
      radioButtons('chart',
                   label = 'Chart Type',
                   c('Pie', 'Bar')
      )
    ),
    mainPanel(
      plotOutput("main_plot")
    )
  )
)
)


server <- function(input, output) {
  output$main_plot <- renderPlot({
    selections <- c(dat$INST)
    if (input$class == 'Gender') {
      name <- c('Enroll_Men', 'Enroll_Women')
      class_name <- 'Gender'
    } else if (input$class == 'Ethnicity') {
      name <- names(dat)[12:20]
      class_name <- 'Ethnicity'
    } else {
      name <- names(dat)[27:35]
      class_name <- 'Graduation Rate'
    }
    for (index in 1:length(selections)) {
      if (input$groupa == selections[index]) {
        if (input$chart == 'Pie') {
          slices <- dat[which(dat$INST == selections[index]),name]
          pie_data <- data.frame('Group' = names(slices), 'Percentages' = as.numeric(slices), stringsAsFactors = FALSE)
          plot1 <- ggplot(data = pie_data, aes(x = '', y = Percentages, fill = Group)) + 
            geom_bar(width = 1, stat = 'identity') + 
            coord_polar(theta = 'y', start = 0) +
            xlab('') + 
            ylab('') + 
            ggtitle(paste0(input$class,' Percentages in ', selections[index]))
        } else if (input$chart == 'Bar') {
          slices <- dat[which(dat$INST == selections[index]),name]
          bar_data <- data.frame('Group' = factor(names(slices)), 
                                   'Percentages' = as.numeric(slices)
          )
          plot1 <- ggplot(data = bar_data, aes(x = Group, y = Percentages, fill = Group)) +
            geom_bar(stat="identity")
        }
        }
    }
    for (index2 in 1:length(selections)) {
      if (input$groupb == selections[index2]) {
        if (input$chart == 'Pie') {
          slices <- dat[which(dat$INST == selections[index2]),name]
          pie_data <- data.frame('Group' = names(slices), 
                                 'Percentages' = as.numeric(slices), 
                                 stringsAsFactors = FALSE)
          plot2 <- ggplot(data = pie_data, aes(x = '', y = Percentages, fill = Group)) + 
            geom_bar(width = 1, stat = 'identity') + 
            coord_polar(theta = 'y', start = 0) +
            xlab('') + 
            ylab('') + 
            ggtitle(paste0(class_name,' Percentages in ', selections[index2]))
        } else if (input$chart == 'Bar') {
          slices <- dat[which(dat$INST == selections[index2]),name]
          bar_data <- data.frame('Group' = factor(names(slices)), 
                                 'Percentages' = as.numeric(slices)
          )
          plot2 <- ggplot(data = bar_data, aes(x = Group, y = Percentages, fill = Group)) +
              geom_bar(stat="identity")
        }
      }
    }
    if (class_name == 'Graduation Rate' & input$chart == 'Pie') {
      plot.new()
    } else {
      if (input$chart == 'Pie') {
        grid.arrange(plot1, plot2, ncol = 2) 
      } else if (input$chart == 'Bar') {
        grid.arrange(plot1, plot2, nrow = 2)
      }
    }
  })
}

shinyApp(ui = ui, server = server) 