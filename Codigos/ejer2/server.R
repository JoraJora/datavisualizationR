library(shiny)


shinyServer(function (input, output) {
  
  data <- reactive({
    a <- raw.data
    a <- droplevels(a)
    return(a)
  })
  
  output$linech <- renderGvis({
    tab <- with(data(),prop.table(table(jurisdiccion,nivel_ed),1))
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
    
    #### Plots ###
    
    line.pl <- gvisLineChart(tab.pl,xvar=colnames(tab.pl)[1],yvar=colnames(tab.pl)[-1],
                             options=list(
                               title="Education Curve",
                               titlePosition='out',
                               hAxis="{slantedText:'true',slantedTextAngle:45}",
                               titleTextStyle="{color:'black',fontName:'Courier'}",
                               legend="{color:'black',fontName:'Courier'}",
                               fontSize="10",
                               chartArea="{left:40,top:30,width:'70%',height:'75%'}",            
                               height=550, width=600))
    
    t1.ed <- gvisTable(ed.coef,
                       options=list(page='enable',fontSize="10",height=300,width=275))
    
    ed.output <- gvisMerge(line.pl,t1.ed,horizontal=TRUE)
    return(ed.output)
  })
  
  outputOptions(output, "linech", suspendWhenHidden = FALSE)
})