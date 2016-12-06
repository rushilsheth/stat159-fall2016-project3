library(shiny)
library(ggplot2)
library(gridExtra)

# read in client data
dat<-read.csv("data/client-data.csv", stringsAsFactors = FALSE)
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

dat_orig <- dat #test purposes

# filtering the necessary columns from dat
needed_col <- c('INST', names(dat)[c(12:23,25,27:35)], 'cali_region')
dat <- dat[, needed_col]

cali_names <- c('Northern California', 'Central California', 'Southern California')

socal <- dat[dat$cali_region == 'socal',]
socal_mean <- apply(socal[,2:23],2,mean, na.rm = TRUE)
socal_df <- data.frame(socal_mean)
socal_df <- t(socal_df)
row.names(socal_df) <- NULL
dummy <- data.frame('INST' = 'Southern California')
socal_df <- cbind(dummy, socal_df)

cencal <- dat[dat$cali_region == 'cencal',]
cencal_mean <- apply(cencal[,2:23],2,mean, na.rm = TRUE)
cencal_df <- data.frame(cencal_mean)
cencal_df <- t(cencal_df)
row.names(cencal_df) <- NULL
cencal_df[cencal_df == 'NaN'] = 0
dummy <- data.frame('INST' = 'Central California')
cencal_df <- cbind(dummy, cencal_df)

norcal <- dat[dat$cali_region == 'norcal',]
norcal_mean <- apply(norcal[,2:23],2,mean, na.rm = TRUE)
norcal_df <- data.frame(norcal_mean)
norcal_df <- t(norcal_df)
row.names(norcal_df) <- NULL
dummy <- data.frame('INST' = 'Northern California')
norcal_df <- cbind(dummy, norcal_df)

dat[,'cali_region'] <- NULL
dat <- rbind(dat, socal_df, cencal_df, norcal_df)
dat$Med_Fam_Inc <- dat$Med_Fam_Inc/1000

# SHINY APP
ui <- shinyUI(fluidPage(
  titlePanel("Comparing Class Types Amongst California Art Schools"),
  sidebarLayout(
    sidebarPanel(
      selectInput("groupa",
                  label = "Group A",
                  dat$INST,
                  selected = dat$INST[32]
      ),
      selectInput("groupb",
                  label = "Group B",
                  dat$INST,
                  selected = dat$INST[34]
      ),
      radioButtons('class',
                   label = 'Class Type',
                   c('Gender', 'Ethnicity',
                     'Age and Income (Not Applicable for Pie Charts)',
                     'Graduation Rate (Not Applicable for Pie Charts)')
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
      name <- names(dat)[2:10]
      class_name <- 'Ethnicity'
    } else if (input$class == 'Graduation Rate (Not Applicable for Pie Charts)') {
      name <- names(dat)[15:23]
      class_name <- 'Graduation Rate'
    } else if (input$class == 'Age and Income (Not Applicable for Pie Charts)') {
      name <- names(dat)[c(13,14)]
      class_name <- 'Age and Income (Not Applicable for Pie Charts)'
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
            ggtitle(paste0(class_name,' Percentages in ', selections[index]))
        } else if (input$chart == 'Bar') {
          slices <- dat[which(dat$INST == selections[index]),name]
          if (input$class == 'Age and Income (Not Applicable for Pie Charts)') {
            bar_data <- data.frame('Group' = factor(names(slices)), 
                                   'Quantity' = as.numeric(slices))
            plot1 <- ggplot(data = bar_data, aes(x = Group, y = Quantity, fill = Group)) +
              geom_bar(stat="identity") +
              ggtitle(paste0('Age and Income Quantities in ', selections[index], ' (Income in thousands)'))
          } else {
            bar_data <- data.frame('Group' = factor(names(slices)),
                                   'Percentages' = as.numeric(slices))
            plot1 <- ggplot(data = bar_data, aes(x = Group, y = Percentages, fill = Group)) +
              geom_bar(stat="identity") +
              ggtitle(paste0(class_name,' Percentages in ', selections[index]))
          }
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
            if (input$class == 'Age and Income (Not Applicable for Pie Charts)') {
              bar_data <- data.frame('Group' = factor(names(slices)), 
                                     'Quantity' = as.numeric(slices))
              plot2 <- ggplot(data = bar_data, aes(x = Group, y = Quantity, fill = Group)) +
                geom_bar(stat="identity") + 
                ggtitle(paste0('Age and Income Quantities in ', selections[index2], ' (Income in thousands)'))
            } else {
              bar_data <- data.frame('Group' = factor(names(slices)), 
                                     'Percentages' = as.numeric(slices))
              plot2 <- ggplot(data = bar_data, aes(x = Group, y = Percentages, fill = Group)) +
               geom_bar(stat="identity") + 
               ggtitle(paste0(class_name,' Percentages in ', selections[index2]))
            }
        }
      }
    }
    if (class_name == 'Graduation Rate' & input$chart == 'Pie') {
      plot.new()
    } else if (class_name == 'Age and Income (Not Applicable for Pie Charts)' & input$chart == 'Pie') {
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

