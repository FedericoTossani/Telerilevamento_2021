####################
#### Land Cover ####
####################

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
