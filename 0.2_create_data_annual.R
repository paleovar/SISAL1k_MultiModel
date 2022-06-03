## annual data
library(plyr)
library(dplyr)
library(PaleoSpec)
library(nest)
library(tidyverse)

source("Functions/monthly_mean.R")

for(MODEL in c("iHadCM3", "ECHAM5-wiso", "GISS-E2-R", "iCESM", "isoGSM")){
  print(MODEL)
  ENTITY_INFO <- read.csv("DATA/SISAL1k_entity_info.csv")
  MONTHLY <- read.csv(paste0("DATA/SISAL1k_monthly_",MODEL,".csv"))
    
  for(entity in ENTITY_INFO$entity_id){
    data_rec <- MONTHLY %>% filter(entity_id == entity)
    data_new = array(dim = c(1000,8))

    data_new[,1] = ENTITY_INFO$site_id[ENTITY_INFO$entity_id == entity]
    data_new[,2] = entity
    data_new[,3] = seq(1100, 101, by = -1)
    data_new[,4] = monthlymean(data_rec$TEMP)
    data_new[,5] = monthlymean(data_rec$PREC)
    data_new[,6] = monthlymean(data_rec$ISOT)
    #ITIF
    data_new[,7] = inf_weighting(data_rec$ISOT, data_rec$PREC, data_rec$EVAP)
    data_new[,8] = monthlymean(data_rec$EVAP)
    colnames(data_new) = c("site_id", "entity_id", "year_BP", 
                           "TEMP", "PREC","ISOT","ITIF","EVAP")
    if(entity == ENTITY_INFO$entity_id[1]){data = data_new}
    else{data = rbind(data, data_new)}
    
  }
  write.csv(data, file = paste0("DATA/SISAL1k_annual_",MODEL,".csv"), row.names = F)
  
}
