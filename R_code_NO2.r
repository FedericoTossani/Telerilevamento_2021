# R_code_NO2.r

require(raster)
require(RStoolbox)
setwd("/Users/federicotossani/lab/EN")

en1<-raster("EN_0001.png")
#in questo caso ho usato raster perchè mi serve solo il primo layer/banda.
#se invece voglio la seconda banda si usa brick e poi con il dollaro si lega la seconda banda al file, oppure aggiungo largomento band=num_banda nella funzione raster.

#adesso plotto l'immagine con una color ramp palette a mio piacere.
cl <- colorRampPalette(c("dark blue", "light blue", "red", "yellow"))(100)
plot(en1, col=cl)

#importo l'ultima immagine e faccio la differenza tra le 2 immagini importate
en13<-raster("EN_0013.png")
plot(en13, col=cl)

endiff<-en13-en1
plot(endiff, col=cl)

#ho fatto la differenza delle due immagini e l'ho plottata per mettere in evidenza le zone che hanno subito i maggiori cambiamenti.
#con questa Color Ramp sono le zone azzurro/blu ad avere subito i cambiamenti maggiori.

par(mfrow=c(1,3))
plot(en1, col=cl, main="NO2 january")
plot(en13, col=cl, main="NO2 march")
plot(endiff, col=cl, main="Difference of NO2 between jan-mar")

# se voglio anche mettere un titolo aggiungo l'argomento "main" all'interno della funzione plot.

#per importare tutto il dataset invece ne faccio una lista e poi uso lapply per applicare raster a tutte le immagini
enlist<-list.files(pattern="EN")
enimport<-lapply(enlist, raster)
en<-stack(enimport)
plot(en, col=cl)

#una volta importato il dataset se voglio plottare solo una delle immagini importate uso il $

par(mfrow=c(1,2))
plot(en$EN_0001, col=cl)
plot(en$EN_0013, col=cl)

#analisi multivariata dell'intero stack
enpca<-rasterPCA(en)

plotRGB(enpca, 1, 2, 3, stretch="lin")

#calcoliamo la variabilità tra la prima e l'ultima immagine sulla prima componente della variabilità

enpc1<-enpca$map$PC1
enpc1_sd3<-focal(enpc1, w=matrix(1/9, nrow=3, ncol=3), fun=sd)
cl <- colorRampPalette(c("dark blue", "light blue", "red", "yellow"))(100)
plot(enpc1_sd3, col=cl)
