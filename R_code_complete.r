#############################################
#### R_code_complete.r / Telerilevamento ####
#############################################

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#############
## Summary ##
#############

# 1. Remote sensing first code
# 2. Time series greenland
# 3. Copernicus data
# 4. Knitr
# 5. Analisi multivariata
# 6. Classificazione
# 7. ???? ggplot ????
# 8. Indici di Vegetazione
# 9. Land Cover
# 10. Variabilità
# 

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

#############################
## 5. Analisi multivariata ##
#############################

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

########################
## 6. Classificazione ##
########################

library(raster)
library(RStoolbox)
setwd("/Users/federicotossani/lab/")

#per prima cosa carico l'immagine con a funzione brick. uso brick perchè l'immagine è già creata, i 3 livelli rgb sono già uniti nell'immagine.
so<-brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
so
#riscrivo il nome per ottenere una descrizione dell'oggetto importato.

#visualizzo la nostra immagine tramite la funzione plotRGB

plotRGB(so, 1,2,3, stretch="lin")
#plotRGB(so, 1,2,3, stretch="hist")

#Iniziamo con la classificazione!!
#i punti iniziali per la classificazione (training site) li recupera direttamente il software.
#per questo motivo si definisce "Unsupervised classification"
#la funzione utilizzata è unsuperClass, tra gli argomenti della funzione abbiamo:
#il numero del file da usare, il numero di pixel da usare come training site, il numero di classi

set.seed(42)
soc<-unsuperClass(so, nClasses=3)
soc

plot(soc$map)
#per legare un pezzo ad un oggetto più generale uso sempre il dollaro! in questo caso soc oltre alla map contiene anche il modello etc

set.seed(42)
soc20<-unsuperClass(so, nClasses=20)
plot(soc20$map)

#nella supervised classification invece si vanno a selezionare i singoli pixel
#nelle object oriented si vanno a distinguere anche le forme

sun<-brick("sun.png")
set.seed(42)
sunc<-unsuperClass(sun, nClasses=3)

plot(sunc$map)

#classificazione con 10 classi
set.seed(42)
sunc10<-unsuperClass(sun, nClasses=10)

plot(sunc10$map)


#se devo classificare un'immagine con le nuvole ho 3 modi per poterle eliminare:
#1_alcuni dati hanno anche un file masked, una mascare che mi permette di eliminare alcuni errori. facendo una sottrazione dal mio file originale otterro un file pulito, ma con dei buchi dove sono stati eliminati gli errori.
#2_faccio ugualmente la classificazione ma spiego che in quella zona ci sono nuvole che alterano la classificazione.
#3_cambio il tipo di sensore! fino ad ora abbiamo usato i passivi, se invece uso quelli attivi (che emettono loro stessi energia) 

######################
#### Grand Canyon ####
######################
library(raster)
library(RStoolbox)
setwd("/Users/federicotossani/lab/")

#il primo passo come sempre è quello di caricare le library e settare la working directory.
#iniziamo poi con l'importazione dell'immagine con la funzione brick. brick infatti ci permette di caricare immagini satellitari già pronte, con le bande impacchettate.

gc<-brick("dolansprings_oli_2013088_canyon_lrg.jpg")
#plotRGB(GC, 1, 2, 3, stretch="lin")
#plotRGB(GC, 1, 2, 3, stretch="hist")

gcc2<-unsuperClass(GC, nClasses=2)
gcc2
plot(gcc2$map)

#quello che stiamo facendo è un modello di classificazione. avremo le info sulle singole classi, la mappa etc.
#siccome siamo interessati alla mappa in uscita dobbiamo legare con il $ map nell'argomento della funzione plot.

gcc4<-unsuperClass(GC, nClasses=4)
gcc4
plot(gcc4$map)

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

##############################
## 8. Indici di Vegetazione ##
##############################

library(raster) #require(raster)
require(RStoolbox) #for vegetation indeces calculation
require(rasterdiv) #install.packages("rasterdiv")
require(rasterVis)
#require fa la stessa cosa di library, ma fa più figo
setwd("/Users/federicotossani/lab/")

defor1<-brick("defor1.jpeg")
defor2<-brick("defor2.jpeg")

#b1= NIR, b2=red, b3=green

par(mfrow=c(2,1))
plotRGB(defor1, 1,2,3, stretch="lin")
plotRGB(defor2, 1,2,3, stretch="lin")

#nel plot si nota ad esempio che il fiume ha due colori diversi, questo è dato dal fatto che nella prima immagine l'acqua ha un contenuto di solidi sciolti molto maggiore rispetto alla seconda immagine.
#questo si capisce dal fatto che l'acqua è chiara, assorbendo molto nell'infrarosso il suo colore teoricamente è scuro, se è acqua pura diventa nera!!

#tutta la parte rossa è la vegetazione, la parte chiara è suolo agricolo, suolo nudo e le patch rosse sono suolo agricolo vegetato.

#NDVI è uno dei principali indici di vegetazione.
#le piante in genere riflettono molto nel NIR e assorbe il rosso, quando il rosso assorbe la foglia solo una piccola parte viene riflessa. 
#se nell'immagine satellitare ho un pixel con vegetazione ho la possibilità di misurare quanto è sana la vegettazione.

#DVI= NIR - red
#il range possibili va da 255 a -255. il valore negativo indica assenza di vegetazione viva.

#c'è la possibilità di normalizzare l'indice attraverso il rapporto con la somma NIR + red.

##############
#### DVI1 ####
##############

defor1
#scrivo il nome del file per vederne il contenuto, in particolare il nome delle bande!

dvi1 <- defor1$defor1.1 - defor1$defor1.2

#questa operazione altro non è che il NIR - red. in ogni pixel dell'immagine stiamo andando a fare questa sottrazione e creare poi una mappa

plot(dvi1)

cl <- colorRampPalette(c("dark blue", "yellow", "red", "black"))(100)

plot(dvi1, col=cl, main="DVI at time zero")

#ripetiamo lo stesso calcolo per defor2

##############
#### DVI2 ####
##############

dvi2 <- defor2$defor2.1 - defor2$defor2.2

plot(dvi2)

cl2 <- colorRampPalette(c("dark blue", "yellow", "red", "black"))(100)

plot(dvi2, col=cl2, main="DVI at time 1")

#andiamo a vedere le differenze confrontando le 2 immagini con par

par(mfrow=c(2,1))
plot(dvi1, col=cl, main="DVI at time 1")
plot(dvi2, col=cl2, main="DVI at time 2")

#se vogliamo vedere la differenza nei 2 tempi possiamo fare la sottrazione tra i 2 dvi.
#se il dvi è calato nella prima mappa dovrei avere un valore alto (255), nella seconda mappa un valore basso (20). se faccio 255-20=235.
#

diffdvi <- dvi1 - dvi2
cld<-colorRampPalette(c("blue","white","red"))(100)
plot(diffdvi, col=cld)

#nel risultato ottenuto avremo la colorazione rossa dove la differenza è maggiore, dove è minore ci sarà prima il bianco e poi il blu.
#in poche parole dove la differenza è maggiore sono i luoghi in cui la vegetazione ha sofferto maggiormente.

#la stessa cosa vale con l'NDVI
#questo spesso è più usato del DVI perchè quando si vanno a confrontare immagini a diversi bit (ad esempio una 8 con una a 16) risulta impossibile vista la diversa risoluzione radiometrica.
#per questo è nato il NADVI che normalizza i valori sulla somma delle variabili.
#questo procedimento fa si che indipendentemente dal numero di bit il range dell'NDVI va da -1 (valore minimo, con vegetazione morta) a 1 (valore massimo, con vegetazione rigogliosa)

############
### NDVI ###
############

ndvi1 <- dvi1 / (defor1$defor1.1 + defor1$defor1.2)
ndvi2 <- dvi2 / (defor2$defor2.1 + defor2$defor2.2)

# cl <- colorRampPalette(c("dark blue", "yellow", "red", "black"))(100)
par(mfrow=c(2,1))
plot(ndvi1, col=cl, main="NDVI at time 1")
plot(ndvi2, col=cl, main="NDVI at time 2")

#posso usare il dvi come primo blocco dell'operazione, come fatto qui sopra. il problema è che se passo il codice a qualcuno che non ha calcolato il dvi non ottiene il risultato.

# nel pacchetto RStoolbox ci sono già una serie di indici, tra cui l'ndvi e il SAVI. questo è un indice che prende in considerazione l'influenza del suolo nella riflettanze di un'immagine.
# la funzione che calcola questi indici è spectralIndicies

vi1<-spectralIndices(defor1, green = 3, red = 2, nir = 1)
plot(vi1, col=cl)

vi2<-spectralIndices(defor2, green = 3, red = 2, nir = 1)
plot(vi2, col=cl)

#alcuni indici necessitano del redEdge. il redEdge, nel grafico della firma spettrale, è la slope/pendenza tra la banda del rosso (valore basso) e quella del NIR (valore alto).
#più è alta la pendenza e più sana è la vegetazione. Se la veg sta morendo, quindi non assorbe il rosse e inizia ad assorbire il NIR la slope si abbassa.
difndvi<-ndvi1-ndvi2
plot(difndvi, col=cl)

#la vera crisi sta nelle aree rosse, è li dove c'è stata la perdita!

##### proviamo adesso a plottare l'NDVI dal pacchetto rasterdiv
plot(copNDVI)

#in questo plot vogliamo togliere di mezzo tutta la parte che comprende acqua.
#questo lo possiamo fare con la funzione cbind, che permette di eliminare/cambia dei valori
copNDVI<-raster::reclassify(copNDVI, cbind(253:255, NA)) 
#il :: serve per legare la funzione al suo pacchetto, un po' come il dollaro. questo non serve per forza, si fa per rendere noto a chi legge il codice il pacchetto da cui proviene la funzione.
  
cbind(253:255, NA) # i : indicano da...a...

levelplot(copNDVI)

#NDVI non è relazionata al tipo di landcover, fa solo riferimento alla biomassa. 
#l'immagine ottenuta dal levelplot fa vedere come respira la terra, sono i valori media dal '99 al 2017.

#i picchi di biomassa li abbiamo nelle foreste di N America e N Europa e all'equatore.
#All'equatore abbiamo i valori massimi perchè qui c'è il max di luce.

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

###################
## 9. Land Cover ##
###################

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

#trovate le frequenze possiamo fare una proporzione.

s1<-305970+35322

#frequenza pixel di forests
prop1<-freq(d1c$map)/s1
#nella colonna count vediamo che la parte di foresta è 89,65% mentre 10,34% è la parte agricola.

s2<-342726
prop2<-freq(d2c$map)/s2
#            value     count
#[1,] 2.917783e-06 0.4792254
#[2,] 5.835565e-06 0.5207746

#nella mappa relativa al 2006 la situazione è molto diversa, la foresta (classe 2) è scesa al 52,07% mentre la zona agricola è il 47,92%

#la percentuale citata nei commenti è stata ottenuta moltiplicando per 100 i valori nella colonna count delle proporzioni.


#ora generiamo un dataframe
#metteremo nella prima colonna i fattori (variabili categoriche), nel nostro caso foresta e zona agricola.
#la seconda e la terza colonna conterranno le percentuali di copertura nei 2 anni(1992 e 2006)

cover<-c("Forest", "Agriculture")
percent_1992<-c(89.65, 10.34)
percent_2006<-c(52.07, 47.92)

#dopo aver assegnato i valori che ci interessano ai nomi delle colonne usiamo la funzione data.frame per ottenere la tabella.

df<-data.frame(cover, percent_1992, percent_2006)
df

#         cover percent_1992 percent_2006
# 1      Forest        89.65        52.07
# 2 Agriculture        10.34        47.92

#ottenuto il data frame facciamo un grafico migliore con ggplot2

# la funzione da usare è proprio ggplot e comprende il data set (mpg) e la parte estetica (aes). in quest'ultima parte spieghiamo la prima colonna, la seconda colonna e il tipo di colore.
# serve poi la funzione geom-... che indica il tipo di grafico, geom_bar è tipo istogramma, geom_point invece usa una nuvola di punti.
p1<-ggplot(df, aes(x=cover, y=percent_1992, color=cover))+geom_bar(stat="identity", fill="light blue")
#l'argomento color serve a strutturare la legenda del grafico
p2<-ggplot(df, aes(x=cover, y=percent_2006, color=cover))+geom_bar(stat="identity", fill="light blue")

grid.arrange(p1, p2, nrow=1)
#la funzione grid arrange ci permette di organizzare più grafici in un'unica finestra così da poterli confrontare.

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#####################
## 10. Variabilità ##
#####################

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

