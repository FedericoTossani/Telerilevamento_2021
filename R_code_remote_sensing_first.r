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

plot(p224r63_2011)

#uso il comando ColorRampPalette per cambiare la scala di colori visualizzata in un grafico

cl <- colorRampPalette(c("black","grey","light grey")) (100)

#per spiegare ad R che sono tutti elementi della stessa cosa li dobbiamo racchiudere in un array.
#la c davanti alle parentesi indica una serie di elementi appartenti allo stesso array.
#100 indica il numero di livelli tra il nero e il grigio chiaro, va tenuto esterno alla funzione colorRampPalette.

#ora richiamo il plot di prima per vedere se i colori sono cambiati. Questa volta però nella funzione devo aggiungere un secondo elemento
#il primo rimane la nostra immagine p224r63_2011, il secondo argomento è la scala di colori appena creata. è importante dare dei nomi alle funzioni per poter semplificare le formule in cui vanno usate.
#nei vari argomenti all'interno della funzione posso lasciare lo spazio oppure no, a mio piacere. l'importante è mettere la virgola tra gli argomenti.

plot(p224r63_2011, col=cl)

#new color change
cl <- colorRampPalette(c("red","orange","yellow", "white")) (100)
plot(p224r63_2011, col=cl)

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

plot(p224r63_2011$B1_sre)

#plottare la banda 1 con una diversa colorRampPalette

clr<-colorRampPalette(c("red", "yellow", "green")) (200)
plot(p224r63_2011$B1_sre, col=clr)

#usiamo adesso la funzione par per fare un settaggio dei parametri grafici di un certo grafico che vogliamo creare.
#nel nostro caso ci serve per fare un multiframe (mf)

#par(mfrow=c(1,2))

#essendo che abbiamo 2 blocchi (1 e 2) dobbiamo racchiuderli nel vettore c.
#questa funzione prepara i futuri grafici in un predefinito formato. A noi serve per paragonare 2 bande una di fianco all'altra.

par(mfrow=c(1,2))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)





