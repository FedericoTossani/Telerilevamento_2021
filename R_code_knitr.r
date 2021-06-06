###############################
#### Codice prova di Knitr ####
###############################

library(knitr)
setwd("/Users/federicotossani/lab/")

stitch("R_code_greenland.txt", template=system.file("misc", "knitr-template.Rnw", package="knitr"))

#prima di tutto apro il codice di cui mi interessa fare il report e lo salvo nella cartella (lab ne nostro caso).
#il primo argomento di stich è il nome del file contenente il codice e la sua estensione.
#in questo modo leggerà automaticamente tutto il codice e creerà il report.
#il template è l'altro argomento che ci ha fornito riettamente il prof
#l'ultimo è il tipo di pacchetto che andiamo ad utilizzare
