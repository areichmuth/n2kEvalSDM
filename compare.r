#!/usr/bin/env Rscrip


arg = commandArgs(trailingOnly=TRUE)
source("sourceFunctions.R")

suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(stars))
suppressPackageStartupMessages(library(terra))


path = ""/path/to/Folder/""
species = arg[1]
print(species)
dist = arg[2]
rcp = arg[3]
perc = c('50','5','95') 
period = c('2021_2040', '2041_2060', '2061_2080', '2079_2098')
sitetype = arg[4]

if (toupper(sitetype)=='A' | toupper(sitetype)=='B' | toupper(sitetype)=='C'){
  print(toupper(sitetype))
  poly=st_read('/pathToInputData/Natura2000_end2021_rev1_epsg3035_forest_25perc_100ha_mountain_climate.shp')
  poly = poly %>% filter(SITETYPE==toupper(sitetype))
}else{
  poly=vect('/pathToInputData/Natura2000_end2021_rev1_epsg3035_forest_25perc_100ha_mountain_climate.shp')
}
reference=rast(paste0('/pathToInputData/Prediction_',species,'_1971_1990_',dist,'.tif'))

##rename preds to without _1971_1990
##generate all combinations to iterate through
paramList=expand.grid(species, period, dist, rcp, perc, sitetype, stringsAsFactors = FALSE)

iterate_list <- split(paramList, seq(nrow(paramList)))

purrr::walk(.x=1:nrow(paramList), .f=evalNatura)
