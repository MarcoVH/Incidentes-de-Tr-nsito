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
data$dia<-weekdays(data$fecha)

data$hora2<-gsub(".* ","",data$V5)
data$hora2<-strptime(data$hora2, format="%H:%M")
data$hora2<- format(round(data$hora2, units="hours"), format="%H:%M")

data$lat<-round(data$latitud,3)
data$lon<-round(data$longitud,3)
data$count<-1

Tab<-aggregate(data$count, by=list(data$lon, data$lat), FUN=sum)
colnames(Tab)<-c("lon","lat","count")
Tab<-Tab[order(Tab$count, decreasing=T),]
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

mexmap + geom_point(data=Tab, aes(x=lon, y=lat ,size=Tab$count), color = "darkred", alpha=.8)


#
mexmap + 
  geom_density2d(data = data[data$hora>"21:00",], aes(x = longitud, y = latitud), size = 0.3) + 
  stat_density2d(data = data[data$hora>"21:00",], 
                 aes(x = longitud, y = latitud, fill = ..level.., alpha = ..level..), size = 0.01, 
                 bins = 16, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.3), guide = FALSE)



