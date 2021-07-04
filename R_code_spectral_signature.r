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

















