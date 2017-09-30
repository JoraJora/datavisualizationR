library(rmarkdown)
library(slidify)

rmarkdown::render('index.Rmd', 
	              'knitrBootstrap::bootstrap_document', 
                  output_file = readJson$labelHtml[["html"]],  output_dir = docPath, 
                  encoding = "utf-8")

