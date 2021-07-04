# R_code_spectral_signature.r

require(raster)
require(ggplot2)
require(rgdal)

setwd("/Users/federicotossani/lab/")

#carichiamo il dataset, è lo stesso della deforestazione

defor2<-brick("defor2.jpeg")
#uso brick perchè mi serve caricare tutte le bande
#defor2.1, defor2.2, defor2.3 
#NIR, red e green

plotRGB(defor2, 1, 2, 3, stretch="lin")
plotRGB(defor2, 1, 2, 3, stretch="hist")
#lo stretch hist mi permette di accentuare le differenze

#adesso creeremo delle firme spettrali, per farlo useremo la funzione click che ci permette di cliccare un punto dell'immagine ed estrarne la firma.
#in generale click serve per estrarre le informazioni contenute in un punto della mappa, nel nostro caso saranno informazioni relative alla riflettanza ma se la usiamo sul suolo nudo ci darà il timpo di suolo etc.
 
click(defor2, id=T, xy=T, cell=T, type="p", pch=16, cex=4, col="blue")
#il primo argomento è la mappa sulla quale usare la funzione, id invece ci chiede se vogliamo creare un id (valore identificativo) per ogni punto, xy significa che vogliamo usare le info spazialy
#cell va impèostato su T perchè cliccheremo sui pixel(celle), type indica il tipo di click che faremo (p=punto), pch è il tipo di punto che andremo a fare cerchio, croce, triangolo etc

#       x     y   cell defor2.1 defor2.2 defor2.3
# 1 341.5 231.5 176724      221        9       23
#       x     y   cell defor2.1 defor2.2 defor2.3
# 1 415.5 107.5 265706       46       83      163

#qui sopra ci sono i valori di 2 pixel presi a caso sulla mappa. Nel primo ho cliccato sul una parte di foresta, nel secondo invece sul fiume.
#appare chiara la differenza nella firma spettrale, la vegetazione come abbiamo detto più volte rifletto molto nel NIR, molto poco nel RED e un po' di più nel GREEN.
#L'acqua invece assorbe nel NIR, riflette un po' nel RED e rifletto molto nel GREEN. se ci fosse stato anche il blu avremmo avuto una riflettanza ancora maggiore. 

#procediamo adesso alla creazione di un dataframe
#iniziamo con la creazione delle colonne.
#la prima colonna è quella delle bande
band<-<c(1,2,3)
#poi ci sarà la colonna forest, con i relativi valori di riflettanza
forest<-c(221,9,23)
#infine creiamo la colonna per l'acqua
water<-c(46,83,163)

#a questo punto non abbiamo ancora creato la tabella, ma abbiamo spiegato che ci sono 3 colonne.
#ora usiamo la funzione data.frame per creare le tabelle

firme<-data.frame(band, forest, water)

#con qiesta funzione abbiamo creato il dataframe

#per vedere il risultato usiamo ggplot

ggplot(firme, aes(x=band))+
geom_line(aes(y=forest), col="green")+
geom_line(aes(y=water), col="light blue")+
labs(x="band", y="reflectance")

#sulla x abbiamo messo le bande, 1,2,3. I valori intermedi che si vedono sono inutili perchè non esistono vie di mezzo nelle bande. Questi volendo si possono eliminare con i fattori
#aggiungiamo anche la funzione labs che ci permette di modificare le etichette sugli assi

#dal plot ottenuto si nota bene quanto l'acqua abbia un comportomento proprio opposto rispetto alla vegetazione

########## Multitemporal ################

defor1<-brick("defor1.jpeg")
plotRGB(defor1, 1, 2, 3, stretch="lin")


#inizio creandomi delle firme spettrali di punti random in defor1
click(defor1, id=T, xy=T, cell=T, type="p", pch=16, cex=4, col="blue")

#la stessa cosa la posso fare con la funzione rmd che mi crea in automatico punti randomizzati

#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 38.5 307.5 121419      192       11       26
#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 55.5 330.5 105014      219       18       34
#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 80.5 324.5 109323      227       24       43
#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 93.5 292.5 132184      213       16       33
#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 70.5 294.5 130733      215       20       36

plotRGB(defor2, 1, 2, 3, stretch="lin")
click(defor2, id=T, xy=T, cell=T, type="p", pch=16, cex=4, col="blue")

#      x     y   cell defor2.1 defor2.2 defor2.3
# 1 53.5 330.5 105453      169      116      112
#      x     y  cell defor2.1 defor2.2 defor2.3
# 1 91.5 347.5 93302      183      125      124
#      x     y  cell defor2.1 defor2.2 defor2.3
# 1 64.5 349.5 91841      178      170      159
#      x     y   cell defor2.1 defor2.2 defor2.3
# 1 92.5 321.5 111945      167      158      141
#      x     y   cell defor2.1 defor2.2 defor2.3
# 1 94.5 279.5 142061      180      172      159

#questo che stiamo usando è un metodo rapido, si potrebbero generare le coordinate di 5 punti e usare quelli sulle due immagini.

#definiamo adesso le colonne del dataset
band<-c(1,2,3)
time1<-c(215,20,36)
time1p2<-c(219,18,34)
time2<-c(180,172,159)
time2p2<-c(183,125,124)
#ho usato i valori dell'ultimo punto di entrambe le immagini.
temporalfirme<-data.frame(band, time1, time1p2, time2, time2p2)

#plottiamo con ggplot
ggplot(temporalfirme, aes(x=band))+
geom_line(aes(y=time1), col="red")+
geom_line(aes(y=time1p2), col="red")+
geom_line(aes(y=time2), col="blue")+
geom_line(aes(y=time2p2), col="blue")+
labs(x="band", y="reflectance")

#nel grafico vediamo come il pixel del time1 c'è la tipica firma di un pixel vegetato, mentre nel time2 è molto cambiata.

#questo procedimento normalmente si fa con moltissimi pixel. si usa una funzione per la generazione dei punti random e poi un'altra per estrarre da tutti i valori delle bande.



# ripetiamo lo stesso esercizio con immagine prese dall'earth observatory. Ho scelto l'immagine della penisola di Banks in Nuova Zelanda.
nz<-brick("nz.jpeg")
plotRGB(nz, 1, 2, 3, stretch="hist")
click(nz, id=T, xy=T, cell=T, type="p", pch=16, cex=4, col="blue")

#        x     y     cell nz.1 nz.2 nz.3
# 1 3254.5 666.5 13402669   40   68   27
#        x     y     cell nz.1 nz.2 nz.3
# 1 3494.5 505.5 14209680  154  155  123
#        x      y    cell nz.1 nz.2 nz.3
# 1 2897.5 1481.5 9318347  149  154   87
#        x      y    cell nz.1 nz.2 nz.3
# 1 2867.5 1922.5 7108466  101  165  151

band<-c(1,2,3)
strato1<-c(40,68,27)
strato2<-c(154,155,123)
strato3<-c(149,154,87)
strato4<-c(101,165,151)

stratofirme<-data.frame(band, strato1, strato2, strato3, strato4)

ggplot(stratofirme, aes(x=band))+
geom_line(aes(y=strato1), col="red")+
geom_line(aes(y=strato2), col="green")+
geom_line(aes(y=strato3), col="blue")+
geom_line(aes(y=strato4), col="black")+
labs(x="band", y="reflectance")

#tutto questo processo serve ad identificare delle classi con sui dividere/classificare la nostra immagine.
