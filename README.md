# Visualizr

Visualizr is an R wrapper for [rparser](https://github.com/HSPS-DataScience/RParser), an R script parsing module built in Python. The module takes an r script as a template and converts it to RMarkdown, simplifing initial EDA on new datasets and avoiding copying and pasting Rmd documents from project to project. 

### Installation 
* RParser:
  + Requires `Python 3.6.5 >=` 
  + `pip install git+https://github.com/HSPS-DataScience/RParser.git#egg=RParser`
  + To update RParser from github, uninstall: `pip uninstall RParser` then install again 
* Visualizr: 
  + `library(devtools)` 
  + `devtools::install_github("HSPS-DataScience/HSPSUtils")` 
  + `devtools::install_github("HSPS-DataScience/Visualizr") 
* Update visualizr:
  + `devtools::update_packages("Visualizr")` 
  
### Note
* File IO and manipulation is much easier in Python as compared with R so the functionality was abstracted into the Python module
* `knitr::spin` and `knitr::stitch` offer similar functionality to RParser, however, they focus on building html documents out of r scripts and Rmd templates. The utility of Visualizr provides the user with an Rmd file generated from a template. This provides a single source for templates but still allows the user to change the generic functions in their own Rmd file.  
