library(googleVis)
library(reshape)
library(shiny)
setwd("C:\\Users\\jota9\\Documents\\ejer2")  
raw.data <- read.csv2("datosEjemplo.csv")
 
raw.data <- subset(raw.data,value > 0 )
## calculos(raw.data)
# (calculos(raw.data))
# List of 2
#  $ grafico:'data.frame':        6 obs. of  25 variables:
#   ..$ Nivel_ed           : Factor w/ 6 levels "Primaria Completa",..: 2 1 4 3 6 5
#   ..$ Buenos Aires       : num [1:6] 90.4 74.1 54.6 34.5 18.2 ...
#   .........
#   ..$ Santa Fe           : num [1:6] 90.4 72.7 53.8 36 18.6 ...
#   ..$ Santiago del Estero: num [1:6] 88.8 63.6 45.5 26.6 12.8 ...
#   ..$ Tierra del Fuego   : num [1:6] 89.1 73.6 63.9 40.1 16.6 ...
#   ..$ Tucuman            : num [1:6] 87.9 67 49.2 29.4 18.4 ...
#  $ tabla  :'data.frame':        24 obs. of  2 variables:
#   ..$ Provincia             : Factor w/ 24 levels "Buenos Aires",..: 1 2 3 4 5 6 7 8 9 10 ...
#   .. ..- attr(*, "names")= chr [1:24] "Buenos Aires" "Capital Federal" "Catamarca" "Chaco" ...
#   ..$ Education Completeness: Factor w/ 24 levels "0.4678","0.4829",..: 22 24 17 1 11 20 8 12 6 16 ...
#   .. ..- attr(*, "names")= chr [1:24] "Buenos Aires" "Capital Federal" "Catamarca" "Chaco" ...

calculos <- function(raw.data) {
    tab <- with(raw.data,prop.table(table(jurisdiccion,nivel_ed),1))
    tab <- as.data.frame.matrix(tab)
    tab <- tab*100
    tab <- round(tab,2)
    tab <- cbind(row.names(tab),tab)
    colnames(tab)[1] <- "Provincia"
    tab <- tab[,-grep("Sin instruccion",colnames(tab))]
    order <- c("Provincia","Primaria Incompleta","Primaria Completa","Secundaria Incompleta","Secundaria Completa",
               "Universitaria Incompleta", "Universitaria Completa")
    
    index <- lapply(order, function(x) grep(x,names(tab)))
    
    tab <- tab[,c(as.numeric(index))]
    
    tab.s <- cbind(tab[,1],sum(tab[,2:7]),sum(tab[,3:7]),sum(tab[,4:7])
                   ,sum(tab[,5:7]),sum(tab[,6:7]),sum(tab[,7]))
    
    tab.2 <- data.frame(rep(0,nrow(tab)),rep(0,nrow(tab)),rep(0,nrow(tab))
                        ,rep(0,nrow(tab)),rep(0,nrow(tab)),rep(0,nrow(tab)))
    
    names(tab.2) <- names(tab)[2:7]
    
    for ( i in 1:6){
      for (j in 1:6){
        if(i >= j){
          tab.2[,j] <- tab.2[,j]+tab[,i+1]
        } 
      }
    }
    tab.pl <- as.data.frame(t(tab.2))
    colnames(tab.pl) <- tab$Provincia
    tab.pl <- cbind(Nivel_ed=names(tab)[2:7],tab.pl)

    #### Area under curve ####
    areas <- rbind(rep(100,ncol(tab.pl)),tab.pl)
    areas[,2:ncol(areas)] <- areas[,2:ncol(areas)]/100
    ed.coef <- (areas[1,-c(1)]+areas[2,-c(1)])/2
    limit <- nrow(areas)-1
    
    for (i in 2:limit){
      j <- i +1
      ed.coef <- ed.coef + (areas[i,-c(1)]+areas[j,-c(1)])/2
    }
    
    ed.coef <- ed.coef/limit
    
    ed.coef <- t(ed.coef)
    ed.coef <- round(ed.coef,4)
    ed.coef <- cbind(colnames(areas)[-c(1)],ed.coef)
    
    ed.coef <- as.data.frame(ed.coef)
    colnames(ed.coef)<-c("Provincia","Education Completeness")

    return(list('grafico' = tab.pl, 'tabla' = ed.coef))
}