##############################
#### Analisi multivariata ####
##############################

library(raster)
library(RStoolbox)
setwd("/Users/federicotossani/lab/")

p224r63_2011<-brick("p224r63_2011_masked.grd")
#uso brick per caricare un set multiplo di dati!
#raster invece carica un set per volta!!

p224r63_2011

#plot(p224r63_2011$B1_sre, p224r63_2011$B2_sre)
#l'ordine delle 2 bande dipende dall'ordine scritto nella funzione.

#per rendere il plot più carino possiamo dargli un colore e cambiare il carattere dei punti ed aumentarne la dimensione
plot(p224r63_2011$B1_sre, p224r63_2011$B2_sre, col="blue", pch=13, cex=2)
#dopo il plot esce un warrning che dice che il plot usa il 2.2% delle celle, infatti i pixel nell'immagine sono più di 4milioni e non riuscirebbe plottarli tutti

#questo sistema in statistica si chiama multicollinearità. significa che le variabili sono correlate tra loro.
#questa forma di correlazione è usata in modo causale!!! Bisogna stare attenti a correlare 2 fenomeni, esempio delle cicogne e dei bambini in Germania.

#per plottare tutte le correlazioni possibili di tutte le variabili presenti nel dataset uso la funzione pairs

pairs(p224r63_2011)

#nella parte bassa della matrice troviamo i grafici con tutte le correlazioni, nella parte alta invece gli indici di correlazione di pearson.
#se siamo positivamente correlate l'indice tende a 1, se lo siamo negativamente tende a -1.

#grazie a pairs vediamo quanto molte bande siano correlate tra loro.

#procediamo con la PCA, ma prima riduciamo le dimensioni dei nostri dati per velocizzare il processo.
#per farlo uso la funzione aggregate, questo processo si chiama ricampionamento o resampling

p224r63_2011_res<-aggregate(p224r63_2011, fact=10)

#questo processo ci ha permesso di passare da un pixel a 30m ad uno a 300m. aumentando la la grandezza del pixel abbiamo diminuito la risoluzione e il peso.
#per apprezzare la differenza possiamo fare un pannello per confrontare le due immagini

par(mfrow=c(2,1))
plotRGB(p224r63_2011,4,3,2, stretch="lin")
plotRGB(p224r63_2011_res,4,3,2, stretch="lin")

#ora applichiamo la rasterPCA che in poche parole prende l nostro paccheto di dati e li compatta in un numero minore di bande

p224r63_2011_pca<-rasterPCA(p224r63_2011_res)

plot(p224r63_2011_pca$map)
#nel plot ho legato la mappa al nome dell'immagine perchè oltra a questa la funzione rsaterPCA ha creato anche il modello ed altre cose.

summary(p224r63_2011_pca$model)
#la funzione summary è una funzione del pacchetto di base che crea un sommario del modello (in questo caso)
#dal risultato notiamo che la prima banda ha lo 0.998 della varianza totale, quindi quasi il totale della variabilità è contenuto in una banda sola.
#per avere il 100% della variabilità ovviamento dobbiamo usare tutte le bande, ma non è il nostro scopo. noi vogliamo la max variabilità con il minimo delle bande.
#anche nel plot delle immaini è così! nella banda 1 riusciamo a vedere tutto, foresta, zone agricole etc, nella banda 7 praticamente abbiamo solo rumore, un'immagine in cui è difficile distinguere le componenti.

p224r63_2011_pca
#cosa c'è nel modello?
#la prima componente è la call, legata con il dollaro all'oggetto generato, è la funzione.
#poi c'è il modello che è quello visto con la funzione summary.
#poi la mappa, che è un rasterbrick, con una certa risoluzione e le varia componenti.

#adesso facciamo un plot rgb con le 3 componenti principali

plotRGB(p224r63_2011_pca$map, 1,2,3, stretch="lin")


