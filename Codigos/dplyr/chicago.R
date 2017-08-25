# # Cargar libreria
library(dplyr)
chicago <- readRDS("chicago.rds")
dim(chicago)
head(select(chicago, 1:5))

# # seleccion de columnas por nombre
head(select(chicago, city:dptp))

# # seleccion de columnas por nombre
head(select(chicago, -(city:dptp)))

# # dataframe 
i <- match("city", names(chicago))
j <- match("dptp", names(chicago))
head(chicago[, -(i:j)])

# # filter
chic.f <- filter(chicago, pm25tmean2 > 30)
head(select(chic.f, 1:3, pm25tmean2), 10)

# # Otro filtro
chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)

# # ordenar por la columna
chicago <- arrange(chicago, date)

# # ordenar descenfiente
chicago <- arrange(chicago, desc(date))
head(select(chicago, date, pm25tmean2), 3)


# # renombrar columnas
chicago <- rename(chicago, dewpoint = dptp,
pm25 = pm25tmean2)
names(chicago)[1] <- "Ciudad" 

# # Mutación
chicago <- mutate(chicago,
                  pm25detrend = pm25 - mean(pm25, na.rm=TRUE))
head(select(chicago, pm25, pm25detrend))


# # Mutación  + agregación
chicago <- mutate(chicago,
				 tempcat = factor(1 * (tmpd > 80),
				 labels = c("cold", "hot")))
chicago_sp <- split(chicago, f = chicago$tempcat)
sapply(chicago_sp, function(x) mean(x$pm25, na.rm = TRUE))

hotcold <- group_by(chicago, tempcat)
sumHotCold <- summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE),
          o3 = max(o3tmean2),
          no2 = median(no2tmean2))

chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)
years <- group_by(chicago, year)
sumYears <- summarize(years, pm25 = mean(pm25, na.rm = TRUE),
                      o3 = max(o3tmean2, na.rm = TRUE),
                      no2 = median(no2tmean2, na.rm = TRUE))

# # Operador %>%

chicago %>% mutate(month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% summarize(pm25 = mean(pm25, na.rm = TRUE),
                      o3 = max(o3tmean2, na.rm = TRUE),
                      no2 = median(no2tmean2, na.rm = TRUE))

