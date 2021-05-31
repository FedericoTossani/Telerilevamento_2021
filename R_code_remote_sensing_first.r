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










