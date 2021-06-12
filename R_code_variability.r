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
#in pratica è una finestra che si muove sui pixel dell'immagine e permette di creare una nuova mappa con associato ad ogni pixel un valore di deviazione standard calcolato non sull'intera immagine ma sui pixel contenuti nella finestra.
#questo processo però avviane solo su una banda, non su tutte. Dobbiamo quindi compattare tutte le bande. Per farlo possiamo usare degli indici di vegetazione.
#uno di questi è l'NDVI che è la sottrazione tra NIR e red diviso per la somma. così facendo otterremo la mappa dell'NDVI che è composta solo dalla banda NDVI.

nir<-sentinel$sentinel.1
red<-sentinel$sentinel.2

ndvi<-(nir-red)/(nir+red)
plot(ndvi)
#dove vediamo il bianco non c'è vegetazione, nel marroncino c'è la roccia, nel giallino/verdino sono le parti di bosco e il verde scuro sono le praterie
cl <- colorRampPalette(c("dark green","yellow","orange","red","white", "black"))(100)
plot(ndvi, col=cl)

#questo plot ci permette di apprezzare i diversi livelli di ndvi.

ndvi_sd3 <- focal(ndvi,w=matrix(1/9, nrow=3, ncol=3), fun=sd)
#la funzione focal mi permette di fare diversi calcoli statistici per mezzo della moving window
#gli argomenti nella funzione sono: il nome dell'immagine, la matrice (è la moving window) questa più è grande più pixel prende in considerazione e più lungo sarà il calcolo.
#1/9 significa che prendi in considerazione ogni pixel sui 9 della matrice.

plot(ndvi_sd3,col=cl)

#la colorazione ci da un'idea della distribuzione della deviazione standard nella nostra immagine.
#la sd è più bassa nella parti più omogenee, mentra aumenta nelle zone dove si passa da roccia nuda a parte vegetata. Torna a diminuire nelle zone di prateria, in quanto più omogenee.
#ci sono piccole zone in aumento che corrispondono ai picchi più alti e crepacci.

ndvi_m3 <- focal(ndvi,w=matrix(1/9, nrow=3, ncol=3), fun=mean)
plot(ndvi_m3,col=cl)

#in questo caso è lo stesso processo descritto precendentemente solo che la moving window calcola la media e non la deviazione standard.

ndvi_sd9 <- focal(ndvi,w=matrix(1/81, nrow=9, ncol=9), fun=sd)
plot(ndvi_sd9,col=cl)

#aumentando la dimensione della finestra sembra che diminuisca anche la risoluzione, in realta è un effetto dato dalla grandezza della finestra.
#la grandezza va scelta anche in base al tipo di ambiente. Nel nostro caso ci sono molti dettagli: crepacci, zone al limita tra roccia e bosco etc. con una finestra grande si tende ad omogenizzare il tutto.

#per compattare dei dati c'è un'altra tecnica, oltre all'utilizza degli indici di vegetazione.
#possiamo usare l'analisi multivariata per generare solo lo strato delle pc1 in cui sta la maggior parte della mia diversità.
#ovviamente non spiegherà tutto il range di diversità, ma circa il 90%.

sentpca <- rasterPCA(sentinel)
plot(sentpca$map)
#devo specificare $map perchè la funzione rasterPCA crea anche il modello

summary(sentpca$model)

#Importance of components:
#                           Comp.1     Comp.2      Comp.3 Comp.4
#Standard deviation     77.3362848 53.5145531 5.765599616      0
#Proportion of Variance  0.6736804  0.3225753 0.003744348      0
#Cumulative Proportion   0.6736804  0.9962557 1.000000000      1

#si nota che la prima componente principale spiega il 67.36% della variabilità. il 90% citato prima era un esempio esagerato, ma rende l'idea.

pc1<-sentpca$map$PC1

pc1_sd5<-focal(pc1, w=matrix(1/25, nrow=5, ncol=5), fun=sd)
clp<-colorRampPalette(c("blue","yellow","red","black","white"))(200)
plot(pc1_sd5, col=clp)
#stiamo lavorando su una sola banda perchè stiamo analizzando la dev.stand. di una singola banda.
#la parte in blu rappresenta le aree più omogenee mentre le parti gialle e rosse rappresentano i limiti con le rocce, dove la variabilità aumenta.

source("source_test_lezione.r")
#la funzione source mi permette di importare in R un codice già pronto e vedere direttamente il risultato finale.

source("source_ggplot.r")

ggplot()+
#con questa funzione abbiamo creato una finestra vuota! un po' come par.
#a questo punto per riempirla vanno aggiunti dei blocchi con il +
geom_raster(pc1_sd5, mapping=aes(x = x, y = y, fill = layer))+
#di questa funzione ne esistono molte, una per ogni geometria possibili (geom_point, geom_line etc)
#le estetiche in ggplot sono la parte plottata. la x, la y e tutti i valori al loro interno. tutto questo si inserisce nell'argomento mapping.

#a livello geografico questo processo ci permetter di individuare qualsiasi tipo di discontinuità, a livello geologico ci permette di individuare qualsiasi tipo di variabilità geomorfologica.
#a livello ecologico ci fa individuare qualsiasi passaggio ecologico (ecotono, passaggio da bosco a prateria)

#adesso cambiano la palette di colori con viridis, qua di seguito la funzione necessaria.
scale_fill_viridis()

#### plot completo con viridis palette
p1<-ggplot()+
geom_raster(pc1_sd5, mapping=aes(x = x, y = y, fill = layer))+
scale_fill_viridis()+
ggtitle("Standard deviation of PC1 by viridis color scale")

#### plot completo con magma palette
p2<-ggplot()+
geom_raster(pc1_sd5, mapping=aes(x = x, y = y, fill = layer))+
scale_fill_viridis(option="magma")+
ggtitle("Standard deviation of PC1 by magma color scale")

#queste scale di colore permettono di mettere in risalto le aree a maggior dev. stand.

#### plot completo con turbo palette
p3<-ggplot()+
geom_raster(pc1_sd5, mapping=aes(x = x, y = y, fill = layer))+
scale_fill_viridis(option="turbo")+
ggtitle("Standard deviation of PC1 by turno color scale")

grid.arrange(p1, p2, p3, nrow=3)

#mentre viridis e magma portano valori a maggior contrasto verso i valori maggiori, la legenda turbo ha il giallo nei valori medi (e l'occhio umano lo considera come max)







