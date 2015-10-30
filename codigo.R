setwd("C:/Users/Marco/Documents/Project vial")
lines<-readLines("IncidentesvialesdelDFeneroaagosto2014-incidentesViales2014.csv")
data<-read.csv("IncidentesvialesdelDFeneroaagosto2014-incidentesViales2014.csv", header=F)
data<-data[grepl("ACV",data$V1),]
data$latitud<-gsub(",.*$","", data$V6)
data$longitud<-gsub(".*,\\s*","",data$V6)
data<-data[data$latitud!=" ",]
data$latitud<-as.numeric(data$latitud)
data$longitud<-as.numeric(data$longitud)
data$hora<-gsub(".* ","",data$V5)
data$hora<-strptime(data$hora, format="%H:%M")
data$hora<- strftime(data$hora, format="%H:%M")
data$fecha<-as.Date(data$V5, format="%d/%m/%Y")
data$mes<-format(data$fecha, "%B")
data$mes<-as.factor(data$mes)

require(ggmap)

mex <- get_map(location = "Mexico city",
                         source = "google",
                         zoom = 12,
                        maptype="roadmap")
ggmap(mex,
      extent = "device",
      ylab = "Latitude",
      xlab = "Longitude")


mexmap <- ggmap(mex, extent = "device", legend = "topleft")

mexmap + 
  geom_density2d(data = data[data$hora>"21:00",], aes(x = longitud, y = latitud), size = 0.3) + 
  stat_density2d(data = data[data$hora>"21:00",], 
                 aes(x = longitud, y = latitud, fill = ..level.., alpha = ..level..), size = 0.01, 
                 bins = 16, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.3), guide = FALSE)

mexmap + 
  geom_density2d(data = data[data$hora<="21:00",], aes(x = longitud, y = latitud), size = 0.3) + 
  stat_density2d(data = data[data$hora<="21:00",], 
                 aes(x = longitud, y = latitud, fill = ..level.., alpha = ..level..), size = 0.01, 
                 bins = 16, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.3), guide = FALSE)


mes<-"febrero"
mexmap + 
  geom_density2d(data = data[data$mes==mes,], aes(x = longitud, y = latitud), size = 0.3) + 
  stat_density2d(data = data[data$mes==mes,], 
                 aes(x = longitud, y = latitud, fill = ..level.., alpha = ..level..), size = 0.01, 
                 bins = 16, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.3), guide = FALSE)

