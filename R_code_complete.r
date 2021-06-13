#############################################
#### R_code_complete.r / Telerilevamento ####
#############################################

#--------------------------------------------
# Summary
# 1. Remote sensing first code
# 2. Time series greenland
# 3. Copernicus data
# 4. Knitr
# 5.
# 6.

#--------------------------------------------
##################################
## 1. Remote sensing first code ##
##################################

# My first code in R for remote sensing!

setwd("/Users/federicotossani/lab/")

#setwd è la funzione che mi permette di localizzare la cartella in cui trovare i file che mi servono. wd = working directory.
#quando la uso in R ho bisogno di ("..."), al suo interno metto il path per trovare la cartella. le virgolette servono quando cerco cose esterne ad R.
#una regola importante è che fra la funzione e la parentesi non vanno messi spazi, come anche il percorso va scritto senza spazi! NON USARE SPAZI

# brick("...")

#è la funzione per caricare dati in R. Va a importare i dati raster che abbiamo a disposizione. i dati raster sono dati dalla composizione di più bande (1 per ogni sensore).
#i pixel dell'immagine quindi saranno a loro volta composti da più dati (1 per ogni banda), nel nostro caso parliamo di riflettanza.
#la funzione brick è all'interno del pacchetto raster. quindi dobbiamo richiamare il pacchetto, che è già all'interno di R, prima di poter usare la funzione brick("...").
#per richiamre i pacchetti serve la funzione library.

library(raster)

#la funzione brick la associamo al nome p224r63_2011

p224r63_2011 <- brick("p224r63_2011_masked.grd")
p224r63_2011

#il file è dato da una serie di bande in formato raster. le dimensioni sono di 1499 (numero di righe), 2967 (num di colonne), 4447533 (numero di celle, di pixel) e 7 (numero di layer)
#la risoluzione è di 30mx30m, è il satellite landsat.
#le bande, sre sta per spectral reflectance. la banda 6 è la banda termica.
#il numero totale di pixel è dato da 4447533 x 7 (ogni banda)
#B1=Blu, B2=verde, B3=rosso, B4=NIR, oggetti che riflettono di più hanno valori più alti, mentre oggetti che assorbono di più hanno valori più bassi.
#nella B4 le piante hanno valori molto alti perchè riflettono molto.

#plot è la funzione che serve per visualizzare i dati. non servono le virgolette perchè l'oggetto è già dentro a R.

#plot(p224r63_2011)

#uso il comando ColorRampPalette per cambiare la scala di colori visualizzata in un grafico

cl <- colorRampPalette(c("black","grey","light grey")) (100)

#per spiegare ad R che sono tutti elementi della stessa cosa li dobbiamo racchiudere in un array.
#la c davanti alle parentesi indica una serie di elementi appartenti allo stesso array.
#100 indica il numero di livelli tra il nero e il grigio chiaro, va tenuto esterno alla funzione colorRampPalette.

#ora richiamo il plot di prima per vedere se i colori sono cambiati. Questa volta però nella funzione devo aggiungere un secondo elemento
#il primo rimane la nostra immagine p224r63_2011, il secondo argomento è la scala di colori appena creata. è importante dare dei nomi alle funzioni per poter semplificare le formule in cui vanno usate.
#nei vari argomenti all'interno della funzione posso lasciare lo spazio oppure no, a mio piacere. l'importante è mettere la virgola tra gli argomenti.

#plot(p224r63_2011, col=cl)

#new color change
#cln <- colorRampPalette(c("red","orange","yellow", "white")) (100)
#plot(p224r63_2011, col=cln)

#Landsat band
#B1: blu
#B2: green
#B3: red
#B4: NIR
#B5: Middle IR
#B6: Termic IR
#B7: Middle IR

dev.off()

#dev.off pulisce la finestra grafica, così che tutte le impostanzioni ripartano da zero.

#il simbolo del dollaro $ in R viene sempre usato per legare 2 pezzi, nel nostro caso la banda 1 all'immagine satellitare.
#se voglio plottare solo la banda 1 uso sempre la funzione plot, ma nelle parentesi metto:

#plot(p224r63_2011$B1_sre)

#plottare la banda 1 con una diversa colorRampPalette

clr<-colorRampPalette(c("red", "yellow", "green")) (200)
#plot(p224r63_2011$B1_sre, col=clr)

#usiamo adesso la funzione par per fare un settaggio dei parametri grafici di un certo grafico che vogliamo creare.
#nel nostro caso ci serve per fare un multiframe (mf)

#par(mfrow=c(1,2))

#essendo che abbiamo 2 blocchi (1 e 2) dobbiamo racchiuderli nel vettore c.
#questa funzione prepara i futuri grafici in un predefinito formato. A noi serve per paragonare 2 bande una di fianco all'altra.

#par(mfrow=c(1,2))
#plot(p224r63_2011$B1_sre)
#plot(p224r63_2011$B2_sre)

#in questo modo ho un grafico con 1 riga e 2 colonne, se voglio il contrario basta che inverto i numeri nella parentesi.

#ora plottiamo le prime 4 bande di Landsat

par(mfrow=c(2,2))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)

#rifacciamo il plot precedente ma con una colorRampPalette specifica di ogni banda.
par(mfrow=c(2,2))
clb<-colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(p224r63_2011$B1_sre, col=clb)
clg<-colorRampPalette(c("dark green", "green", "light green"))(100)
plot(p224r63_2011$B2_sre, col=clg)
clr<-colorRampPalette(c("dark red", "red", "pink"))(100)
plot(p224r63_2011$B3_sre, col=clr)
cli<-colorRampPalette(c("violet", "purple", "pink"))(100)
plot(p224r63_2011$B4_sre, col=cli)

#dovendo fare un plot riassuntivo il comando par è ottimo perchè ci permette di decidere come far plottare le immagini in un'unica finestra


##### COPIA CODICE DA QUA ####
##### COPIA CODICE DA QUA ####


#proveremo adesso ad unire più bande in un'unico plot, per vedere il mondo con occhi diversi.

###Visualizing data by RGB plotting###
library(raster)
setwd("/Users/federicotossani/lab/")
p224r63_2011 <- brick("p224r63_2011_masked.grd")

#Landsat band
#B1: blu
#B2: green
#B3: red
#B4: NIR
#B5: Middle IR
#B6: Termic IR
#B7: Middle IR

#ogni schermo ha uno schema fisso per mostrare i colori, lo schema RGB. Ci sono dei colori di base Red, Green e Blue mischiando i quali si ottengono tutti gli altri.
#Possiamo usare le nostre bande Landsat per ottenere diverse visualizzazione nello schema RGB. La condizione è quella di usare solo 1 banda per ogni componente. RGB=3 componenti.
#Posso usare solo 3 bande per volta. Per ottenere una foto che rispecchia i colori visibili dall'occhio umano vanno rispettate le 3 componenti.
#R=B3 (banda del rosso), G=B2 (banda del verde), B=B1 (banda del blu). per fare questo abbiamo bisogno di una funzione plotRGB. 


#plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")

#mettiamo nella funzione anche l'elemento stretch. questo prende la riflettanza delle singole bande e la "tira" nelle varia direzione per evitare che ci sia una banda preponderante. 

#l'immagine ottenuta si chiama "immagine a colori naturali"

#proviamo a muovere le bande di 1.
plotRGB(p224r63_2011, 4, 3, 2, stretch="Lin")

#provo a confrontare i 2 plot RGB con la funzione par

par(mfrow=c(2,1))
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, 4, 3, 2, stretch="Lin")

#siccome abbiamo montato la B4 nella componente R di RGB e la vegetazione ha un'altissima riflettanza nel NIR, tutto quello che è vegetazione prende il colore Red.
#lo stesso gioco si può fare con i minerali.

#sposto il NIR nella componente green
plotRGB(p224r63_2011, 3, 4, 2, stretch="Lin")
#quando plottiamo un RGB con le bande disposte in questa maniera risultano più evidenti alcune info come ad esempio corsi d'acqua interni alla foresta oppure il suolo nudo, visibile in viola.
#Il viola è la componente agricola, in questo caso.

plotRGB(p224r63_2011, 3, 2, 4, stretch="Lin")


### RIEPILOGO ###
par(mfrow=c(2,2))
plotRGB(p224r63_2011, 3, 2, 1, stretch="Lin")
plotRGB(p224r63_2011, 4, 3, 2, stretch="Lin")
plotRGB(p224r63_2011, 3, 4, 2, stretch="Lin")
plotRGB(p224r63_2011, 3, 2, 4, stretch="Lin")

#per creare un pdf con i grafici appena creati va aggiunta la funzione pdf prima della serie di funzioni scritte in precedenza. come qui sotto.
pdf("first_pdf.pdf")
par(mfrow=c(2,2))
plotRGB(p224r63_2011, 3, 2, 1, stretch="Lin")
plotRGB(p224r63_2011, 4, 3, 2, stretch="Lin")
plotRGB(p224r63_2011, 3, 4, 2, stretch="Lin")
plotRGB(p224r63_2011, 3, 2, 4, stretch="Lin")
dev.off()

#la funzione pdf ha moltissimi argomenti da poter inserire nella funzione, grandezza, risoluzione etc.

#proviamo a modificare lo stretch. passiamo da lin a hist
par(mfrow=c(2,2))
plotRGB(p224r63_2011, 3, 2, 1, stretch="hist")
plotRGB(p224r63_2011, 4, 3, 2, stretch="hist")
plotRGB(p224r63_2011, 3, 4, 2, stretch="hist")
plotRGB(p224r63_2011, 3, 2, 4, stretch="hist")

#lo stretch ottenuto con hist permette di aumentare ulteriormente la possibilità di guardare all'interno della foresta. In particolare sono messe in evidenza le zone più umide.

#mettiamo ora un par con 3 immagini, colori naturali e falsi colori sia con stretch lin che hist
par(mfrow=c(3,1))
plotRGB(p224r63_2011, 3, 2, 1, stretch="Lin")
plotRGB(p224r63_2011, 3, 4, 2, stretch="Lin")
plotRGB(p224r63_2011, 3, 4, 2, stretch="hist")

#i colori sono quelli delle rilettanze!! non possiamo mettere una legenda da valori bassi ad alti. sono effettivamente dei colori reali, dati dalla sovrapposizione di più livelli.

###colorist package!!! pacchetto figo per capire la distribuzione di una specie nel tempo. nelle componente RGB si caricano le foto di 3 periodi diversi.
#in base al colore finale del plot si capisce in quale periodo dell'anno la specie ha più sviluppo.


#in generale per gli studi di vegetazione si usa l'IR sulla componente Red di RGB. però non c'è una visualizzazione migliore di altre.

#è importante e potente avere uno stesso satellite per lunghi periodi. Landsat è stato lanciato nel '72, ormai abbiamo 50 anni di dati.

#Multitemporal analysis
#ora andiamo ad inserire, con la funzione brick, la foto dell'88 e quella del 2011 usata fino ad ora

p224r63_1988<-brick("p224r63_1988_masked.grd")
p224r63_1988

#ora plottiamo l'intera immagine con la funzione plot per visualizzare le singole bande.
plot(p224r63_1988)
#attraverso la funzione plotRGB andiamo ad assegnare alla componenti RGB le bande dell'immagine satellitare
plotRGB(p224r63_1988, r=3, g=2, b=1, stretch="lin")
#per sapere come riampire la funzione si può sempre andare a vedere sul sito rdocumentation la descrizione della funzione.
#vado ad aggiungere lo stretch per poter visualizzare meglio i dati dell'immagine.
#nel plot il colore violetto è una parte di haze, corpuscoli che riflettono alcune lunghezze d'onda. un po' come l'effetto del sole nelll'obiettivo di una macchina fotografica.
#ovviamente le correzione dell'88 non sono come le attuali, di conseguenza non sono stati tolti questi effetti.

#se adesso vogliamo aggiungere il NIR lo dobbiamo sostituire ad una banda, in particolare lo inserisco nella banda del rosso.

plotRGB(p224r63_1988, r=4, g=3, b=2, stretch="lin")

#attraverso la funzione par faccio uno schema 2,1 con le immagini dell'88 e del 2011.
par(mfrow=c(2,1))
plotRGB(p224r63_2011, 4, 3, 2, stretch="lin")
plotRGB(p224r63_1988, 4, 3, 2, stretch="lin")

#se utilizziamo lo stretch hist mettiamo in evidenza le zone umide.

par(mfrow=c(2,2))
plotRGB(p224r63_1988, 4, 3, 2, stretch="lin")
plotRGB(p224r63_2011, 4, 3, 2, stretch="lin")
plotRGB(p224r63_1988, 4, 3, 2, stretch="hist")
plotRGB(p224r63_2011, 4, 3, 2, stretch="hist")

#hist utilizza una curva sinusoide (o funzione logistica). avendo una pundenza maggiore ha un effetto grafico maggiore.
#la differenziazione tra rocce, o sabbie ad esempio. la granulometria influenza molta riflettanza ma con il lineare non si vede la differenza tra sabbia e argille, ma con un hist si può apprezzare.

#in questo plot si può apprezzare il cambiamento delle zone di passaggio dalla componente vegetale alla componente umana. Nel 2011 invece è proprio una soglia netta tra la foresta pluviale e l'impatto umano.

#per fare un pdf di questo plot basta inserire la funzione pdf prima del codice del plot
pdf("second_pdf.pdf")
par(mfrow=c(2,2))
plotRGB(p224r63_1988, 4, 3, 2, stretch="lin")
plotRGB(p224r63_2011, 4, 3, 2, stretch="lin")
plotRGB(p224r63_1988, 4, 3, 2, stretch="hist")
plotRGB(p224r63_2011, 4, 3, 2, stretch="hist")
dev.off()

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

##############################
## 2. Time series greenland ##
##############################

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

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

########################
## 3. Copernicus data ##
########################

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

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

##################
#### 4. Knitr ####
##################

library(knitr)
setwd("/Users/federicotossani/lab/")

stitch("R_code_greenland.txt", template=system.file("misc", "knitr-template.Rnw", package="knitr"))

#prima di tutto apro il codice di cui mi interessa fare il report e lo salvo nella cartella (lab ne nostro caso).
#il primo argomento di stich è il nome del file contenente il codice e la sua estensione.
#in questo modo leggerà automaticamente tutto il codice e creerà il report.
#il template è l'altro argomento che ci ha fornito riettamente il prof
#l'ultimo è il tipo di pacchetto che andiamo ad utilizzare

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

##################################
# con al PCA abbiamo generato delle nuove componenti che diminuiscono l'iniziale forte correlazione tra le bande e con un numero minore di componenti possiamo spiegare tutta l'immagine originale.
#è importante fare analisi multivariata quando ad esempio facciamo una funzione lineare (distribuzione di una specie). Se usiamo le temperature (min, max etc) sono tutte correlate tra loro.
#molti modelli lineari presuppongono che le variabili non siano correlate tra loro. Quando questo lo sono infatti si aumenta la potenza del modello con il rischio di ottenere buoni risultati che in realtà sono falsati da questo fatto.

#riprendi da lezione del 28/04 al min 1:11:00

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

















