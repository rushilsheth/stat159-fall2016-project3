.PHONY: data eda report shiny clean all 

all: eda data report slides session-info 

data:
	curl -o data/orig-data.csv https://ed-public-download.apps.cloud.gov/downloads/Most-Recent-Cohorts-All-Data-Elements.csv

eda:
	Rscript code/scripts/eda-script-enroll.R
	Rscript code/scripts/eda-script-grad.R

session-info:
	bash session-info.sh 
	Rscript code/scripts/session.info.R

report: report/sections/*.Rmd
	cat report/sections/*.Rmd > report/report.Rmd
	Rscript -e 'library(rmarkdown); render("report/report.Rmd")'

slides:
	Rscript -e 'library(rmarkdown); render("slides/presentation.Rmd")'

shiny:
	R -e "shiny::runApp('shiny/app.R')"

clean: 
	rm -f report/report.pdf