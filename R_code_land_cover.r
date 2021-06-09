####################
#### Land Cover ####
####################

require(raster)
require(RStoolbox)
#require(rasterdiv)
#require(rasterVis)
require(ggplot2)
setwd("/Users/federicotossani/lab/")

defor1<-brick("defor1.jpeg")
defor2<-brick("defor2.jpeg")

plotRGB(defor1, 1,2,3, stretch="lin")
plotRGB(defor2, 1,2,3, stretch="lin")

#in questo caso le bande sono 1 NIR, 2 Red e 3 Green perchè sono immagini già processate.
#con ggplot e RStoolbox ci sono funzioni per plottare immagini in maniera molto più potente. Una di queste è ggR

ggRGB(defor1, 1,2,3, stretch="lin")
ggRGB(defor2, 1,2,3, stretch="lin")

par(mfrow=c(1,2))
ggRGB(defor1, 1,2,3, stretch="lin")
ggRGB(defor2, 1,2,3, stretch="lin")
