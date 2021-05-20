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

#plot è la funzione che serve per visualizzare i dati. non servono le virgolette perchè l'oggetto è già dentro a R.

plot(p224r63_2011)

