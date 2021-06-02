### COPERNICUS ####
#codice per utilizzare i dati copernicus!

install.packages("ncdf4")
library(raster)
library(ncdf4)

setwd("/Users/federicotossani/lab/")

#prima di importare l'immagine l'ho rinominata.
NDVI <- raster("NDVI_202006010.nc")
NDVI

#la risoluzione è in gradi, non in metri, sono quindi coordinate geografiche.
#il sistema di riferimento è il WGS84

cl<-colorRampPalette(c("brown", "yellow", "green", "darkgreen")) (200)
plot(NDVI, col=cl)

#questo dato si può ricampionare per ottenerne uno con pixel più grandi e alleggerirlo.
#per ricampionare l'immagine uso la funzione aggregate

NDVIres<-aggregate(NDVI, fact=100)
NDVIres

#questo tipo di ricampionamento di chiama bilineare, prende 2 line di pixel e fa la media dei pixel all'interno.
