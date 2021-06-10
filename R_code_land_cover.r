####################
#### Land Cover ####
####################

require(raster)
require(RStoolbox)
#require(rasterdiv)
#require(rasterVis)
require(ggplot2)
#install.packages("gridExtra")
require(gridExtra)
setwd("/Users/federicotossani/lab/")

defor1<-brick("defor1.jpeg")
defor2<-brick("defor2.jpeg")
#uso brick perchè sto caricando l'intero dataset

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

#unsupervised classification
#si chiama così perchè è il software che scegli random un campione di pixel nell'immagine da dividere in classi
set.seed(42)
d1c<-unsuperClass(defor1, nClasses=2)
plot(d1c$map)
d2c<-unsuperClass(defor2, nClasses=2)
plot(d2c$map)
#la divisioni in classi è random, nel senso che, anche se il numero è sempre 2, una volta la classe 1 è la foresta e la classe 2 la parte agricola ma se chiudo R e rifaccio questa operazione si possono invertire.
#per evitare questa cosa esiste la funzione set.seed() che ci permette di assegnare un numero al risultato (nel nostro caso la suddivisione in classi) della funzione così che non cambi mai.

set.seed(42)
d2cf<-unsuperClass(defor2, nClasses=3)
plot(d2cf$map)
#ho aumentato le classi per vedere se veniva individuato anche il fiume, ma l'immagine ottenuto è troppo dispersiva e forviante.
#nella classe del fiume sono stati accorpati pezzi di zone agricole, probabilmente ci sono 2 coltivazioni distinte che riflettono in maniera diversa.

#ora proviamo a calcolare la frequenza dei pixel di una certa classe.
#lo possiamo fare con la funzion freq

freq(d1c$map)
#     value  count
# [1,]     1  35322
# [2,]     2 305970
#qua sopra troviamo il numero di pixel di ogni classe!
#la classe 1 corrisponde alla parte agricola
#la classe 2 alla parte di foresta


## lez 07/05 min 54












