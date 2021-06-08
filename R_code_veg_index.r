###################################
#### Indici di Vegetazioneeeee ####
###################################

library(raster)
#require(raster)
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

#### DVI1 ####
defor1
#scrivo il nome del file per vederne il contenuto, in particolare il nome delle bande!

dvi1 <- defor1$defor1.1 - defor1$defor1.2

#questa operazione altro non è che il NIR - red. in ogni pixel dell'immagine stiamo andando a fare questa sottrazione e creare poi una mappa

plot(dvi1)

cl <- colorRampPalette(c("dark blue", "yellow", "red", "black"))(100)

plot(dvi1, col=cl, main="DVI at time zero")

#ripetiamo lo stesso calcolo per defor2

#### DVI2 ####
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





