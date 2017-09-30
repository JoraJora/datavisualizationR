 # #  Esto es una prueba 
library(dplyr)
library(tidyr)
datos <- dataOne %>% select(user_email,ends_with("completed")) %>% 
  gather(curse,Date,-user_email) 
class(datos$Date)
datos$Date <- as.Date(datos$Date, format = "%m/%d/%Y")

table(datos$curse)

datos <- datos %>% filter(curse %in% c("introduction_to_r_completed", 
"intermediate_r_completed", 
"data_manipulation_in_r_with_dplyr_completed", 
"data_analysis_in_r._the_data.table_way_completed" ,
"writing_functions_in_r_completed",
"data_visualization_with_ggplot2_.part_1._completed",
"data_visualization_with_ggplot2_.part_2._completed",
"data_visualization_with_ggplot2_.part_3._completed"))

Fechas <- data.frame(curse = as.character(c("introduction_to_r_completed", 
                               "intermediate_r_completed", 
                               "data_manipulation_in_r_with_dplyr_completed", 
                               "data_analysis_in_r._the_data.table_way_completed" ,
                               "writing_functions_in_r_completed",
                               "data_visualization_with_ggplot2_.part_1._completed",
                               "data_visualization_with_ggplot2_.part_2._completed",
                               "data_visualization_with_ggplot2_.part_3._completed")),
                     
                     Fechaplaz = c("08/20/2017","08/20/2017","08/26/2017",
                                    "09/02/2017","09/10/2017","09/24/2017",
                                    "09/24/2017","09/25/2017"))


Fechas$Fechaplaz <- as.Date(Fechas$Fechaplaz, format = "%m/%d/%Y")

datos2 <- datos %>% left_join(Fechas,by = "curse") %>% mutate(retraso = Date - Fechaplaz) %>%
  mutate(Nota = ifelse(retraso < 0,5,5-0.5*retraso)) %>% 
  mutate(Nota = ifelse(Nota < 3 & !is.na(retraso),3,Nota)) %>% 
  mutate(Nota = ifelse(is.na(retraso),0,Nota))

notascamp <- dataOne %>% select(user_email,ends_with("grade")) %>% 
  gather(curse,NoteCamp,-user_email) %>% filter(curse %in% c("introduction_to_r_grade", 
                                                             "intermediate_r_grade", 
                                                             "data_manipulation_in_r_with_dplyr_grade", 
                                                             "data_analysis_in_r._the_data.table_way_grade" ,
                                                             "writing_functions_in_r_grade",
                                                             "data_visualization_with_ggplot2_.part_1._grade",
                                                             "data_visualization_with_ggplot2_.part_2._grade",
                                                             "data_visualization_with_ggplot2_.part_3._grade"))

datos2$notacamp <- notascamp$NoteCamp
datos2$Notafin <- datos2$Nota * datos2$notacamp
names(datos2) 
datos2 <- datos2[,c(1,2,8)]

datos3 <- datos2 %>% group_by(user_email) %>% summarise(NotaProm = mean(Notafin))
datos4 <- merge(dcast(datos2, user_email ~ curse), datos3, by = "user_email")
write.table(datos4, "clipboard", sep = "\t",  row.names = FALSE, dec = ".")