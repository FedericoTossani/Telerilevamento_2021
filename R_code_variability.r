##############################
#### R_code_variability.r ####
##############################

require(raster)
require(RStoolbox)
require(ggplot2)
require(viridis)
require(gridExtra)
setwd("/Users/federicotossani/lab/")

sentinel<-brick("sentinel.png")
#importo l'immagine del similaun con la funzione brick per poter importare l'intero dataset

#plotRGB(sentinel, 1, 2, 3, stretch="lin")
plotRGB(sentinel)
#in questo caso posso evitare di scrivere 1,2,3 e lo stretch. perchè essendo un'immagine già processata con solo le bande che ci interessano di default va già bene.
#in questa immagine si vede bene l'acqua pura che prende il colore nero.

#per fare il calcolo della deviazione standard useremo solo una banda e al suo interno ci faremo passare la moving window che farà il calcolo.




