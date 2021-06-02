###############################
#### Codice prova di Knitr ####
###############################

library(knitr)
setwd("/Users/federicotossani/lab/")

stitch("R_code_greenland.txt", template=system.file("misc", "knitr-template.Rnw", package="knitr"))

#riprendi dal 1:08:00 del 16/04
