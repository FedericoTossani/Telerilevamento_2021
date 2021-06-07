##############################
#### Analisi multivariata ####
##############################

library(raster)
library(RStoolbox)
setwd("/Users/federicotossani/lab/")

p224r63_2011<-brick("p224r63_2011_masked.grd")
#uso brick per caricare un set multiplo di dati!
#raster invece carica un set per volta!!

#plot(p224r63_2011$B1_sre, p224r63_2011$B2_sre)
#l'ordine delle 2 bande dipende dall'ordine scritto nella funzione.

#per rendere il plot più carino possiamo dargli un colore e cambiare il carattere dei punti ed aumentarne la dimensione
plot(p224r63_2011$B1_sre, p224r63_2011$B2_sre, col="blue", pch=13, cex=2)
#dopo il plot esce un warrning che dice che il plot usa il 2.2% delle celle, infatti i pixel nell'immagine sono più di 4milioni e non riuscirebbe plottarli tutti

#questo sistema in statistica si chiama multicollinearità. significa che le variabili sono correlate tra loro.
#questa forma di correlazione è usata in modo causale!!! Bisogna stare attenti a correlare 2 fenomeni, esempio delle cicogne e dei bambini in Germania.

#per plottare tutte le correlazioni possibili di tutte le variabili presenti nel dataset uso la funzione pairs

pairs(p224r63_2011)

#nella parte bassa della matrice trovia i grafici con tutte le correlazioni, nella parte alta invece gli indici di correlazione di pearson.
#se siamo positivamente correlate l'indice tende a 1, se lo siamo negativamente tende a -1.

#grazie a pairs vediamo quanto molte bande siano correlate tra loro.








