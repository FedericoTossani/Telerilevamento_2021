###############################
#### Codice prova di Knitr ####
###############################

library(knitr)
setwd("/Users/federicotossani/lab/")

stitch("R_code_greenland.r", template=system.file("misc", "knitr-template.Rnw", package="knitr"))

#riprendi da min 32:42 del 16/04
