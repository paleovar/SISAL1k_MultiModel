#################################################
## CREATE DATASET ###############################
#################################################

library(plyr)
library(dplyr)
library(PaleoSpec)
library(nest)
library(tidyverse)

print(Model)

#################################################
##0.1) Set Data-Structure?#######################
#################################################

DATA_past1000 <- list(
  CAVES = list(),
  MODEL = list(lon = numeric(), lat = numeric())
)

#################################################
## 1) Read in Model DATA ########################
#################################################

source("Functions/clear_data_matrix.R")
source("Functions/monthly_mean.R")

if(Model == "iHadCM3"){
  ncf <- ncdf4::nc_open("DATA/Sim_data/iHadCM3_tsurf_850-1849.nc")
  DATA_past1000$MODEL$TEMP <- clear_data_matrix_neighbour(ncdf4::ncvar_get(ncf),"TEMP")-273.15
  DATA_past1000$MODEL$lon <- ncdf4::ncvar_get(ncf, 'longitude')
  DATA_past1000$MODEL$lat <- ncdf4::ncvar_get(ncf, 'latitude')
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/iHadCM3_prec_850-1849.nc")
  DATA_past1000$MODEL$PREC <- clear_data_matrix_neighbour(ncdf4::ncvar_get(ncf),"PREC")*12
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/iHadCM3_d18O_850-1849.nc")
  DATA_past1000$MODEL$ISOT <- clear_data_matrix_neighbour(ncdf4::ncvar_get(ncf),"ISOT")
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/iHadCM3_lath_850-1849.nc")
  DATA_past1000$MODEL$LATH <- ncdf4::ncvar_get(ncf)
  ncdf4::nc_close(ncf)
  
  DATA_past1000$MODEL$EVAP <- array(dim = c(96,73,12000))

  for(lon in 1:96){
    for(lat in 1:73){
      for(time in 1:12000){
        if(is.na(DATA_past1000$MODEL$TEMP[lon,lat,time])){
          DATA_past1000$MODEL$EVAP[lon,lat,time] = NA
        }else if(DATA_past1000$MODEL$TEMP[lon,lat,time]<0){
          DATA_past1000$MODEL$EVAP[lon,lat,time] = DATA_past1000$MODEL$LATH[lon,lat,time]/(2257000+4200*(100-DATA_past1000$MODEL$TEMP[lon,lat,time])+333500)*12
        }else{
          DATA_past1000$MODEL$EVAP[lon,lat,time] = DATA_past1000$MODEL$LATH[lon,lat,time]/(2257000+4200*(100-DATA_past1000$MODEL$TEMP[lon,lat,time]))*12
        }
      }
    }
  }
  
  for(VAR in c("TEMP", "PREC", "ISOT", "EVAP")){
    ANNUAL = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
    
    if(VAR == "ISOT"){
      ANNUAL_PW = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
      ANNUAL_IW = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
    }
    
    for(lon in 1:dim(DATA_past1000$MODEL[[VAR]])[1]){
      if(lon%%10==0){print(lon)}
      for(lat in 1:dim(DATA_past1000$MODEL[[VAR]])[2]){
        ANNUAL[lon,lat,] = zoo::rollapply(DATA_past1000$MODEL[[VAR]][lon,lat,],12,mean, by = 12, na.rm = T)
        if(VAR == "ISOT"){
          ANNUAL_PW[lon,lat,] = prec_weighting(DATA_past1000$MODEL[[VAR]][lon,lat,], DATA_past1000$MODEL$PREC[lon,lat,])
          ANNUAL_IW[lon,lat,] =  inf_weighting(DATA_past1000$MODEL[[VAR]][lon,lat,], 
                                               DATA_past1000$MODEL$PREC[lon,lat,], 
                                               DATA_past1000$MODEL$EVAP[lon,lat,])
        }
      }
    }
    
    save(ANNUAL, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_",VAR,".RData"))
    if(VAR == "ISOT"){
      save(ANNUAL_PW, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_ITPC.RData"))
      save(ANNUAL_IW, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_ITIF.RData"))
    }
  }
  
  
}else if(Model == "ECHAM5-wiso"){
  ncf <- ncdf4::nc_open("DATA/Sim_data/ECHAM5-wiso_tsurf_850-1849.nc")
  DATA_past1000$MODEL$TEMP <- clear_data_matrix_neighbour(ncdf4::ncvar_get(ncf)-273.15, "TEMP")
  DATA_past1000$MODEL$lon <- ncdf4::ncvar_get(ncf, 'lon')
  DATA_past1000$MODEL$lat <- ncdf4::ncvar_get(ncf, 'lat')
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/ECHAM5-wiso_prec_850-1849.nc")
  DATA_past1000$MODEL$PREC <- clear_data_matrix_neighbour(ncdf4::ncvar_get(ncf)*12, "PREC")
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/ECHAM5-wiso_d18O_850-1849.nc")
  DATA_past1000$MODEL$ISOT <- clear_data_matrix_neighbour(ncdf4::ncvar_get(ncf), "ISOT")
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/ECHAM5-wiso_evap_850-1849.nc")
  DATA_past1000$MODEL$EVAP <- ncdf4::ncvar_get(ncf)*12
  ncdf4::nc_close(ncf)
  
  print("ANNUAL")
  for(VAR in c("TEMP", "PREC", "ISOT", "EVAP")){
    ANNUAL = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
    
    if(VAR == "ISOT"){
      ANNUAL_PW = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
      ANNUAL_IW = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
    }
    
    for(lon in 1:dim(DATA_past1000$MODEL[[VAR]])[1]){
      if(lon%%10==0){print(lon)}
      for(lat in 1:dim(DATA_past1000$MODEL[[VAR]])[2]){
        ANNUAL[lon,lat,] = zoo::rollapply(DATA_past1000$MODEL[[VAR]][lon,lat,],12,mean, by = 12, na.rm = T)
        if(VAR == "ISOT"){
          ANNUAL_PW[lon,lat,] = prec_weighting(DATA_past1000$MODEL[[VAR]][lon,lat,], DATA_past1000$MODEL$PREC[lon,lat,])
          ANNUAL_IW[lon,lat,] =  inf_weighting(DATA_past1000$MODEL[[VAR]][lon,lat,], 
                                               DATA_past1000$MODEL$PREC[lon,lat,], 
                                               DATA_past1000$MODEL$EVAP[lon,lat,])
        }
      }
    }
    
    save(ANNUAL, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_",VAR,".RData"))
    if(VAR == "ISOT"){
      save(ANNUAL_PW, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_ITPC.RData"))
      save(ANNUAL_IW, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_ITIF.RData"))
    }
  }
  
}else if(Model == "GISS-E2-R"){
  library(abind)
  ncf <- ncdf4::nc_open("DATA/Sim_data/GISS-E2-R_tsurf_850-1849.nc")
  DATA_past1000$MODEL$TEMP <- clear_data_matrix_neighbour(abind(ncdf4::ncvar_get(ncf)[73:144,90:1,],ncdf4::ncvar_get(ncf)[1:72,90:1,], along = 1)-273.15, "TEMP")
  DATA_past1000$MODEL$lon <- ncdf4::ncvar_get(ncf, 'lon')+180
  DATA_past1000$MODEL$lat <- ncdf4::ncvar_get(ncf, 'lat')[90:1]
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/GISS-E2-R_prec_850-1849.nc")
  DATA_past1000$MODEL$PREC <- clear_data_matrix_neighbour(abind(ncdf4::ncvar_get(ncf)[73:144,90:1,],ncdf4::ncvar_get(ncf)[1:72,90:1,], along = 1)*12, "PREC")
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/GISS-E2-R_d18O_850-1849.nc")
  DATA_past1000$MODEL$ISOT <- clear_data_matrix_neighbour(abind(ncdf4::ncvar_get(ncf)[73:144,90:1,],ncdf4::ncvar_get(ncf)[1:72,90:1,], along = 1), "ISOT")
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/GISS-E2-R_evap_850-1849.nc")
  DATA_past1000$MODEL$EVAP <- clear_data_matrix_neighbour(abind(ncdf4::ncvar_get(ncf)[73:144,90:1,],ncdf4::ncvar_get(ncf)[1:72,90:1,], along = 1)*12, "PREC")
  ncdf4::nc_close(ncf)
  
  print("ANNUAL")
  for(VAR in c("TEMP", "PREC", "ISOT", "EVAP")){
    ANNUAL = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
    
    if(VAR == "ISOT"){
      ANNUAL_PW = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
      ANNUAL_IW = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
    }
    
    for(lon in 1:dim(DATA_past1000$MODEL[[VAR]])[1]){
      if(lon%%10==0){print(lon)}
      for(lat in 1:dim(DATA_past1000$MODEL[[VAR]])[2]){
        ANNUAL[lon,lat,] = zoo::rollapply(DATA_past1000$MODEL[[VAR]][lon,lat,],12,mean, by = 12, na.rm = T)
        if(VAR == "ISOT"){
          ANNUAL_PW[lon,lat,] = prec_weighting(DATA_past1000$MODEL[[VAR]][lon,lat,], DATA_past1000$MODEL$PREC[lon,lat,])
          ANNUAL_IW[lon,lat,] =  inf_weighting(DATA_past1000$MODEL[[VAR]][lon,lat,], 
                                               DATA_past1000$MODEL$PREC[lon,lat,], 
                                               DATA_past1000$MODEL$EVAP[lon,lat,])
        }
      }
    }
    
    save(ANNUAL, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_",VAR,".RData"))
    if(VAR == "ISOT"){
      save(ANNUAL_PW, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_ITPC.RData"))
      save(ANNUAL_IW, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_ITIF.RData"))
    }
  }
  
}else if(Model == "iCESM"){
  ncf <- ncdf4::nc_open("DATA/Sim_data/iCESM_tsurf_850-1849.nc")
  DATA_past1000$MODEL$TEMP <- clear_data_matrix_neighbour(ncdf4::ncvar_get(ncf)[,96:1,1:12000]-273.15, "TEMP")
  DATA_past1000$MODEL$lon <- ncdf4::ncvar_get(ncf, 'lon')
  DATA_past1000$MODEL$lat <- ncdf4::ncvar_get(ncf, 'lat')[94:1]
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/iCESM_prec_850-1849.nc")
  DATA_past1000$MODEL$PREC <- clear_data_matrix_neighbour(ncdf4::ncvar_get(ncf)[,96:1,1:12000]*12, "PREC")
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/iCESM_d18O_850-1849.nc")
  DATA_past1000$MODEL$ISOT <- clear_data_matrix_neighbour(ncdf4::ncvar_get(ncf)[,96:1,1:12000], "ISOT")
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/iCESM_lath_850-1849.nc")
  DATA_past1000$MODEL$LATH <- ncdf4::ncvar_get(ncf)
  ncdf4::nc_close(ncf)
  
  DATA_past1000$MODEL$EVAP <- array(dim = c(144,96,12000))
  
  for(lon in 1:144){
    for(lat in 1:96){
      for(time in 1:12000){
        if(is.na(DATA_past1000$MODEL$TEMP[lon,lat,time])){
          DATA_past1000$MODEL$EVAP[lon,lat,time] = NA
        }else if(DATA_past1000$MODEL$TEMP[lon,lat,time]<0){
          DATA_past1000$MODEL$EVAP[lon,lat,time] = DATA_past1000$MODEL$LATH[lon,lat,time]/(2257000+4200*(100-DATA_past1000$MODEL$TEMP[lon,lat,time])+333500)*12
        }else{
          DATA_past1000$MODEL$EVAP[lon,lat,time] = DATA_past1000$MODEL$LATH[lon,lat,time]/(2257000+4200*(100-DATA_past1000$MODEL$TEMP[lon,lat,time]))*12
        }
      }
    }
  }

  
  print("ANNUAL")
  for(VAR in c("TEMP", "PREC", "ISOT", "EVAP")){
    ANNUAL = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
    
    if(VAR == "ISOT"){
      ANNUAL_PW = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
      ANNUAL_IW = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
    }
    
    for(lon in 1:dim(DATA_past1000$MODEL[[VAR]])[1]){
      if(lon%%10==0){print(lon)}
      for(lat in 1:dim(DATA_past1000$MODEL[[VAR]])[2]){
        ANNUAL[lon,lat,] = zoo::rollapply(DATA_past1000$MODEL[[VAR]][lon,lat,],12,mean, by = 12, na.rm = T)
        if(VAR == "ISOT"){
          ANNUAL_PW[lon,lat,] = prec_weighting(DATA_past1000$MODEL[[VAR]][lon,lat,], DATA_past1000$MODEL$PREC[lon,lat,])
          ANNUAL_IW[lon,lat,] =  inf_weighting(DATA_past1000$MODEL[[VAR]][lon,lat,], 
                                               DATA_past1000$MODEL$PREC[lon,lat,], 
                                               DATA_past1000$MODEL$EVAP[lon,lat,])
        }
      }
    }
    
    save(ANNUAL, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_",VAR,".RData"))
    if(VAR == "ISOT"){
      save(ANNUAL_PW, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_ITPC.RData"))
      save(ANNUAL_IW, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_ITIF.RData"))
    }
  }
  
}else if(Model == "isoGSM"){
  ncf <- ncdf4::nc_open("DATA/Sim_data/isoGSM_tsurf_850-1849.nc")
  DATA_past1000$MODEL$TEMP <- clear_data_matrix_neighbour(ncdf4::ncvar_get(ncf)[,94:1,]-273.15, "TEMP")
  DATA_past1000$MODEL$lon <- ncdf4::ncvar_get(ncf, 'longitude')
  DATA_past1000$MODEL$lat <- ncdf4::ncvar_get(ncf, 'latitude')[94:1]
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/isoGSM_prec_850-1849.nc")
  DATA_past1000$MODEL$PREC <- clear_data_matrix_neighbour(ncdf4::ncvar_get(ncf)[,94:1,]*86400*360, "PREC")
  ncdf4::nc_close(ncf)
  ncf <- ncdf4::nc_open("DATA/Sim_data/isoGSM_d18O_850-1849.nc")
  DATA_past1000$MODEL$ISOT <- clear_data_matrix_neighbour(ncdf4::ncvar_get(ncf)[,94:1,], "ISOT")
  ncdf4::nc_close(ncf)
  DATA_past1000$MODEL$ISOT[DATA_past1000$MODEL$PREC < 0.5] = NA
  ncf <- ncdf4::nc_open("DATA/Sim_data/isoGSM_lath_850-1849.nc")
  DATA_past1000$MODEL$LATH <- ncdf4::ncvar_get(ncf)[,94:1,]
  ncdf4::nc_close(ncf)
  
  DATA_past1000$MODEL$EVAP <- array(dim = c(192,94,12000))
  
  print("ANNUAL")
  for(lon in 1:192){
    for(lat in 1:94){
      for(time in 1:12000){
        if(is.na(DATA_past1000$MODEL$TEMP[lon,lat,time])){
          DATA_past1000$MODEL$EVAP[lon,lat,time] = NA
        }else if(DATA_past1000$MODEL$TEMP[lon,lat,time]<0){
          DATA_past1000$MODEL$EVAP[lon,lat,time] = DATA_past1000$MODEL$LATH[lon,lat,time]/(2257000+4200*(100-DATA_past1000$MODEL$TEMP[lon,lat,time])+333500)*12
        }else{
          DATA_past1000$MODEL$EVAP[lon,lat,time] = DATA_past1000$MODEL$LATH[lon,lat,time]/(2257000+4200*(100-DATA_past1000$MODEL$TEMP[lon,lat,time]))*12
        }
      }
    }
  }
  
  for(VAR in c("TEMP", "PREC", "ISOT", "EVAP")){
    ANNUAL = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
    
    if(VAR == "ISOT"){
      ANNUAL_PW = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
      ANNUAL_IW = array(dim = c(dim(DATA_past1000$MODEL[[VAR]])[c(1,2)], floor(dim(DATA_past1000$MODEL[[VAR]])[3]/12)))
    }
    
    for(lon in 1:dim(DATA_past1000$MODEL[[VAR]])[1]){
      if(lon%%10==0){print(lon)}
      for(lat in 1:dim(DATA_past1000$MODEL[[VAR]])[2]){
        ANNUAL[lon,lat,] = zoo::rollapply(DATA_past1000$MODEL[[VAR]][lon,lat,],12,mean, by = 12, na.rm = T)
        if(VAR == "ISOT"){
          ANNUAL_PW[lon,lat,] = prec_weighting(DATA_past1000$MODEL[[VAR]][lon,lat,], DATA_past1000$MODEL$PREC[lon,lat,])
          ANNUAL_IW[lon,lat,] =  inf_weighting(DATA_past1000$MODEL[[VAR]][lon,lat,], 
                                               DATA_past1000$MODEL$PREC[lon,lat,], 
                                               DATA_past1000$MODEL$EVAP[lon,lat,])
        }
      }
    }
    
    save(ANNUAL, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_",VAR,".RData"))
    if(VAR == "ISOT"){
      save(ANNUAL_PW, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_ITPC.RData"))
      save(ANNUAL_IW, file = paste0("DATA/Annual_VarFields/Annual_",Model,"_ITIF.RData"))
    }
  }
}

#################################################
##2) SISAL TIME SERIES ##########################
#################################################

# needs to be imported first, as then only the relevant cave sites will be extracted and calculated further
print("...SISAL extracting")
load("DATA/SISAL_raw_data.RData")

DATA_past1000$CAVES$site_info <- read.csv("DATA/site.csv")  
DATA_past1000$CAVES$entity_info <- list()
DATA_past1000$CAVES$record_data <- list()

DATA_past1000$CAVES$entity_info <- data[[1]]

DATA_past1000$CAVES$site_info <- DATA_past1000$CAVES$site_info %>% filter(site_id %in% DATA_past1000$CAVES$entity_info$site_id)
for (ii in DATA_past1000$CAVES$entity_info$entity_id){
  name = paste0("ENTITY", ii)
  site <- DATA_past1000$CAVES$entity_info %>% filter(entity_id == ii) %>% distinct(site_id)
  DATA_past1000$CAVES$record_data[[name]] <- data[[2]] %>% filter(entity_id == ii) %>% distinct(entity_id, mineralogy, interp_age, d18O_measurement, d13C_measurement) %>%
    mutate(site_id = (site$site_id))
}
if(Model == "iHadCM3"){
  #write csv file
  write.csv(data[[1]], file = paste0("DATA/SISAL1k_entity_info.csv"), row.names = F)
  write.csv(data[[2]], file = paste0("DATA/SISAL1k_recordData.csv"), row.names = F)
  
}

remove(data, site, ii, name, load_sisal_data)


#################################################
## 3) Extract data from Caves such that they are in a grid box that is the average of all surrounding
#################################################

print("...DATA extract")
source("Functions/extract_gridboxes_v2.R")

#for(Model in c("iHadCM3", "ECHAM5-wiso", "isoGSM", "iCESM", "GISS-E2-R")){
for (ii in 1:(length(DATA_past1000$CAVES$entity_info$entity_id))){
  lon_cave = DATA_past1000$CAVES$entity_info$longitude[ii]
  
  if(lon_cave<0){lon_cave = 360+lon_cave}
  
  lat_cave = DATA_past1000$CAVES$entity_info$latitude[ii]
  
  ratios <- extract_gridboxes_2(lon_cave, lat_cave, d.lon = 360/length(DATA_past1000$MODEL$lon), d.lat = 180/length(DATA_past1000$MODEL$lat))
  name <- paste0("ENTITY",DATA_past1000$CAVES$entity_info$entity_id[ii])
  
  for(var in c("TEMP", "PREC", "ISOT", "EVAP")){
    if(is.null(DATA_past1000$MODEL[[var]])){next}
    else{
      DATA_past1000$CAVES$sim_data[[name]][[var]] <- rowSums(cbind(ratios$Q11*DATA_past1000$MODEL[[var]][ratios$Q11_lon, ratios$Q11_lat,],
                                                                            ratios$Q12*DATA_past1000$MODEL[[var]][ratios$Q12_lon, ratios$Q12_lat,],
                                                                            ratios$Q21*DATA_past1000$MODEL[[var]][ratios$Q21_lon, ratios$Q21_lat,],
                                                                            ratios$Q22*DATA_past1000$MODEL[[var]][ratios$Q22_lon, ratios$Q22_lat,]))
    }
  }
}

DATA_past1000$MODEL <- NULL

remove(ratios, ii, lat_cave, lon_cave, name, extract_gridboxes_2, var)

#################################################
## UMWANDLUNGEN

DATA_past1000$CAVES$site_info <- DATA_past1000$CAVES$site_info %>% mutate(elevation = as.numeric(as.character(elevation)))

#################################################
## DATA EXPORT

# Yearly Data
print("...write csv file")
MONTHLY <- list()
for(entity in sort(DATA_past1000$CAVES$entity_info$entity_id)){
  data_new = array(dim = c(12000,7))
  data_new[,1] = DATA_past1000$CAVES$entity_info$site_id[DATA_past1000$CAVES$entity_info$entity_id == entity]
  data_new[,2] = entity
  data_new[,3] = seq(1100, 100+1/12, by = -1/12)
  if(is.null(DATA_past1000$CAVES$sim_data[[paste0("ENTITY", entity)]]$TEMP)){
    data_new[,4] = numeric(12000)+NA
  }else{
    data_new[,4] = DATA_past1000$CAVES$sim_data[[paste0("ENTITY", entity)]]$TEMP[1:12000]
  }
  if(is.null(DATA_past1000$CAVES$sim_data[[paste0("ENTITY", entity)]]$PREC)){
    data_new[,5] = numeric(12000)+NA
  }else{
    data_new[,5] = DATA_past1000$CAVES$sim_data[[paste0("ENTITY", entity)]]$PREC[1:12000]
  }
  if(is.null(DATA_past1000$CAVES$sim_data[[paste0("ENTITY", entity)]]$ISOT)){
    data_new[,6] = numeric(12000)+NA
  }else{
    data_new[,6] = DATA_past1000$CAVES$sim_data[[paste0("ENTITY", entity)]]$ISOT[1:12000]
  }
  if(is.null(DATA_past1000$CAVES$sim_data[[paste0("ENTITY", entity)]]$EVAP)){
    data_new[,7] = numeric(12000)+NA
  }else{
    data_new[,7] = DATA_past1000$CAVES$sim_data[[paste0("ENTITY", entity)]]$EVAP[1:12000]
  }
  
  colnames(data_new) = c("site_id", "entity_id", "year_BP", "TEMP", "PREC", "ISOT", "EVAP")
  
  
  if(entity == 14){data = data_new}
  else{data = rbind(data, data_new)}
  
}
print("...almost done...file writing")
DATA_EXPORT_MONTHLY <- data
write.csv(DATA_EXPORT_MONTHLY, file = paste0("DATA/SISAL1k_monthly_",Model,".csv"), row.names = F)


