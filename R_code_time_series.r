#Time series analysis
#Greenland increase of temperature
#Data and Code from Emanuela Cosma

library(raster)
library(rasterVis)
setwd("/Users/federicotossani/lab/greenland")

#oggi andiamo a creare uno stack, ovvero un insieme di dati. Nel nostro caso saranno raster.
#fino ad ora abbiamo importato i file singoli con la funzione brick. adesso però ne abbiamo 4, di conseguenza non possiamo usare brick.
#ogni strato in questo caso rappresenta la stima della temperatura superficiale (lst) che deriva dal programma copernicus.

#i nostri dati mostra la temperature media dei primi 10gg di giugno nei 4 anni.
#la funzione per caricare singoli strati è raster, non più brick.

 lst_2000 <- raster("lst_2000.tif")

#in questa lezione andremo anche a creare un ciclo, ovvero un movimento iterativo di funzioni.
 
lst_2000
#scrivo il nome per vedere il contenuto del file

plot(lst_2000)
#plot mi permetti di visualizzare l'immagine
 
#rgdal è la parte di r di una libreria che di nome gdal. è una libreria di tutti file raster.

lst_2005 <- raster("lst_2005.tif")
plot(lst_2005)

#la scala graduta: le immagini sono codificate in bit. la riflettanza viene espressa tra 0 e 1. altri tipo di set hanno altri formati, tra cui bit. molte immagini sono a 8 bit.
#avere un file che restra i singoli decimali della temperatura sarebbe molto pesante. la immagini che usiamo pesano qualche mega.
#invece di usare i decimali si usano i valori interi e per passare da una scala decimale ad una intera si usano i bit.
#DN=digital numbers. 
#2 elevato al numero di bit mi da il numero totale di possibili valori (interi) da associare ad un pixel. con 1 bit ho 2 possibili valori. con 2 bit ho 4 possibili valori etc.
#molte immagini sono a 8 bit, quindi abbiamo 256 valori possibili (2^8). le immagini a 16 bit hanno 65535 possibili valori, proprio come quelle che stiamo usando adesso.
#questo ci permette di non avere i decimali e in alcuni punti ci saranno dei valori ripetuti, permettendo di ridurre il peso finale dell'immagine
#magiore sarà il valore del DN maggiore sarà la temperatura dell'area.

 lst_2010 <- raster("lst_2010.tif")
 lst_2015 <- raster("lst_2015.tif")

#uso par per fare un panel di 2x2 con le 4 immagini importate.
par(mfrow=c(2,2))
plot(lst_2000)
plot(lst_2005)
plot(lst_2010)
plot(lst_2015)

#la funzione chiave che andremo ad utilizzare è lapply, che ci permetterà di applicare una certa funzione (nel nostro caso raser) ad una lista di file.
#ad esempio si può applicare raster a tutta la lista di file con "lst" nel nome, non a un file alla volta.
#per fare la lista di file si usa la funzione list.files. i parametri importanti sono_:il path (solo se non si è già fatta la working directory)
#anche il pattern è importante, è questo il parametro che ci permette di trovare i file di interesse grazie ad un nome comune.

rlist<-list.files(pattern="lst")

import<-lapply(rlist, raster)
import

#scrivo import così vedo la descrizione di cosa ho importato.
#una volta importati i file posso raggrupparli in un'unico file. questo è permesso dalla funzione stack.

TGr<-stack(import)
plot(TGr)

#così facendo evito di fare il plot con par. facendo lo stack è molto più rapido!

plotRGB(TGr, 1, 2, 3, stretch="lin")
#con il plotRGB vediamo una sovrapposizione di 3 immagini, 2000-2005-2010. Siccome sulla componente green abbiamo messo il 2005.
#se ho dei colori verdi ho dei valori più alti di lst nel 2005, se i colori sono rossi ho un lst più alto nel 2000, se ho colori blu ho dei valori più alti di lst nel 2010.

plotRGB(TGr, 2, 3, 4, stretch="lin")
plotRGB(TGr, 4, 3, 2, stretch="lin")

#prima di continuare va installato il pacchetto rasterVis, che ci permette di fare un level plot.
#in pratica si occupa di metodi di visualizzazione dei dati raster.

levelplot(TGr)

#per poterlo fare con solo una mappa uso il simbolo $ seguito dal nome del file. il dollaro lega lo strato dello stack allo stack stesso.

levelplot(TGr$lst_2000)
#con il plot di un singolo file ai lati dell'immagine ci sono dei grafici. questi grafici riportano il valore medio di lst della colonna o della riga.

#possiamo usare la colrRampPalette, perchè non è un'immagine RGB! in questo caso sono immagini singole.

cl <- colorRampPalette(c("white", "light blue", "yellow", "orange", "red")) (100)
levelplot(TGr, col.regions=cl)

#con la funzione levelplot quando si cambiano i colori bisgona scrivere col.regions.
#la differenza con il plot normale è che il levelplot ha una gamma di colori molto maggiore ed ha un outpot migliore.

#cambiare i titoli!!

#i singoli strati di un'immagine stack sono gli attributi. quindi abbiamo 4 attributi (i vari lst). il nostro levelplot lo possiamo cambiare nominando in modo diverso gli attributi.

levelplot(TGr, col.regions=cl, main="Grennland LST variation in time", names.attr=c("July 2000", "July 2005", "July 2010", "July 2015"))

#passiamo adesso ai dati sulle scioglimento!!!

meltlist<-list.files(patter="melt")
meltlist

meltimp<-lapply(meltlist, raster)

melt<-stack(meltimp)
clm <- colorRampPalette(c("white", "light blue", "yellow", "orange", "red")) (100)
levelplot(melt, col.regions=clm)

levelplot(melt, col.regions=clm, main="Greenland annual melt 1979-2007")

#procediamo adesso con la matrix algebra!!
#useremo le immagini del '79 e 2007 per vedere la differenza nello scioglimento.
#facciamo 2007-1979 più sarà alto il risultato maggiore sarà stato lo scioglimento

melt_amount<- melt$X2007annual_melt - melt$X1979annual_melt

clb <- colorRampPalette(c("blue", "white", "red")) (100)
levelplot(melt_amount, col.regions=clb)

#le zone rosse sono quelle dove c'è stato il maggior scioglimento. come indicato dai grafici a bordo immagine c'è un picco in corrispondenza del lato ovest.

#inizia da lezione del 14/04












