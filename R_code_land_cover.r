####################
#### Land Cover ####
####################

require(raster)
require(RStoolbox)
#require(rasterdiv)
#require(rasterVis)
require(ggplot2)
install.packages("gridExtra")
require(gridExtra)
setwd("/Users/federicotossani/lab/")

defor1<-brick("defor1.jpeg")
defor2<-brick("defor2.jpeg")

plotRGB(defor1, 1,2,3, stretch="lin")
plotRGB(defor2, 1,2,3, stretch="lin")

#in questo caso le bande sono 1 NIR, 2 Red e 3 Green perchè sono immagini già processate.
#con ggplot e RStoolbox ci sono funzioni per plottare immagini in maniera molto più potente. Una di queste è ggR

ggRGB(defor1, 1,2,3, stretch="lin")
ggRGB(defor2, 1,2,3, stretch="lin")

#par(mfrow=c(1,2)) la funzione par con ggRGB non funziona, bisogna usare gridEXTRA
ggRGB(defor1, 1,2,3, stretch="lin")
ggRGB(defor2, 1,2,3, stretch="lin")
#grid.arrange ci permette di organizzare il nostro multiframe come più ci piace.

p1 <- ggRGB(defor1, 1,2,3, stretch="lin")
p2 <- ggRGB(defor2, 1,2,3, stretch="lin")
grid.arrange (p1,p2, nrow=2)


##########

#una mappa di vegetazione è molto più particolareggiata di una mappa di copertura, per poterla fare ci servono dei dati iperspettrali.
#avendo molte bande ci permettono di individuare specie diverse in base ai diversi valori di riflettanza. Bisogna riuscire a vedere le diverse firme spettrali.
#


#############################
#### lez.07/05 min 11:12 ####
#############################


