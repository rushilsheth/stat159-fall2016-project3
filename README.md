#Stat 159 Final Project- Virtual Statistical Consulting 
##Description
This is the public repository for Stat 159 consulting project for a virtual client. Our targeted client is a group of 4-year art institution administrators in California trying to compare themselves to similar schools demographically, in terms of diversity and graduation rate.
<br>

##Author
<br>
Atul Lanka, Timothy Park, Rushil Seth, Yuyu Zhang
<br>

##Team Member Responsibility
Atul Lanka: Model Building and "model building" section of report

Timothy Park:  Slides and general repository maintenance (compile Readme and report files) 

Rushil Seth: Data cleaning, Shiny App and "shiny app" section of report 

Yuyu Zhang: EDA analysis, all Readme files and first four sections of report 
<br>
## Steps
1. git clone the repository
2. `cd` into directory
3. run `make all` to execute all scripts and get all output

<br>
##File Structure



<br>

Code: This directory contains all the code for data cleaning, EDA analysis and model building
Data: This directory contains the raw data, clean data, EDA statistics model building output
Images: This directory contains images generated from EDA (barplots, histogram) and model building
Shiny: This directory contains code for building the interactive shiny App
Report: This directory contains different sections of the report and the finalized report 

<br>
##Makefile Commands
 The Makefile in this directory contains a number of phony targets which run different pieces of the data acquisition, cleaning, model fitting, analysis, app building and report. To run certain targets, simply type "make target_name" into the terminal. Here is a list of the phony target titles:
 • all: runs the main aspects of our project: Exploratory data analysis, Model creation, and Report compiling/rendering  
• data: downloads the file Credit.csv to the folder data/    
• eda: performs the exploratory data analysis  
• ols: OLS regression  
• ridge: Rdige Regression  
• lasso: Lasso Regression  
• pcr: Principal Components Regression  
• plsr: Partial Least Squares Regression  
• regressions: all five regressions    
• report: concatenates the .Rmd report from the individual sections, and then render the report.pdf  
• slides: generates the actual slides.html from our slides.Rmd  
• session: generates session-info.txt  
• clean: deletes the generated report files, both .Rmd and .pdf  




![Creative Common License](https://i.creativecommons.org/l/by/4.0/88x31.png)


All the media content(narrative and images) is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

All source code (i.e. code in R script files) is licensed under MIT License, version 3. See the `LICENSE` file
for more information
