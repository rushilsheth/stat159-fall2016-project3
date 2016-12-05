<<<<<<< HEAD
# variable for url
url = https://ed-public-download.apps.cloud.gov/downloads/Most-Recent-Cohorts-All-Data-Elements.csv

.PHONY: data eda report shiny clean all 
=======
.PHONY: data eda regressions report shiny clean all 
>>>>>>> 8e50cd1b2cd7c5d16d0c0e9dc6955aeffb52c6c8

all: eda data report slides session-info 

data:
	curl -o data/orig-data.csv $(url)

eda:
	Rscript code/scripts/eda-script-enroll.R
	Rscript code/scripts/eda-script-grad.R
ols:
	Rscript code/scripts/ols_regression.R

ridge: 
	Rscript code/scripts/Ridge-regression.R

lasso:
	Rscript code/scripts/Lasso_regression.R 

pcr:
	Rscript code/scripts/PC_regression.R

plsr:
	Rscript code/scripts/PLS_regression.R

regressions:
	make ols
	make ridge
	make lasso
	make pcr
	make plsr
	
session-info:
	bash session-info.sh 
	Rscript code/scripts/session.info.R

report: report/sections/*.Rmd
	cat $(<) > report/report.Rmd # automatic variable
	Rscript -e 'library(rmarkdown); render("report/report.Rmd")'

slides:
	Rscript -e 'library(rmarkdown); render("slides/presentation.Rmd")'

shiny:
	R -e "shiny::runApp('shiny/app.R')"

clean: 
	rm -f report/report.pdf
<<<<<<< HEAD


=======
>>>>>>> 8e50cd1b2cd7c5d16d0c0e9dc6955aeffb52c6c8
