####################################################################################################
####################################################################################################
## Set environment variables
## Contact remi.dannunzio@fao.org 
## 2018/05/04
####################################################################################################
####################################################################################################

####################################################################################################
options(stringsAsFactors = FALSE)

packages <- function(x){
  x <- as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}
packages(gfcanalysis)
packages(Hmisc)

### Load necessary packages
library(raster)
library(rgeos)
library(ggplot2)
library(rgdal)

## Set the working directory
rootdir       <- "~/ws_nga_20180717/"
gfcstore_dir  <- "~/downloads/gfc_2016/"
esa_folder    <- "~/downloads/ESA_2016/"
the_country   <- "NGA"

setwd(rootdir)
rootdir <- paste0(getwd(),"/")

scriptdir<- paste0(rootdir,"scripts/")
data_dir <- paste0(rootdir,"data/")
gadm_dir <- paste0(rootdir,"data/gadm/")
gfc_dir  <- paste0(rootdir,"data/gfc/")
lsat_dir <- paste0(rootdir,"data/mosaic_lsat/")
seg_dir  <- paste0(rootdir,"data/segments/")
dd_dir   <- paste0(rootdir,"data/dd_map/")
lc_dir   <- paste0(rootdir,"data/forest_mask/")
esa_dir  <- paste0(rootdir,"data/esa/")

dir.create(data_dir,showWarnings = F)
dir.create(gadm_dir,showWarnings = F)
dir.create(gfc_dir,showWarnings = F)
dir.create(lsat_dir,showWarnings = F)
dir.create(seg_dir,showWarnings = F)
dir.create(dd_dir,showWarnings = F)
dir.create(lc_dir,showWarnings = F)
dir.create(esa_dir,showWarnings = F)
dir.create(gfcstore_dir,showWarnings = F)
dir.create(esa_folder,showWarnings = F)

#################### GFC PRODUCTS
gfc_threshold <- 15

#################### PRODUCTS AT THE THRESHOLD
gfc_tc       <- paste0(gfc_dir,"gfc_th",gfc_threshold,"_tc.tif")
gfc_ly       <- paste0(gfc_dir,"gfc_th",gfc_threshold,"_ly.tif")
gfc_gn       <- paste0(gfc_dir,"gfc_gain.tif")
gfc_16       <- paste0(gfc_dir,"gfc_th",gfc_threshold,"_F_2016.tif")
gfc_00       <- paste0(gfc_dir,"gfc_th",gfc_threshold,"_F_2000.tif")
gfc_mp       <- paste0(gfc_dir,"gfc_map_2000_2014_th",gfc_threshold,".tif")
gfc_mp_crop  <- paste0(gfc_dir,"gfc_map_2000_2014_th",gfc_threshold,"_crop.tif")
