#!/usr/bin/env Rscrip

renv::load('/home/reichmut/Workspace/modelling')
arg = commandArgs(trailingOnly=TRUE)
source("~/Workspace/modelling/sourceFunctions.R")

suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(stars))
suppressPackageStartupMessages(library(terra))


path = "/work/reichmut/Modelling/"
species = arg[1]
print(species)
dist = 20
rcp = arg[2]
perc = c('50','5','95') #'50','5',
period = c('2079_2098', '2021_2040', '2041_2060', '2061_2080') # '2021_2040', '2041_2060',
sitetype = arg[3]

if (toupper(sitetype)=='A' | toupper(sitetype)=='B' | toupper(sitetype)=='C'){
  print(toupper(sitetype))
  poly=st_read('/data/satellite/forestProjection/sdm/Modelling/natura2000/poly/Natura2000_end2021_rev1_epsg3035_forest_25perc_100ha_mountain_climate.shp')
  poly = poly %>% filter(SITETYPE==toupper(sitetype))
}else{
  poly=vect('/data/satellite/forestProjection/sdm/Modelling/natura2000/poly/Natura2000_end2021_rev1_epsg3035_forest_25perc_100ha_mountain_climate.shp')
}
reference=rast(paste0('/data/satellite/forestProjection/sdm/Modelling/prediction/reference/tif/Prediction_',species,'_1971_1990_',dist,'.tif'))

##rename preds to without _1971_1990
##generate all combinations to iterate through
paramList=expand.grid(species, period, dist, rcp, perc, sitetype, stringsAsFactors = FALSE)
#make nested list for calling in parallel computing
iterate_list <- split(paramList, seq(nrow(paramList)))

purrr::walk(.x=1:nrow(paramList), .f=evalNatura)