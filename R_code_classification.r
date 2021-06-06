######################
### Classification ###
######################

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

#finita lezione del 21.04

