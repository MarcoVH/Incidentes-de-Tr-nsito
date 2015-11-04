setwd("C:/Users/Marco/Documents/Project vial")


# Limpiado filas de tabla Incidentes -------------------------------------

incidentesRaw<-readLines("IncidentesvialesdelDFeneroaagosto2014-incidentesViales2014.csv")
marca<-which(apply(as.data.frame(incidentesRaw),1, FUN=nchar)==0)

for(i in marca){
  incidentesRaw[i-1]<-paste(incidentesRaw[i-1],incidentesRaw[i+1], sep=" ")
}
incidentesRaw<-incidentesRaw[-marca]
marca2<-c(marca, marca+1)
incidentesRaw<-incidentesRaw[-marca2]

write.csv(incidentesRaw, "incidentes.txt", row.names=F, col.names=F, quote=F)
incidentes<-read.table("incidentes.txt", sep=",", skip=1)
rm(incidentesRaw)


# Tidy Incidentes ---------------------------------------------------------

incidentes[1,1]<-gsub("﻿","", incidentes[1,1])

colnames(incidentes)<-c("incidente","descripcion_lugar","notas","direccion_o","datetime",
                        "geo")

Incidentes<-as.data.frame(gsub(" .*$","",incidentes$incidente))
colnames(Incidentes)<-c("codigo")
