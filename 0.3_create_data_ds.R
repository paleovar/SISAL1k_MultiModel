#Down Sampling
## annual data
library(plyr)
library(dplyr)
library(PaleoSpec)
library(nest)
library(tidyverse)

source("Functions/SubsampleTimeseriesBlock_highresNA.R")

for(MODEL in c("iHadCM3", "ECHAM5-wiso", "GISS-E2-R", "iCESM", "isoGSM")){
  print(MODEL)
  ANNUAL <- read.csv(paste0("DATA/SISAL1k_annual_",MODEL,".csv"))
  ENTITY_INFO <- read.csv("DATA/SISAL1k_entity_info.csv")
  DATA_SPELEO <- read.csv("DATA/SISAL1k_recordData.csv")
  DATA_SPELEO$mineralogy = as.character(DATA_SPELEO$mineralogy)
    
  for(entity in ENTITY_INFO$entity_id){
    data_sim <- ANNUAL %>% filter(entity_id == entity)
    data_rec <- DATA_SPELEO %>% filter(entity_id == entity)
    data_new = array(dim = c(length(data_rec$interp_age),13))
    data_new[,1] = ENTITY_INFO$site_id[ENTITY_INFO$entity_id == entity]
    data_new[,2] = entity
    data_new[,3] = data_rec$interp_age
    data_new[,4] = data_rec$mineralogy
    data_new[,5] = data_rec$d18O_measurement
    data_new[,6] = data_rec$d13C_measurement
    #drip water conversion
    
    temp <- as.numeric(SubsampleTimeseriesBlock_highresNA(ts(data = rev(data_sim$TEMP), start = LastElement(data_sim$year_BP), end = FirstElement(data_sim$year_BP)),
                                               data_rec$interp_age))
    dw_eq <- numeric(length(data_rec$interp_age))
    dw_eq_C <- numeric(length(data_rec$interp_age))
    for(jj in 1:length(data_rec$interp_age)){
      if(data_rec$mineralogy[jj] == "calcite"){
        dw_eq[jj] = 1.03092 * (data_rec$d18O_measurement[jj] - ((16.1*1000)/(temp[jj]+273.15)-24.6)) + 30.92
        dw_eq_C[jj] = data_rec$d13C_measurement[jj]
      }else if(data_rec$mineralogy[jj] == "aragonite"){
        dw_eq[jj] = 1.03092 * (data_rec$d18O_measurement[jj] - ((18.34*1000)/(temp[jj]+273.15)-31.954)) + 30.92
        dw_eq_C[jj] = data_rec$d13C_measurement[jj] -1.9
      }else{
        dw_eq[jj] = NA
        dw_eq_C[jj] = NA

      }
    }
    
    data_new[,7]  = dw_eq
    data_new[,8]  = dw_eq_C
    
    #TEMP
    data_new[,9]  = temp
    #PREC
    data_new[,10] = as.numeric(SubsampleTimeseriesBlock_highresNA(ts(data = rev(data_sim$PREC), start = LastElement(data_sim$year_BP), end = FirstElement(data_sim$year_BP)),
                                                                 data_rec$interp_age))
    #ISOT
    data_new[,11] = as.numeric(SubsampleTimeseriesBlock_highresNA(ts(data = rev(data_sim$ISOT), start = LastElement(data_sim$year_BP), end = FirstElement(data_sim$year_BP)),
                                                                  data_rec$interp_age))
    #ITIF
    data_new[,12] = as.numeric(SubsampleTimeseriesBlock_highresNA(ts(data = rev(data_sim$ITIF), start = LastElement(data_sim$year_BP), end = FirstElement(data_sim$year_BP)),
                                                                  data_rec$interp_age))
    #EVAP
    data_new[,13] = as.numeric(SubsampleTimeseriesBlock_highresNA(ts(data = rev(data_sim$EVAP), start = LastElement(data_sim$year_BP), end = FirstElement(data_sim$year_BP)),
                                                                  data_rec$interp_age))
    
    
    colnames(data_new) = c("site_id", "entity_id", "year_BP", "mineralogy", 
                           "d18O_measurement", "d13C_measurement", "d18O_dweq","d13C_dweq",
                           "TEMP", "PREC", "ISOT", "ITIF","EVAP")
    if(entity == ENTITY_INFO$entity_id[1]){data = data_new}
    else{data = rbind(data, data_new)}
    
  }
  write.csv(data, file = paste0("DATA/SISAL1k_ds_",MODEL,".csv"), row.names = F)


}
