
for(Model in c("iHadCM3", "ECHAM5-wiso", "GISS-E2-R", "iCESM", "isoGSM")){
  source("1_create_data_speleo_monthly.R")
}

rm(list = ls())

#annual data
source("1_create_data_annual.R")

rm(list = ls())

#down sample data
source("1_create_data_ds.R")

rm(list = ls())
