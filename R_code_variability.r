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
cl <- colorRampPalette(c("green","yellow","orange","red","white", "black"))(100)
plot(ndvi, col=cl)

#questo plot ci permette di apprezzare i diversi livelli di ndvi.

ndvi_sd3<-focal(ndvi,w=matrix(1/9, nrow=3, ncol=3), fun=sd)
#la funzione focal mi permette di fare diversi calcoli statistici per mezzo della moving window
#gli argomenti nella funzione sono: il nome dell'immagine, la matrice (è la moving window) questa più è grande più pixel prende in considerazione e più lungo sarà il calcolo.
#1/9 significa che prendi in considerazione ogni pixel sui 9 della matrice.

plot(ndvi_sd3,col=cl)

#####################
# lez 19/05 min 1:00:00


















 


