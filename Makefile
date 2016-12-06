
# variable for url
url = https://ed-public-download.apps.cloud.gov/downloads/Most-Recent-Cohorts-All-Data-Elements.csv

.PHONY: data eda regressions report shiny clean all slides

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
	Rscript code/scripts/session-info.R

report/report.pdf:
	cat report/01-intro.Rnw report/02-Model.Rnw report/03-shinyapp.Rnw report/conclusions.Rnw > report/report.Rnw 
	Rscript -e "library(knitr); knit('report/report.Rnw')"
	pdflatex report.tex
	cp report.pdf report/report.pdf
	rm report.pdf
	#Rscript -e "library(knitr); knit2pdf('report/report.Rnw', output = 'report/report.pdf')"

# This target will generate the presentation in html output. 
slides: 
	Rscript -e 'library(rmarkdown); render("slides/presentation.Rmd")'
	
shiny:
	Rscript shiny/app.R

clean: 
	rm -f report/report.pdf
