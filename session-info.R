# Loading Packages that are Used 
library(xtable)
library(rmarkdown)
library(knitr)
library(glmnet)
library(pander)
library(pls)
library(plyr)
library(reshape2)
library(ggplot2)

library(shiny)
library(glmnet)

# Generating Session-Info.txt
sink("session-info.txt", append = TRUE)
cat("Session Information\n\n")
print(sessionInfo())
devtools::session_info()
sink()